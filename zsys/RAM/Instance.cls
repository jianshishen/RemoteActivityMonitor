Class zsys.RAM.Instance
{
	
	ClassMethod Cycle(){
		set serverDataInstance=##class(zsys.RAM.ServerData).%OpenId(1)
		
    	if (serverDataInstance=""){
    		set serverDataInstance = ##class(zsys.RAM.ServerData).%New()
    		set serverDataInstance.LastHomeResponse={}
    		set serverDataInstance.GroupName=""
    		set serverDataInstance.Attributes=["zsys.RAM.Attribute.ISCversion", "zsys.RAM.Attribute.ISCInstanceName", "zsys.RAM.Attribute.CPUCount","zsys.RAM.Attribute.HostName", "zsys.RAM.Attribute.IPAddress", "zsys.RAM.Attribute.LicenseLimit","zsys.RAM.Attribute.LicenseMaxHit", "zsys.RAM.Attribute.LicenseTo", "zsys.RAM.Attribute.LicenseUsage","zsys.RAM.Attribute.RAMCount", "zsys.RAM.Attribute.SystemUpTime", "zsys.RAM.Attribute.SensitiveData"]
    	}
		
		set collection={}
		set iter = serverDataInstance.Attributes.%GetIterator()
		
    	while iter.%GetNext(.key, .value){
    		set nameValuePair=$CLASSMETHOD(value,"getValue")
    		do collection.%Set(nameValuePair.Name,nameValuePair.Value)
    	}
    	
    	do collection.%Set("LastHomeResponse",serverDataInstance.LastHomeResponse)
    	do collection.%Set("PreviousSampleDT",serverDataInstance.PreviousSampleDT)
    	set serverDataInstance.PreviousSampleDT=$zdatetime($h,4)
    	do collection.%Set("ThisSampleDT",serverDataInstance.PreviousSampleDT)
    	do collection.%Set("GroupName",serverDataInstance.GroupName)
    	do collection.%Set("Attributes",serverDataInstance.Attributes.%ToJSON())
    	do collection.%Set("SystemId",$SYSTEM)
    	
    	set httprequest=##class(%Net.HttpRequest).%New()
		set httprequest.Server="AU7490GRAD03"
		set httprequest.Port="52773"
 
		do httprequest.InsertFormData("StatusData",collection.%ToJSON())
 //		do httprequest.InsertFormData("IPAddress",$SYSTEM.INetInfo.HostNameToAddr($SYSTEM.INetInfo.LocalHostName(),1))
		set requestStatus=httprequest.Post("/v1/ram/update")
		
		if $$$ISERR(requestStatus){
			do $system.OBJ.DisplayError()
		}else{
			set res=httprequest.HttpResponse.Data.Read()
			set response={}.%FromJSON(res)
			set serverDataInstance.LastHomeResponse=response
			
			if (response.%Get("GroupName")'=serverDataInstance.GroupName || ""){
				set serverDataInstance.GroupName=response.%Get("GroupName")
			}
			
			if (response.%Get("Attributes")'=serverDataInstance.Attributes){
				set serverDataInstance.Attributes=[].%FromJSON(response.%Get("Attributes"))
			}
			
			zw response
		}
		
		set saveStatus = serverDataInstance.%Save()
		if $$$ISERR(requestStatus){
			do $system.OBJ.DisplayError()
		}

	}

}