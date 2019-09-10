Class zsys.Response.LicenseCheckResponse Extends Ens.Response
{
	Property IsReachedLimit as %Boolean;
Storage Default
{
<Data name="LicenseCheckResponseDefaultData">
<Subscript>"LicenseCheckResponse"</Subscript>
<Value name="1">
<Value>IsReachedLimit</Value>
</Value>
</Data>
<DefaultData>LicenseCheckResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}