Class zsys.Request.ExamineStatusDataRequest Extends Ens.Request
{
	Property StatusData as %DynamicObject;
	Property SystemId as %String;
	
Storage Default
{
<Data name="ExamineStatusDataRequestDefaultData">
<Subscript>"ExamineStatusDataRequest"</Subscript>
<Value name="1">
<Value>SystemId</Value>
</Value>
</Data>
<Data name="StatusData">
<Attribute>StatusData</Attribute>
<Structure>node</Structure>
<Subscript>"zsys.Request.ExamineStatusDataRequest.StatusData"</Subscript>
</Data>
<DefaultData>ExamineStatusDataRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}