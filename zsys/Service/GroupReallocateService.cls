Class zsys.Service.GroupReallocateService extends Ens.BusinessService {

Parameter ADAPTER = "";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	set pOutput=##class(zsys.Request.GroupPrivilegeCheckRequest).%New()
	set server=##class(zsys.RAM.OperationalServers).SystemIdIdxOpen(pInput.SystemID)
	set pOutput.GroupName=server.Groups.GroupName
	set pOutput.SystemID=pInput.SystemID
	set pOutput.Attributes=pInput.Attributes
	
	set CheckApprovalObject=##class(zsys.Response.GroupPrivilegeCheckResponse).%New()
	set tSC=..SendRequestSync("ExamineGroupPrivilege",pOutput,.CheckApprovalObject)
	if (CheckApprovalObject.CheckApproval){
		Quit $$$OK
	}else{
		Quit $$$ERROR("5001","The group does not have enough privileges.")
	}
}

}