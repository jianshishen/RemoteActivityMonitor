Class zsys.Service.CheckMessagesLogService extends Ens.BusinessService {

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

Property Adapter as EnsLib.File.InboundAdapter;

Property Phase as %Integer;

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As %RegisteredObject) As %Status
{
	set alerts=##class(zsys.RAM.Alerts).%New()
	Quit $$$OK
}

}