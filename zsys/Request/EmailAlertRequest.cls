Class zsys.Request.EmailAlertRequest Extends (Ens.Request,%JSON.Adaptor)
{
	Property Destination as %String(MAXLEN=3641144) [InitialExpression="intersystemslog@gmail.com"];
	Property Content as %DynamicObject;
	Property Subject as %String [InitialExpression="ALERT!!!"];


Storage Default
{
<Data name="Content">
<Attribute>Content</Attribute>
<Structure>node</Structure>
<Subscript>"zsys.Request.EmailAlertRequest.Content"</Subscript>
</Data>
<Data name="EmailAlertRequestDefaultData">
<Subscript>"EmailAlertRequest"</Subscript>
<Value name="1">
<Value>Destination</Value>
</Value>
<Value name="2">
<Value>Subject</Value>
</Value>
</Data>
<DefaultData>EmailAlertRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}