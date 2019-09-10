Class zsys.Request.HostNameCheckRequest Extends Ens.Request
{
	Property SystemID as %String;
	Property HostName as %String;
Storage Default
{
<Data name="HostNameCheckRequestDefaultData">
<Subscript>"HostNameCheckRequest"</Subscript>
<Value name="1">
<Value>HostName</Value>
</Value>
<Value name="2">
<Value>SystemID</Value>
</Value>
</Data>
<DefaultData>HostNameCheckRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}