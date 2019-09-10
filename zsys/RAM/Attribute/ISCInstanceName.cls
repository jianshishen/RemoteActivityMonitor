Class zsys.RAM.Attribute.ISCInstanceName
{
	ClassMethod getValue() as %DynamicObject{
		set nameValuePair={}
		set nameValuePair.Name="ISCInstanceName"
		try{
		set nameValuePair.Value=##class(%SYS.System).GetInstanceName()
		return nameValuePair
				}
		catch ex{
			set status = ex.AsStatus()
			do ex.Log()
			return $$$ERROR("10001",nameValuePair.Name_" Collection Failed")
		}
	}
}