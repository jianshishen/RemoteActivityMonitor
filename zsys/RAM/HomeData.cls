Class zsys.RAM.HomeData Extends %Persistent
{
	Property StatusData as %DynamicObject;
	Property GroupName as %String;
	Index GroupIdx on GroupName;

Storage Default
{
<Data name="HomeDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StatusData</Value>
</Value>
<Value name="3">
<Value>GroupName</Value>
</Value>
</Data>
<DataLocation>^zsys.RAM.HomeDataD</DataLocation>
<DefaultData>HomeDataDefaultData</DefaultData>
<IdLocation>^zsys.RAM.HomeDataD</IdLocation>
<IndexLocation>^zsys.RAM.HomeDataI</IndexLocation>
<StreamLocation>^zsys.RAM.HomeDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}