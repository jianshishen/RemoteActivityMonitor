Class zsys.RAM.Attribute.LicenseTo
{
	ClassMethod getValue() as %DynamicObject{
		set nameValuePair={}
		set nameValuePair.Name="LicenseTo"
		try{
		set nameValuePair.Value=$SYSTEM.License.KeyCustomerName()
		return nameValuePair
		}
		catch ex{
			set status = ex.AsStatus()
			do ex.Log()
			return $$$ERROR("10001",nameValuePair.Name_" Collection Failed")
		}
	}
}