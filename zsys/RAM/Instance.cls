Class zsys.RAM.Instance
{
	
	ClassMethod Cycle(){
		set serverDataInstance=##class(zsys.RAM.ServerData).%OpenId(1)
		
		// Create a server if not exist
    	if (serverDataInstance=""){
    		set serverDataInstance = ##class(zsys.RAM.ServerData).%New()
    		set serverDataInstance.LastHomeResponse={}
    		set serverDataInstance.GroupName=""
    		set serverDataInstance.Attributes=["zsys.RAM.Attribute.ISCversion", "zsys.RAM.Attribute.ISCInstanceName", "zsys.RAM.Attribute.CPUCount","zsys.RAM.Attribute.HostName", "zsys.RAM.Attribute.IPAddress", "zsys.RAM.Attribute.LicenseLimit","zsys.RAM.Attribute.LicenseMaxHit", "zsys.RAM.Attribute.LicenseTo", "zsys.RAM.Attribute.LicenseUsage","zsys.RAM.Attribute.RAMCount", "zsys.RAM.Attribute.SystemUpTime", "zsys.RAM.Attribute.SensitiveData"]
    	}
		
		set collection={}
		set iter = serverDataInstance.Attributes.%GetIterator()
		
		// Loop through the array of attribute names and collect
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
    	
    	// Create http request
    	set httprequest=##class(%Net.HttpRequest).%New()
		set httprequest.Server=$CLASSMETHOD("zsys.RAM.Attribute.HomeServerPort","getValue").Server
		set httprequest.Port=$CLASSMETHOD("zsys.RAM.Attribute.HomeServerPort","getValue").Port
		do httprequest.InsertFormData("StatusData",collection.%ToJSON())
		set requestStatus=httprequest.Post("/v1/ram/update")
		
		if $$$ISERR(requestStatus){
			do $system.OBJ.DisplayError()
		}else{
			// Read response
			set res=httprequest.HttpResponse.Data.Read()
			set response={}.%FromJSON(res)
			set serverDataInstance.LastHomeResponse=response
			
			// Change new group name if necessary
			if (response.%Get("GroupName")'=serverDataInstance.GroupName || ""){
				set serverDataInstance.GroupName=response.%Get("GroupName")
			}
			
			// Change new attributes if necessary
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