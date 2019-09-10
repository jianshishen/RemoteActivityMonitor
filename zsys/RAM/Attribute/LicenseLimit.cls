Class zsys.RAM.Attribute.LicenseLimit
{
	ClassMethod getValue() as %DynamicObject{
		set nameValuePair={}
		set nameValuePair.Name="LicenseLimit"
		try{
		set nameValuePair.Value=$SYSTEM.License.KeyLicenseUnits()
		return nameValuePair
				}
		catch ex{
			set status = ex.AsStatus()
			do ex.Log()
			return $$$ERROR("10001",nameValuePair.Name_" Collection Failed")
		}
	}
}