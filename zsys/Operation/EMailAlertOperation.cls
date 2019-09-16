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
		Set tSC=tMailMessage.TextData.Write("From "_pRequest.Origin_": "_value)
		Set tSC=..Adapter.SendMail(tMailMessage)
		
 		set emailContent={}
 		do emailContent.%Set("Origin",pRequest.Origin)
 		do emailContent.%Set("Destination",pRequest.Destination)
 		do emailContent.%Set("Text",value)
		
    	// Create http request
    	set httprequest=##class(%Net.HttpRequest).%New()
		set httprequest.Server=$CLASSMETHOD("zsys.RAM.Attribute.HomeServerPort","getValue").Server
		set httprequest.Port=$CLASSMETHOD("zsys.RAM.Attribute.HomeServerPort","getValue").Port
		do httprequest.InsertFormData("Alert",emailContent.%ToJSON())
		set requestStatus=httprequest.Post("/v1/ram/alerts")

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