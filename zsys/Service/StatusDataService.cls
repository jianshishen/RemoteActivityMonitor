Class zsys.Service.StatusDataService extends Ens.BusinessService [Language=objectscript]{

Parameter ADAPTER = "";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
		
		set iter = pInput.%GetIterator()
		
    	while iter.%GetNext(.key, .value){
    		
    		if (key="LicenseUsage") {
    			if (pInput.LicenseLimit'="") {
    				set pOutput=##class(zsys.Request.LicenseCheckRequest).%New()
    				set pOutput.SystemID=pInput.SystemId
    				set pOutput.LicenseUsage=value
 //    				set pOutput.LicenseLimit=pInput.LicenseLimit
 					set pOutput.LicenseLimit=0
    				set tSC=..SendRequestAsync("ExamineLicenseUsage",pOutput)
    			}
    		}
    		
 //    		if (key="HostName"){
 //				set pOutput=##class(zsys.Request.HostNameCheckRequest).%New()
 //				set pOutput.SystemID=pInput.SystemId
 //				set pOutput.HostName=value
 //				set tSC=..SendRequestAsync("ExamineHostName",pOutput)
 //    		}
    		
    	}

        Quit $$$OK
}

}