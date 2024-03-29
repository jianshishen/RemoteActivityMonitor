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
	
	set alertsIterator=alerts.Alerts.%GetIterator()
	while alertsIterator.%GetNext(.key,.value){
		if (##class(zsys.RAM.Alerts).ifDate1LaterthanDate2(alerts.LastEmailTimeStamp,$zdth($PIECE(value,"-",1)_" "_$PIECE($PIECE(value,"-",2),":",1)_":"_$PIECE($PIECE(value,"-",2),":",2)_":"_$PIECE($PIECE(value,"-",2),":",3)))) continue
		set emailAlertRequest=##class(zsys.Request.EmailAlertRequest).%New()
		do emailAlertRequest.Content.%Set(key,value)
		set tSC=..SendRequestAsync("EMailAlertOperation",emailAlertRequest)
		
 		set emailContent={}
 		do emailContent.%Set("Origin",emailAlertRequest.Origin)
 		do emailContent.%Set("Destination",emailAlertRequest.Destination)
 		do emailContent.%Set("Text",value)
		
    	// Create http request
    	set httprequest=##class(%Net.HttpRequest).%New()
		set httprequest.Server=$CLASSMETHOD("zsys.RAM.Attribute.HomeServerPort","getValue").Server
		set httprequest.Port=$CLASSMETHOD("zsys.RAM.Attribute.HomeServerPort","getValue").Port
		do httprequest.InsertFormData("Alert",emailContent.%ToJSON())
		set requestStatus=httprequest.Post("/v1/ram/alerts")
	}
	
	set warningsIterator=alerts.Warnings.%GetIterator()
	while warningsIterator.%GetNext(.key,.value){
		if (##class(zsys.RAM.Alerts).ifDate1LaterthanDate2(alerts.LastEmailTimeStamp,$zdth($PIECE(value,"-",1)_" "_$PIECE($PIECE(value,"-",2),":",1)_":"_$PIECE($PIECE(value,"-",2),":",2)_":"_$PIECE($PIECE(value,"-",2),":",3)))) continue
		set emailAlertRequest=##class(zsys.Request.EmailAlertRequest).%New()
		do emailAlertRequest.Content.%Set(key,value)
		set emailAlertRequest.Subject="WARNING!!!"
		set tSC=..SendRequestAsync("EMailAlertOperation",emailAlertRequest)
		
 		set emailContent={}
 		do emailContent.%Set("Origin",emailAlertRequest.Origin)
 		do emailContent.%Set("Destination",emailAlertRequest.Destination)
 		do emailContent.%Set("Text",value)
		
    	// Create http request
    	set httprequest=##class(%Net.HttpRequest).%New()
		set httprequest.Server=$CLASSMETHOD("zsys.RAM.Attribute.HomeServerPort","getValue").Server
		set httprequest.Port=$CLASSMETHOD("zsys.RAM.Attribute.HomeServerPort","getValue").Port
		do httprequest.InsertFormData("Alert",emailContent.%ToJSON())
		set requestStatus=httprequest.Post("/v1/ram/alerts")
	}
	
	set alerts.LastEmailTimeStamp=alerts.LastAlertsTimeStamp
	
	do alerts.%Save()
	
	Quit $$$OK
}

}