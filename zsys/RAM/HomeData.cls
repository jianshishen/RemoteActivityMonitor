Class zsys.RAM.HomeData Extends %Persistent
{
	Property SystemId as %String;
	Property StatusData as %DynamicObject;
	Property GroupName as %String;
	Index GroupIdx on GroupName;
	
	Method PersistToDocDB(){
		if ('$SYSTEM.DocDB.Exists("OperServers")){
			do ##class(%DocDB.Database).%CreateDatabase("OperServers")
			do db.%CreateProperty("SystemId","%String","$.SystemId",0)
		}
		set db = ##class(%DocDB.Database).%GetDatabase("OperServers")
		do db.%SaveDocument(..StatusData)
	}

Storage Default
{
<Data name="HomeDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SystemId</Value>
</Value>
<Value name="3">
<Value>GroupName</Value>
</Value>
</Data>
<Data name="StatusData">
<Attribute>StatusData</Attribute>
<Structure>node</Structure>
<Subscript>"StatusData"</Subscript>
</Data>
<DataLocation>^zsys.RAM.HomeDataD</DataLocation>
<DefaultData>HomeDataDefaultData</DefaultData>
<IdLocation>^zsys.RAM.HomeDataD</IdLocation>
<IndexLocation>^zsys.RAM.HomeDataI</IndexLocation>
<StreamLocation>^zsys.RAM.HomeDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}