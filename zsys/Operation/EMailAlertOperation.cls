Class zsys.Operation.EMailAlertOperation extends Ens.BusinessOperation {

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Property Adapter As EnsLib.EMail.OutboundAdapter;

Parameter INVOCATION = "Queue";

/// Send and persist an alert
Method AlertSendAndPersist(pRequest As zsys.Request.EmailAlertRequest, Output pResponse As Ens.Response) As %Status
{

	If pRequest.Destination="" $$$TRACE("no email address.") Quit $$$OK
	Set tMailMessage=##class(%Net.MailMessage).%New()
	
	set iter = pRequest.Content.%GetIterator()
	
	while iter.%GetNext(.key, .value){
		set tMailMessage.From = "intersystemslog@gmail.com"
		Do tMailMessage.To.Insert(pRequest.Destination)
		Set tMailMessage.Subject=pRequest.Subject
		set tMailMessage.Charset="UTF-8"
		Set tSC=tMailMessage.TextData.Write(value)
		Set tSC=..Adapter.SendMail(tMailMessage)
		if ('$SYSTEM.DocDB.Exists("Alerts")){
			do ##class(%DocDB.Database).%CreateDatabase("Alerts")
		}
		set db = ##class(%DocDB.Database).%GetDatabase("Alerts")
 		set emailContent={}
 		do emailContent.%Set("Destination",pRequest.Destination)
 		do emailContent.%Set("Text",value)
		do db.%SaveDocument(emailContent)
	}

	Quit $$$OK
}

XData MessageMap {
<MapItems>
    <MapItem MessageType="zsys.Request.EmailAlertRequest">
        <Method>AlertSendAndPersist</Method>
    </MapItem>
</MapItems>
}

}