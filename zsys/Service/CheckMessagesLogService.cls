Class zsys.Service.CheckMessagesLogService extends Ens.BusinessService {

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

Property Adapter as EnsLib.File.InboundAdapter;

Property Phase as %Integer;

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As %RegisteredObject) As %Status
{
	set ..Phase=0
	set ..Adapter.DeleteFromServer=0
	while 'pInput.AtEnd{
		set line=pInput.ReadLine()
		if (..Phase=0){
			if ($FIND(line,"***")=4){
				set ..Phase=1
			}
		}elseif(..Phase=1){
			if ($FIND(line,"")){
			
			}
		}else{
		
		}
	}
	Quit $$$OK
}

}