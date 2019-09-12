Class zsys.Service.CheckMessagesLogService extends Ens.BusinessService {

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

Property Adapter as EnsLib.File.InboundAdapter;

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As %RegisteredObject) As %Status
{
	set ..Adapter.DeleteFromServer=0
	
	set alerts=##class(zsys.RAM.Alerts).%OpenId(1)
		
	// Create if not exist
	if (alerts=""){
		set alerts=##class(zsys.RAM.Alerts).%New()
	}

	do alerts.ExtractAlerts(pInput)
	do alerts.%Save()
	
	Quit $$$OK
}

}