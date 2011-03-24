local scriptingChannel = "#ivmp.script";

function onConnect()
{
	Join(scriptingChannel);
}

function onPrivmsg(channel, nick, host, ident, params)
{
	local splitstring = split(params, " ");
	if(channel != scriptingChannel) return;
	if(splitstring[0] == "!sq")
	{
		local returnString = compilestring("return " + params.slice(3))();
		if(returnString) {
			Privmsg(channel, "Result: " +returnString);
		} else {
			Privmsg(channel, "No result!");
		}
	}
	if(splitstring[0] == "!run")
	{
		local returnString = compilestring(params.slice(4))();
		if(returnString) {
			Privmsg(channel, "Result: " +returnString);
		} else {
			Privmsg(channel, "No result!");
		}
	}
}

function onPrint(str)
{
	//Privmsg(scriptingChannel, str);
}

function onScriptError(error)
{
	local splitstring = split(error, " ");
	if(splitstring[0] == "AN")
	{
		print(format("Error: %s\n", error));
		Privmsg(scriptingChannel, error);
	}
}

addEventHandler("connect", getRootEntity(), onConnect);
addEventHandler("privmsg", getRootEntity(), onPrivmsg);
addEventHandler("print", getRootEntity(), onPrint);
addEventHandler("scriptError", getRootEntity(), onScriptError);