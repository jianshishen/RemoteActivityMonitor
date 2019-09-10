Class zsys.RAM.Attribute.PreviousSampleDT
{
	ClassMethod getValue() as %DynamicObject{
		set nameValuePair={}
		set nameValuePair.Name="PreviousSampleDT"
		try{
		set nameValuePair.Value=0
		return nameValuePair
				}
		catch ex{
			set status = ex.AsStatus()
			do ex.Log()
			return $$$ERROR("10001",nameValuePair.Name_" Collection Failed")
		}
	}
}