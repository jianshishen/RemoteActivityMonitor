Class zsys.RAM.Attribute.SystemUpTime
{
	ClassMethod getValue() as %DynamicObject{
		set nameValuePair={}
		set nameValuePair.Name="SystemUpTime"
		try{
			set $NAMESPACE="%SYS"
			set nameValuePair.Value=##class(SYS.Stats.Dashboard).Sample().SystemUpTime
			set $NAMESPACE="RAM"
			return nameValuePair
		}
		catch ex{
			set status = ex.AsStatus()
			do ex.Log()
			return $$$ERROR("10001",nameValuePair.Name_" Collection Failed")
		}
	}
}