<!--- 
 *
 * Copyright (c) 2016, Paul Klinkenberg, Utrecht, The Netherlands.
 * All rights reserved.
 *
 * Date: 2016-02-10 16:48:54
 * Revision: 2.2.1.
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
 ---><!--- get the installed locations log --->
<cfset var sep = server.separator.file />
<cfset var installedLocations = {} />
<cfset var line = "" />
<cfif fileExists(arguments.req.installedlocationsFile)>
	<cfloop file="#arguments.req.installedlocationsFile#" index="line">
		<cfset installedLocations[trim(line)] = "" />
	</cfloop>
</cfif>

<!--- form submitted? --->
<cfif structKeyExists(form, "installDirs") and len(form.installDirs)>
	<cfloop list="#form.installDirs#" index="line">
		<cfzip action="unzip" file="#getdirectoryFromPath(GetCurrentTemplatePath())#Loganalyzer.zip"
			destination="#line#" overwrite="yes" storepath="no" />
		<cfset installedLocations[line] = "" />
	</cfloop>
	<!--- save new installation paths log--->
	<cffile action="write" file="#arguments.req.installedlocationsFile#" output="#structKeyList(installedLocations, chr(10))#" />
	<cfoutput><div class="message">The Log analyzer is installed/updated in #listLen(form.installDirs)# locations.
		<br />You need to logout and login to the web admin again, before you can see the plugin in the navigation.
	</div></cfoutput>
</cfif>

<cfif structKeyExists(form, "UNinstallDirs") and len(form.UNinstallDirs)>
	<cfloop list="#form.UNinstallDirs#" index="line">
		<cftry>
			<cfdirectory action="delete" directory="#line#" recurse="yes" />
			<cfcatch>
				<div class="error">
					Error while deleting directory: #cfcatch.message# #cfcatch.Detail#
				</div>
			</cfcatch>
		</cftry>
		<cfset structDelete(installedLocations, line, false) />
	</cfloop>
	<!--- save new installation paths log--->
	<cffile action="write" file="#arguments.req.installedlocationsFile#" output="#structKeyList(installedLocations, chr(10))#" />
	<cfoutput><div class="message">The Log analyzer has been uninstalled from #listLen(form.UNinstallDirs)# locations.
		<br />You need to logout and login again to remove the plugin from the navigation in the web admin.
	</div></cfoutput>
</cfif>

<script type="text/javascript">
	function checkemAll(_do, cls)
	{
		var els = document.getElementsByTagName("INPUT");
		for (var i=0; i<els.length; i++)
		{
			if (els[i].className == cls)
				els[i].checked = _do;
		}
	}
</script>
<cfset frmaction = rereplace(action('overview'), "^[[:space:]]+", "") />
<cfoutput>
	<p>Use the form underneath to install or update the <a href="http://www.lucee.nl/post.cfm/railo-admin-log-analyzer" target="_blank" title="More info; links opens new window">Log analyzer plugin</a> <i>#getAnalyzerVersion()#</i> into your websites.</p>
	<form action="#frmaction#" method="post">
		<table class="tbl maintbl">
			<thead>
				<tr>
					<th style="vertical-align:top">Install / update
						<cfif arguments.req.qWebContexts.recordcount>
							<br /><input type="checkbox" name="checkall" id="checkall" onclick="checkemAll(this.checked, 'chk')" />
						</cfif>
					</th>
					<th style="vertical-align:top">Installed</th>
					<th style="vertical-align:top">Uninstall
						<cfif arguments.req.qWebContexts.recordcount>
							<br /><input type="checkbox" name="checkall2" id="checkall2" onclick="checkemAll(this.checked, 'chk2')" />
						</cfif>
					</th>
					<th style="vertical-align:top">Website path</th>
				</tr>
			</thead>
			<tbody>
				<!--- make it possible to install the plugin in the server admin --->
				<cfset var installPath = "" />
				<cfadmin type="server" action="getPluginDirectory" password="#session.passwordserver#"
					returnVariable="installPath" />
				<cfset installPath = rereplace(installPath, '[/\\]$', '') & "#sep#Log analyzer#sep#" />
				<tr>
					<td class="tblContent"><input type="checkbox" name="installDirs" class="chk" value="#htmlEditFormat(installPath)#" /></td>
					<td class="tblContent"><cfif structKeyExists(installedLocations, installpath)><strong>YES</strong><cfelse><em>no</em></cfif></td>
					<td class="tblContent"><cfif structKeyExists(installedLocations, installpath)><input type="checkbox" name="UNinstallDirs" class="chk2" value="#htmlEditFormat(installPath)#" /><cfelse>&nbsp;</cfif></td>
					<td class="tblContent">SERVER CONTEXT: #expandPath("{railo-server}")#</td>
				</tr>
				<cfset var sep = server.separator.file />
				<cfset var q = arguments.req.qWebContexts />
				<cfloop query="q">
					<cfset var installPath = rereplace(q.config_file, "[^/\\]+$", "") & "context#sep#admin#sep#plugin#sep#Log analyzer#sep#" />
					<tr>
						<td class="tblContent"><input type="checkbox" name="installDirs" class="chk" value="#htmlEditFormat(installPath)#" /></td>
						<td class="tblContent"><cfif structKeyExists(installedLocations, installpath)><strong>YES</strong><cfelse><em>no</em></cfif></td>
						<td class="tblContent"><cfif structKeyExists(installedLocations, installpath)><input type="checkbox" name="UNinstallDirs" class="chk2" value="#htmlEditFormat(installPath)#" /><cfelse>&nbsp;</cfif></td>
						<td class="tblContent">#q.path#</td>
					</tr>
				</cfloop>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="4">
						<input type="submit" class="button submit" value="Install/update" />
					</td>
				</tr>
			</tfoot>
		</table>
	</form>
</cfoutput>