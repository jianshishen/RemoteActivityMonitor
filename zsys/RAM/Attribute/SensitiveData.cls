Class zsys.RAM.Attribute.SensitiveData
{
	ClassMethod getValue() as %DynamicObject{
		set nameValuePair={}
		set nameValuePair.Name="SensitiveData"
		try{
		set nameValuePair.Value="No Tim Tam today."
		return nameValuePair
		}
		catch ex{
			set status = ex.AsStatus()
			do ex.Log()
			return $$$ERROR("10001",nameValuePair.Name_" Collection Failed")
		}
	}
}