Class zsys.RAM.Attribute.CPUCount
{
	ClassMethod getValue() as %DynamicObject{
		set nameValuePair={}
		set nameValuePair.Name="CPUCount"
		try{
		set nameValuePair.Value=##class(%SYSTEM.CPU).%New().nCores
		return nameValuePair
		}
		catch ex{
			set status = ex.AsStatus()
			do ex.Log()
			return $$$ERROR("10001",nameValuePair.Name_" Collection Failed")
		}
	}
}