Class zsys.RAM.Attribute.RAMCount
{
	ClassMethod getValue() as %DynamicObject{
		set nameValuePair={}
		set nameValuePair.Name="RAMCount"
		try{
			set ramValues={}
			set ramValues.GlobalBuffers=$listtostring(##class(%SYSTEM.Util).GlobalBuffers())
			set ramValues.RoutineBuffers=##class(%SYSTEM.Util).RoutineBufferSize()
			set nameValuePair.Value=ramValues.%ToJSON()
			return nameValuePair
		}
		catch ex{
			set status = ex.AsStatus()
			do ex.Log()
			return $$$ERROR("10001",nameValuePair.Name_" Collection Failed")
		}
	}
}