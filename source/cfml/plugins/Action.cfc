<!--- 
 *
 * Copyright (c) 2016, Paul Klinkenberg, Utrecht, The Netherlands.
 * All rights reserved.
 *
 * Date: 2016-02-10 16:27:33
 * Revision: 2.2.0.
 * Project info: http://www.lucee.nl/post.cfm/railo-admin-log-analyzer (installer version)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either 
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public 
 * License along with this library.  If not, see <http://www.gnu.org/licenses/>.
 * 
 ---><cfcomponent hint="I contain the main functions for the log Analyzer Installer plugin" extends="lucee.admin.plugin.Plugin">
	<cffunction name="init" hint="this function will be called to initalize">
		<cfargument name="lang" type="struct">
		<cfargument name="app" type="struct">
	</cffunction>
	
	
	<cffunction name="overview" output="yes" hint="Shows">
		<cfargument name="lang" type="struct">
		<cfargument name="app" type="struct">
		<cfargument name="req" type="struct">
		<cfset arguments.req.installedlocationsFile = "installedlocations.log" />
		<!--- get all web contexts --->
		<cfadmin
			action="getContextes"
			type="server"
			password="#session.passwordserver#"
			returnVariable="arguments.req.qWebContexts"/>
	</cffunction>
	

	<cffunction name="getAnalyzerVersion" output="false" hint="Returns the Log analyzer version to install">
		<cfset local.zipFile = expandPath('./Loganalyzer.zip') />
		<cfif not fileExists(local.zipFile)>
			<cfreturn "[version unknown]" />
		</cfif>
		<cftry>
			<cfset local.config = xmlParse(fileRead(local.zipFile & "$config.xml")) />
			<cfreturn local.config.config.info.version.xmlText />
			<cfcatch>
				<cfreturn "[version error: #cfcatch.message#]" />
			</cfcatch>
		</cftry>
	</cffunction>


</cfcomponent>