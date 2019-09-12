Class zsys.RAM.Alerts Extends %Persistent
{

	Property LastAlertsTimeStamp as %String;
	Property Alerts as %DynamicArray;
	Property Warnings as %DynamicArray;
	
	Method ExtractAlerts(pInput As %Stream.FileCharacter)
	{
		set phase=0
		set alert=""
		set warning=""
		set timestamp=""
		set alertType=$$$YES
		
		// Loop through the stream
		while 'pInput.AtEnd{
			set line=pInput.ReadLine()
			
			// Find the first chunk of logs
			if (phase=0){
				if ($FIND(line,"***")=4){
					set phase=1
				}
				
			// Find an alert
			}elseif(phase=1){
			
				// Detected a log
				if (line?2N1"/"2N1"/"2N1"-".E){

					// Start recording if the status code is 2
					if ($PIECE(line," ",3)="2"){
						set phase=2
						set alertType=$$$YES
						set alert=line
					}

					// Start recording if the status code is 1
					if ($PIECE(line," ",3)="1"){
						set phase=2
						set alertType=$$$NO
						set warning=line
					}
					
				}
				
			// Record an alert
			}else{
			
				// Detected a new log
				if (line?2N1"/"2N1"/"2N1"-".E){
					
					if (alertType){
						do ..Alerts.%Push(alert)
						set alert=""
					}else{
						do ..Warnings.%Push(warning)
						set warning=""
					}
						
					// Start recording if the status code is 2
					if ($PIECE(line," ",3)="2"){
						set phase=2
						set alertType=$$$YES
						set alert=line
					// Start recording if the status code is 1
					}elseif ($PIECE(line," ",3)="1"){
						set phase=2
						set alertType=$$$NO
						set warning=line
					}else{
						set phase=1
					}
					
				// Found a new chunk
				}elseif($FIND(line,"***")=4){
					if (alertType){
						do ..Alerts.%Push(alert)
						set alert=""
					}else{
						do ..Warnings.%Push(warning)
						set warning=""
					}
					set phase=1
					
				// Keep recording the current alert
				}else{
					if (alertType){
						set alert=alert_line
					}else{
						set warning=warning_line
					}
					
				}
			}
		}
	}
	

	Storage Default
{
<Data name="Alerts">
<Attribute>Alerts</Attribute>
<Structure>node</Structure>
<Subscript>"Alerts"</Subscript>
</Data>
<Data name="AlertsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LastAlertsTimeStamp</Value>
</Value>
</Data>
<Data name="Warnings">
<Attribute>Warnings</Attribute>
<Structure>node</Structure>
<Subscript>"Warnings"</Subscript>
</Data>
<DataLocation>^zsys.RAM.AlertsD</DataLocation>
<DefaultData>AlertsDefaultData</DefaultData>
<IdLocation>^zsys.RAM.AlertsD</IdLocation>
<IndexLocation>^zsys.RAM.AlertsI</IndexLocation>
<StreamLocation>^zsys.RAM.AlertsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}