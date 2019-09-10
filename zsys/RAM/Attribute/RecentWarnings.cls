Class zsys.RAM.Attribute.RecentWarnings
{
	ClassMethod getValue() as %DynamicObject{
		set nameValuePair={}
		set nameValuePair.Name="RecentWarnings"
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