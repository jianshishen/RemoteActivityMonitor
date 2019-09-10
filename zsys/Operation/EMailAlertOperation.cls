Class zsys.Operation.EMailAlertOperation extends Ens.BusinessOperation {

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Property Adapter As EnsLib.EMail.OutboundAdapter;

Parameter INVOCATION = "Queue";

/// Send and persist an alert
Method AlertSendAndPersist(pRequest As zsys.Request.EmailAlertRequest, Output pResponse As Ens.Response) As %Status
{

	If pRequest.Destination="" $$$TRACE("no email address.") Quit $$$OK
	Set tMailMessage=##class(%Net.MailMessage).%New()
	set tMailMessage.From = "intersystemslog@gmail.com"
	Do tMailMessage.To.Insert(pRequest.Destination)
	Set tMailMessage.Subject="ALERT!!!"
	set tMailMessage.Charset="UTF-8"
	Set tSC=tMailMessage.TextData.Write(pRequest.Text)  Quit:$$$ISERR(tSC) tSC
	Set tSC=..Adapter.SendMail(tMailMessage)

	if ('$SYSTEM.DocDB.Exists("Alerts")){
		do ##class(%DocDB.Database).%CreateDatabase("Alerts")
	}
	set db = ##class(%DocDB.Database).%GetDatabase("Alerts")
	do pRequest.%JSONExportToString(.jsonEvent)
	do db.%SaveDocument(jsonEvent)

	Quit tSC
}

XData MessageMap {
<MapItems>
    <MapItem MessageType="zsys.Request.EmailAlertRequest">
        <Method>AlertSendAndPersist</Method>
    </MapItem>
</MapItems>
}

}