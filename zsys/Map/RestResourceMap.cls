Class zsys.Map.RestResourceMap Extends %CSP.REST
{
	Parameter HandleCorsRequest=1;
	
	XData UrlMap[ XMLNamespace = "http://www.intersystems.com/urlmap" ]{
		<Routes>
		<Route Url="/update" Method="POST" Call="Update"/>
		<Route Url="/group" Method="POST" Call="CreateGroup"/>
		<Route Url="/group/:gname/:serverIP" Method="PUT" Call="PutServerIntoGroup"/>
		<Route Url="/group/:gname/:serverIP" Method="DELETE" Call="RemoveServerFromGroup"/>
		<Route Url="/groups" Method="GET" Call="GetAllGroups"/>
		<Route Url="/attributes/:serverIP/:attributes" Method="PUT" Call="PutAttributesIntoServer"/>
		<Route Url="/attributes/:serverIP" Method="GET" Call="PutDefaultAttributesIntoServer"/>
		<Route Url="/servers" Method="GET" Call="GetAllServers"/>
		<Route Url="/alerts" Method="GET" Call="GetAllAlerts"/>
		<Route Url="/alerts/:type/:timeStamp" Method="DELETE" Call="DeleteAnAlert"/>
		</Routes>
	}

	// Update status data
	ClassMethod Update() as %Status{
		set statusData={}.%FromJSON($Get(%request.Data("StatusData",1)))
		
		// Create server if not exist
		if ('..IsServerExist(statusData.SystemId)){
			set newServer=##class(zsys.RAM.OperationalServers).%New()
			set newServer.SystemId=statusData.SystemId
			set newServer.IPAddress=statusData.IPAddress
			set saveStatus = newServer.%Save()
			if $$$ISERR(saveStatus){
				do $system.OBJ.DisplayError()
			}
		}
		
		// Trigger business service
        set status = ##class(Ens.Director).CreateBusinessService("StatusDataService",.instance)
        if $$$ISOK(status) {
               #dim response as %DynamicObject
               set status = instance.OnProcessInput(statusData)
               if $$$ISERR(status){
					set %response.Status=400
					do $system.OBJ.DisplayError()
					w "Something is wrong with business production."
					return $$$OK
				}
        }
		
		// Persist status data to DocDB
        set homeData=##class(zsys.RAM.HomeData).%New()
        set homeData.SystemId=statusData.SystemId
        set homeData.GroupName=statusData.GroupName
        set homeData.StatusData=statusData
        do homeData.PersistToDocDB()
        do homeData.%Save()
		
		set server=##class(zsys.RAM.OperationalServers).SystemIdIdxOpen(statusData.SystemId)

		// Send reponse with groupname and attributes
		set response={}
		set response.GroupName=server.Groups.GroupName
		set response.Attributes=server.Attributes
		write response.%ToJSON()
		
		set server=""
		return $$$OK
	}
	
	// Create a new group with description and initial IP
	ClassMethod CreateGroup() as %Status{
		set groupMeta = {}.%FromJSON(%request.Content)
		set res={}
		
		if ('..IsServerExist(groupMeta.SystemId)){
			set %response.Status=400
			w "The server does not exist."
			return $$$OK
		}
		
		if (..IsServerGroupAssigned(groupMeta.SystemId)){
			set %response.Status=400
			w "The server is already in a group."
			return $$$OK
		}
		
		set newGroup=##class(zsys.RAM.Groups).%New()
		set newGroup.GroupName=groupMeta.GroupName
		set newGroup.Description=groupMeta.Description
		
		set server=##class(zsys.RAM.OperationalServers).SystemIdIdxOpen(groupMeta.SystemId)
		
		do newGroup.OperationalServers.Insert(server)
		
		set saveStatus = newGroup.%Save()
		if $$$ISERR(saveStatus){
			if ($system.Status.GetErrorCodes(saveStatus)="5808"){
				set %response.Status=400
				do $system.OBJ.DisplayError()
				w "The name is not unique."
				return $$$OK
			}
		}
		
		set %response.Status=201
		
		set server=""
		set group=""
		return $$$OK
	}
	
	// Add new server into a group
	ClassMethod PutServerIntoGroup(pGname,pServerIP) as %Status{
		
		if ('..IsGroupExist(pGname)){
			set %response.Status=400
			w "The group does not exist."
			return $$$OK
		}
		
		if ('..IsServerExist(pServerIP)){
			set %response.Status=400
			w "The server does not exist."
			return $$$OK
		}
		
		if (..IsServerGroupAssigned(pServerIP)){
			do ..RemoveServerFromGroup(##class(zsys.RAM.OperationalServers).SystemIdIdxOpen(pServerIP).Groups.GroupName,pServerIP)
		}
		
		set server=##class(zsys.RAM.OperationalServers).SystemIdIdxOpen(pServerIP)
		set group=##class(zsys.RAM.Groups).GroupNameIdxOpen(pGname)
		
		set server.Groups=group
		
		set saveStatus = server.%Save()
		if $$$ISERR(saveStatus){
			do $system.OBJ.DisplayError()
		}
		
		set server=""
		set group=""
		return $$$OK
	}
	
	// Remove a server from a group
	ClassMethod RemoveServerFromGroup(pGname,pServerIP) as %Status{

		if ('..IsGroupExist(pGname)){
			set %response.Status=400
			w "The group does not exist."
			return $$$OK
		}
		
		if ('..IsServerExist(pServerIP)){
			set %response.Status=400
			w "The server does not exist."
			return $$$OK
		}
		
		set server=##class(zsys.RAM.OperationalServers).SystemIdIdxOpen(pServerIP)
		set group=##class(zsys.RAM.Groups).GroupNameIdxOpen(pGname)
		
		set key=""
		Do {
			set oneServer = group.OperationalServers.GetNext(.key)
			If (oneServer.SystemId=pServerIP) {
 				do group.OperationalServers.RemoveAt(key)
 				set saveStatus = server.%Save()
 				if $$$ISERR(saveStatus){
 					do $system.OBJ.DisplayError()
				}
				set server=""
				set group=""
 				return $$$OK
			}
		} While (key '= "")
		
		set server=""
		set group=""
		set %response.Status=400
		w "The server is not in this group."
		return $$$OK
	}
	
	// Retrieve all server groups
	ClassMethod GetGroups() as %String{
		set servers=[].%FromJSON(..GetServers())
	
		SET q1="SELECT * "
		set q2="FROM zsys_RAM.Groups"
		SET myquery = q1_q2
		SET tStatement = ##class(%SQL.Statement).%New()
		SET qStatus = tStatement.%Prepare(myquery)
		IF qStatus'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
		SET rset = tStatement.%Execute()
		
		set results=[]
		
		WHILE rset.%Next() {
			set groupCollection={}
			set group=##class(zsys.RAM.Groups).GroupNameIdxOpen(rset.GroupName)
			set groupCollection.GroupName=group.GroupName
			set groupCollection.Description=group.Description
			set groupCollection.OperationalServers=[]
			set key=""
			Do {
				Set server = group.OperationalServers.GetNext(.key)
				If (server '= "") {
					do groupCollection.OperationalServers.%Push(server.SystemId)
					set iter = servers.%GetIterator()
					
			    	while iter.%GetNext(.k, .value){
			    		if (value=server.SystemId){
			    			do servers.%Remove(k)
			    		}
			    	}
				}
			} While (key '= "")
			set group=""
			do results.%Push(groupCollection)
		}
		
		if (servers.%Size()>0){
			set groupCollection={}
			set groupCollection.GroupName="UndeterminedGroup"
			set groupCollection.Description="Servers belonging to no group."
			set groupCollection.OperationalServers=servers
			do results.%Push(groupCollection)
		}
		
		return results.%ToJSON()
	}
	
	// Return with status code
	ClassMethod GetAllGroups() as %Status{
		w ..GetGroups()
		return $$$OK
	}
	
	// Let the server retrieve custom status data
	ClassMethod PutAttributesIntoServer(pServerIP,Attributes) as %Status{
		if ('..IsServerExist(pServerIP)){
			set %response.Status=400
			w "The server does not exist."
			return $$$OK
		}
		
		set RequestObject={}
		set RequestObject.SystemID=pServerIP
		set RequestObject.Attributes=Attributes
		
        set status = ##class(Ens.Director).CreateBusinessService("GroupReallocateService",.instance)
        if $$$ISOK(status) {
               #dim response as %DynamicObject
               set status = instance.OnProcessInput(RequestObject)
               if $$$ISERR(status){
					if ($system.Status.GetErrorCodes(status)="5001"){
 						set %response.Status=400
 						do $system.OBJ.DisplayError()
 						w !,"No privilege."
 						return $$$OK
 					}
					set %response.Status=400
					do $system.OBJ.DisplayError()
					w "Something is wrong with business production."
					return $$$OK
				}
        }
		
		set server=##class(zsys.RAM.OperationalServers).SystemIdIdxOpen(pServerIP)
		set attributeCollection=[]
		For i=1:1:$Length(Attributes,",") {
			set piece = $Piece(Attributes,",",i)
			do attributeCollection.%Push(piece)
		}
		set server.Attributes=attributeCollection.%ToJSON()
		
		set saveStatus = server.%Save()
		if $$$ISERR(saveStatus){
			do $system.OBJ.DisplayError()
		}
		
		set server=""
		
		return $$$OK
		
	}
	
	// Restore the default attributes
	ClassMethod PutDefaultAttributesIntoServer(pServerIP) as %Status{
		if ('..IsServerExist(pServerIP)){
			set %response.Status=400
			w "The server does not exist."
			return $$$OK
		}
		
		set server=##class(zsys.RAM.OperationalServers).SystemIdIdxOpen(pServerIP)
		set server.Attributes=server.#DefaultAttributes
		
		set saveStatus = server.%Save()
		if $$$ISERR(saveStatus){
			do $system.OBJ.DisplayError()
		}
		
		set server=""
		
		return $$$OK
	}
	
	// Retrieve all server systemid
	ClassMethod GetServers() as %String{
		SET q1="SELECT SystemId "
		set q2="FROM zsys_RAM.OperationalServers"
		SET myquery = q1_q2
		SET tStatement = ##class(%SQL.Statement).%New()
		SET qStatus = tStatement.%Prepare(myquery)
		IF qStatus'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
		SET rset = tStatement.%Execute()
		
		set results=[]
		
		WHILE rset.%Next() {
			do results.%Push(rset.SystemId)
		}
		
		return results.%ToJSON()
	}
	
	// Return with status code
	ClassMethod GetAllServers() as %String{
		w ..GetServers()
		return $$$OK
	}
	
	// Retrieve all alerts
	ClassMethod GetAlerts() as %String{
		Set q1="SELECT * "
		Set q2="FROM zsys_RAM.Alerts"
		Set myquery=q1_q2
		SET tStatement = ##class(%SQL.Statement).%New()
		SET qStatus = tStatement.%Prepare(myquery)
		IF qStatus'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
		SET rset = tStatement.%Execute()
		
		set results={}
		
		while rset.%Next() {
			do results.%Set("Alerts",{}.%FromJSON(rset.Alerts))
			do results.%Set("Warnings",{}.%FromJSON(rset.Warnings))
		}
		
		return results.%ToJSON()
	}
	
	// Return all system alerts
	ClassMethod GetAllAlerts() as %Status{
		w ..GetAlerts()
		return $$$OK
	}
	
	// Delete one alert
	ClassMethod DeleteAnAlert(type,timeStamp) as %Status{
		set alerts=##class(zsys.RAM.Alerts).%OpenId(1)
		set timeStamp=$P(timeStamp,"-",1)_"/"_$P(timeStamp,"-",2)_"/"_$P(timeStamp,"-",3)_"-"_$P(timeStamp,"-",4)
		if (type){
			do alerts.Alerts.%Remove(timeStamp)
		}else{
			do alerts.Warnings.%Remove(timeStamp)
		}
		do alerts.%Save()
		return $$$OK
	}
	
 //	ClassMethod LoopThroughTable(TableName,ID=-1){
 //		write !,"Showing data from table "_TableName_":"
 //		set table="zsys_RAM."_TableName
 //		set tStatement=##class(%SQL.Statement).%New()
 //		set qStatus=tStatement.%Prepare("select * from "_table)
 //		IF qStatus'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
 //		set rset=tStatement.%Execute()
 //		
 //		while rset.%Next(){
 //
 //			if ID'=-1{
 //				if ID'=rset.%GetData(1){
 //					continue
 //				}
 //			 }
 //			
 //			for x=1:1:tStatement.%Metadata.columns.Count() {
 //				SET column=tStatement.%Metadata.columns.GetAt(x)
 //				
 //				if column.ODBCType=-5{
 //					if column.colName'="ID"{
 //					do ..LoopThroughTable(column.colName,rset.%GetData(x))
 //					}
 //				}
 //				
 //				WRITE !,x," ",column.colName," is data type ",column.ODBCType," with a value of ",rset.%GetData(x)
 //			}
 //		}
 //		
 //		w !,"End of table "_TableName
 //	}
	
	ClassMethod IsServerExist(SystemId) as %Boolean{
		set server=##class(zsys.RAM.OperationalServers).SystemIdIdxOpen(SystemId)
		if (server=""){
			return 0
		}
		return 1
	}
	
	ClassMethod IsGroupExist(GroupName) as %Boolean{
		set group=##class(zsys.RAM.Groups).GroupNameIdxOpen(GroupName)
		if (group=""){
			return 0
		}
		return 1
	}
	
	ClassMethod IsServerGroupAssigned(SystemId) as %Boolean{
		set server=##class(zsys.RAM.OperationalServers).SystemIdIdxOpen(SystemId)
		if (server.Groups=""){
			return 0
		}
		return 1
	}
}