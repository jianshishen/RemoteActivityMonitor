Class zsys.RAM.ServerData Extends %Persistent
{

	Property LastHomeResponse as %DynamicObject;
	Property GroupName as %String;
	Property PreviousSampleDT as %String;
	Property Attributes as %DynamicArray;

Storage Default
{
<Data name="Attributes">
<Attribute>Attributes</Attribute>
<Structure>node</Structure>
<Subscript>"Attributes"</Subscript>
</Data>
<Data name="LastHomeResponse">
<Attribute>LastHomeResponse</Attribute>
<Structure>node</Structure>
<Subscript>"LastHomeResponse"</Subscript>
</Data>
<Data name="ServerDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupName</Value>
</Value>
<Value name="3">
<Value>PreviousSampleDT</Value>
</Value>
</Data>
<DataLocation>^zsys.RAM.ServerDataD</DataLocation>
<DefaultData>ServerDataDefaultData</DefaultData>
<IdLocation>^zsys.RAM.ServerDataD</IdLocation>
<IndexLocation>^zsys.RAM.ServerDataI</IndexLocation>
<StreamLocation>^zsys.RAM.ServerDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}