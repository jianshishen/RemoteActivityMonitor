Class zsys.RAM.Alerts Extends %Persistent
{

	Property LastAlertsTimeStamp as %String [InitialExpression="0,0"];
	Property LastEmailTimeStamp as %String [InitialExpression="0,0"];
	Property Alerts as %DynamicObject;
	Property Warnings as %DynamicObject;
	
	ClassMethod ifDate1LaterthanDate2(date1,date2) as %Boolean{
		return ($piece(date1,",")*86400+$p(date1,",",2))>($p(date2,",")*86400+$p(date2,",",2))
	}
	
	Method ExtractAlerts(pInput)
	{
		set phase=0
		set alert=""
		set warning=""
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
			}elseif (phase=1){
			
				// Detected a log
				if (line?2N1"/"2N1"/"2N1"-".E){
				
					// Check if the alert has been recorded before
					set currentTimeStamp=$zdth($PIECE(line,"-",1)_" "_$PIECE($PIECE(line,"-",2),":",1)_":"_$PIECE($PIECE(line,"-",2),":",2)_":"_$PIECE($PIECE(line,"-",2),":",3))
					if (..ifDate1LaterthanDate2(..LastAlertsTimeStamp,currentTimeStamp)) continue
					set ..LastAlertsTimeStamp=currentTimeStamp
					
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
 						do ..Alerts.%Set($PIECE(alert," ",1),alert)
						set alert=""
					}else{
						do ..Warnings.%Set($PIECE(warning," ",1),warning)
						set warning=""
					}
					
					// Check if the alert has been recorded before
					set currentTimeStamp=$zdth($PIECE(line,"-",1)_" "_$PIECE($PIECE(line,"-",2),":",1)_":"_$PIECE($PIECE(line,"-",2),":",2)_":"_$PIECE($PIECE(line,"-",2),":",3))
					if (..ifDate1LaterthanDate2(..LastAlertsTimeStamp,currentTimeStamp)) {
						set phase=1
						continue
					}
					set ..LastAlertsTimeStamp=currentTimeStamp
						
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
						do ..Alerts.%Set($PIECE(alert," ",1),alert)
						set alert=""
					}else{
 						do ..Warnings.%Set($PIECE(warning," ",1),warning)
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
<Value name="3">
<Value>LastEmailTimeStamp</Value>
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