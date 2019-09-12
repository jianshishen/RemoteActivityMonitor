Class zsys.Service.TestService extends Ens.BusinessService {

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{

	set request=##class(zsys.Request.ExamineStatusDataRequest).%New()

	do request.StatusData.%Set("LicenseUsage",5)
	do request.StatusData.%Set("LicenseLimit",3)
	
	set tSC=..SendRequestAsync("ExamineStatusData",request)
	
	Quit $$$OK
}

}