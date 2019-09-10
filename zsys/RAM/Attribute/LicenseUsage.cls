Class zsys.RAM.Attribute.LicenseUsage
{
	ClassMethod getValue() as %DynamicObject{
		set nameValuePair={}
		set nameValuePair.Name="LicenseUsage"
		try{
		set nameValuePair.Value=$SYSTEM.License.LUConsumed()
		return nameValuePair
				}
		catch ex{
			set status = ex.AsStatus()
			do ex.Log()
			return $$$ERROR("10001",nameValuePair.Name_" Collection Failed")
		}
	}
}