Class zsys.RAM.Attribute.ThisSampleDT
{
	ClassMethod getValue() as %DynamicObject{
		set nameValuePair={}
		set nameValuePair.Name="ThisSampleDT"
		try{
		set nameValuePair.Value=$zdatetime($h,4)
		return nameValuePair
		}
		catch ex{
			set status = ex.AsStatus()
			do ex.Log()
			return $$$ERROR("10001",nameValuePair.Name_" Collection Failed")
		}
	}
}