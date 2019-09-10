Class zsys.Request.LicenseCheckRequest Extends Ens.Request
{
	Property SystemID as %String;
	Property LicenseUsage as %Integer;
	Property LicenseLimit as %Integer;
Storage Default
{
<Data name="LicenseCheckRequestDefaultData">
<Subscript>"LicenseCheckRequest"</Subscript>
<Value name="1">
<Value>LicenseUsage</Value>
</Value>
<Value name="2">
<Value>LicenseLimit</Value>
</Value>
<Value name="3">
<Value>SystemID</Value>
</Value>
</Data>
<DefaultData>LicenseCheckRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}