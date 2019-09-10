Class zsys.RAM.Attribute.HostName
{
	ClassMethod getValue() as %DynamicObject{
		set nameValuePair={}
		set nameValuePair.Name="HostName"
		try{
		set nameValuePair.Value=$SYSTEM.INetInfo.LocalHostName()
		return nameValuePair
		}
		catch ex{
			set status = ex.AsStatus()
			do ex.Log()
			return $$$ERROR("10001",nameValuePair.Name_" Collection Failed")
		}
	}
}