Class zsys.RAM.Attribute.IPAddress
{

	ClassMethod getValue() as %DynamicObject{
		set nameValuePair={}
		set nameValuePair.Name="IPAddress"
		try{
		set nameValuePair.Value=$SYSTEM.INetInfo.HostNameToAddr($SYSTEM.INetInfo.LocalHostName(),1)
		return nameValuePair
		}
		catch ex{
			set status = ex.AsStatus()
			do ex.Log()
			return $$$ERROR("10001",nameValuePair.Name_" Collection Failed")
		}
	}

}