Class zsys.Request.GroupPrivilegeCheckRequest Extends Ens.Request
{
	Property SystemID as %String;
	Property GroupName as %String;
	Property Attributes as %String(MAXLEN=3641144);
Storage Default
{
<Data name="GroupPrivilegeCheckRequestDefaultData">
<Subscript>"GroupPrivilegeCheckRequest"</Subscript>
<Value name="1">
<Value>GroupName</Value>
</Value>
<Value name="2">
<Value>Attributes</Value>
</Value>
<Value name="3">
<Value>SystemID</Value>
</Value>
</Data>
<DefaultData>GroupPrivilegeCheckRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}