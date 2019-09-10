Class zsys.Map.DashboardMap Extends %CSP.REST
{
	XData UrlMap[ XMLNamespace = "http://www.intersystems.com/urlmap" ]{
		<Routes>
		<Route Url="/:name" Method="GET" Call="HelloWorld" Cors="true"/>
		</Routes>
	}
	
	ClassMethod HelloWorld(Name as %String) as %Status{
		w "Hello "_Name
		quit $$$OK
	}
}