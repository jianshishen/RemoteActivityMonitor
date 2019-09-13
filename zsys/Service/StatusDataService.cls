Class zsys.Service.StatusDataService extends Ens.BusinessService [Language=objectscript]{

Parameter ADAPTER = "";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
		
	set request=##class(zsys.Request.ExamineStatusDataRequest).%New()

	set request.StatusData=pInput
	
	set request.SystemId=pInput.SystemId
	
	set tSC=..SendRequestAsync("ExamineStatusData",request)

 	Quit $$$OK
}

}