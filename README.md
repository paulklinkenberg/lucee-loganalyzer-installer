# Lucee Log analyzer global installer

This is the source code of the _Log analyzer global installer_ plugin for [Lucee](http://www.lucee.org/),
to be used in the Lucee admin.

The plugin gives you the option to install the [Lucee Log analyzer](https://github.com/paulklinkenberg/lucee-loganalyzer) into any Lucee web context you want.

## Installing the plugin

For Lucee 4.x, you can [download the extension zip file](../blob/master/dist/classic/extension.zip),
and then upload it in your Lucee server admin, at http://[your-website-url]__/lucee/admin/server.cfm?action=extension.applications__

For Lucee 5, you will need [the .lex file](../blob/master/dist/modern/extension-loganalyzerinstaller-2.2.0.2.lex)
  

------------------------------------------------------------

# Includes complete Ant build code for Lucee plugins

This repo also contains the Ant code to _build a Lucee extension_. 
This is very probably more useful then the plugin itself :)

You can just copy and paste this repo,
change the plugin code at `source/cfml/plugins/`,
change the `build.properties` values,
and then run the Ant build.

The Ant build code and directory structure was developed by Michael Offner.
