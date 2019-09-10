Class zsys.RAM.Attribute.LicenseMaxHit
{
	ClassMethod getValue() as %DynamicObject{
		set nameValuePair={}
		set nameValuePair.Name="LicenseMaxHit"
		try{
		set nameValuePair.Value=$SYSTEM.License.LUMaxConsumed()
		return nameValuePair
				}
		catch ex{
			set status = ex.AsStatus()
			do ex.Log()
			return $$$ERROR("10001",nameValuePair.Name_" Collection Failed")
		}
	}
}