Class zsys.RAM.Groups Extends %Persistent
{

Property GroupName As %String [InitialExpression="Default"];

Property Description As %String [InitialExpression="Default description"];

Index GroupNameIdx on GroupName [Unique];

Relationship OperationalServers As zsys.RAM.OperationalServers [ Cardinality = many, Inverse = Groups ];

Storage Default
{
<Data name="GroupsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupName</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^zsys.RAM.GroupsD</DataLocation>
<DefaultData>GroupsDefaultData</DefaultData>
<IdLocation>^zsys.RAM.GroupsD</IdLocation>
<IndexLocation>^zsys.RAM.GroupsI</IndexLocation>
<StreamLocation>^zsys.RAM.GroupsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
