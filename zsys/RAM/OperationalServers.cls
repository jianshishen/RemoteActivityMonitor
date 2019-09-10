Class zsys.RAM.OperationalServers Extends %Persistent
{
	Parameter DefaultAttributes="[""zsys.RAM.Attribute.ISCversion"",""zsys.RAM.Attribute.ISCInstanceName"",""zsys.RAM.Attribute.CPUCount"",""zsys.RAM.Attribute.HostName"",""zsys.RAM.Attribute.IPAddress"",""zsys.RAM.Attribute.LicenseLimit"",""zsys.RAM.Attribute.LicenseMaxHit"",""zsys.RAM.Attribute.LicenseTo"",""zsys.RAM.Attribute.LicenseUsage"",""zsys.RAM.Attribute.RAMCount"",""zsys.RAM.Attribute.SystemUpTime""]";
	Property SystemId as %String [InitialExpression="DefaultId"];
	Property IPAddress as %String [InitialExpression="DefaultIp"];
	Property Attributes as %String(MAXLEN=3641144) [InitialExpression="[""zsys.RAM.Attribute.ISCversion"",""zsys.RAM.Attribute.ISCInstanceName"",""zsys.RAM.Attribute.CPUCount"",""zsys.RAM.Attribute.HostName"",""zsys.RAM.Attribute.IPAddress"",""zsys.RAM.Attribute.LicenseLimit"",""zsys.RAM.Attribute.LicenseMaxHit"",""zsys.RAM.Attribute.LicenseTo"",""zsys.RAM.Attribute.LicenseUsage"",""zsys.RAM.Attribute.RAMCount"",""zsys.RAM.Attribute.SystemUpTime""]"];
	Index SystemIdIdx on SystemId [Unique];
	Relationship Groups as zsys.RAM.Groups [Cardinality=one, Inverse=OperationalServers];

Storage Default
{
<Data name="OperationalServersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SystemId</Value>
</Value>
<Value name="3">
<Value>IPAddress</Value>
</Value>
<Value name="4">
<Value>Attributes</Value>
</Value>
<Value name="5">
<Value>Groups</Value>
</Value>
</Data>
<DataLocation>^zsys.RAM.OperationalServersD</DataLocation>
<DefaultData>OperationalServersDefaultData</DefaultData>
<IdLocation>^zsys.RAM.OperationalServersD</IdLocation>
<IndexLocation>^zsys.RAM.OperationalServersI</IndexLocation>
<StreamLocation>^zsys.RAM.OperationalServersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}