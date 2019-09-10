Class zsys.Request.EmailAlertRequest Extends (Ens.Request,%JSON.Adaptor)
{
	Property Destination as %String(MAXLEN=3641144);
	Property Text as %String(MAXLEN=3641144);

Storage Default
{
<Data name="EmailAlertRequestDefaultData">
<Subscript>"EmailAlertRequest"</Subscript>
<Value name="1">
<Value>Destination</Value>
</Value>
<Value name="2">
<Value>Text</Value>
</Value>
</Data>
<DefaultData>EmailAlertRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}