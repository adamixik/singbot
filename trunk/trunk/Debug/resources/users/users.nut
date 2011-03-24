local cmdPrefix = "!";

local users = {};

function OpenStorage()
{
	return EasyINI("storage/users.ini");
}

function IsUserAuth(user, host)
{
	local ini = OpenStorage();
	if(!ini.keyExists(user, "Host"))
	{
		return false;
	}
	local uhost = ini.getKey(user, "Host").tostring();
	local uauth = ini.getKey(user, "Auth").tointeger();
	
	if(uhost == host && uauth == 1)
	{
		return true;
	}
	return false;
}

function IsAuth(nick, host)
{
	if(users[nick] != "")
		return IsUserAuth(users[nick], host);
	else
		return false;
}

function IsAdmin(user)
{
	local ini = OpenStorage();
	if(!ini.keyExists(user, "Admin"))
	{
		return 0;
	}
	
	return ini.getKey(user, "Admin").tointeger();
}

function SetFlag(user, flag, var)
{
	local ini = OpenStorage();
	local userflag = "Flags." + user;
	ini.setKey(userflag, flag, var);
	ini.saveData();
}

function GetFlag(user, flag)
{
	local ini = OpenStorage();
	local userflag = "Flags." + user;
	if(!ini.keyExists(userflag, "DefaultFlag"))
	{
		return -1;
	}
	return ini.getKey(userflag, flag);
}

function prefix(str)
{
	return cmdPrefix+str;
}

function onConnect()
{

}

function onPrivmsg(channel, nick, host, ident, params)
{
	local cmd = split(params, " ");
	local ini = OpenStorage();
	
	if(!users.rawin(nick))
		users[nick] <- "";
	
	local target = 0;
	
	if(channel == GetBotNick())
	{
		target = nick;
	}
	else
	{
		target = channel;
	}
	
	if(cmd[0] == prefix("register"))
	{
		if(channel != GetBotNick())
			return;
		
		if(cmd.len() < 3)
		{
			return Privmsg(target, nick + ", " + "Syntax: " + prefix("register") + " [username] [password].");
		}
		
		local user = cmd[1].tostring();
		local password = cmd[2].tostring();
		
		if(user.find("Flags.") != null)
		{
			return Privmsg(target, nick + ", " + "Incorrect username.");
		}
		
		if(ini.keyExists(user, "Password"))
		{
			return Privmsg(target, nick + ", " + "This account name is already taken.");
		}
		
		ini.setKey(user, "Password", MD5(password));
		ini.setKey(user, "Flags", "0");
		ini.setKey(user, "Host", host);
		ini.setKey(user, "Admin", "0");
		ini.setKey(user, "Last", time().tostring());
		ini.setKey("Flags." + user, "DefaultFlag", "def");
		ini.saveData();
		
		Privmsg(target, nick + ", " + "Account [" + user + "] with password [" + password + "] and host [" + host +"] successfully registered.");
		return;
	}
	if(cmd[0] == prefix("auth"))
	{
		if(channel != GetBotNick())
			return;
		
		if(cmd.len() < 3)
		{
			return Privmsg(target, nick + ", " + "Syntax: " + prefix("auth") + " [username] [password].");
		}
		
		local user = cmd[1].tostring();
		local password = cmd[2].tostring();
		
		if(!ini.keyExists(user, "Password"))
		{
			return Privmsg(target, nick + ", " + "This account isn't registered.");
		}
		
		if (MD5(password) != ini.getKey(user, "Password"))
			return Privmsg(target, nick + ", " + "Invalid password!");
			
		local last = ini.getKey(user, "Last");
			
		ini.setKey(user, "Host", host);
		ini.setKey(user, "Auth", "1");
		ini.setKey(user, "Last", time().tostring());
		ini.saveData();
		
		users[nick] = user;
		
		Privmsg(target, nick + ", " + "Auth success.");
		return;
	}
	if(cmd[0] == prefix("unauth"))
	{
		if(channel != GetBotNick())
			return;
		
		if(!IsAuth(nick, host))
			return Privmsg(target, nick + ", " + "You should log in before!");
		
		local user = users[nick];
		
		ini.setKey(user, "Host", host);
		ini.setKey(user, "Auth", "0");
		ini.saveData();
		
		users.rawdelete(nick);
		
		Privmsg(target, nick + ", " + "Good bye.");
		return;
	}
	if(cmd[0] == prefix("join"))
	{
		if(!IsAuth(nick, host))
			return Privmsg(target, nick + ", " + "You should log in before!");
			
		if(!IsAdmin(users[nick]))
			return Privmsg(target, nick + ", " + "You should be admin to use this function!");
			
		if(cmd.len() < 2)
		{
			return Privmsg(target, nick + ", " + "Syntax: " + prefix("join") + " [channel] [password (optional)].");
		}
		
		local channel = cmd[1].tostring();
		
		if(cmd.len() == 3)
		{
			JoinPass(channel, cmd[2].tostring());
		}
		else
		{
			Join(channel);
		}
		Privmsg(target, nick + ", " + "Success!");
		return;
	}
	if(cmd[0] == prefix("part"))
	{
		if(!IsAuth(nick, host))
			return Privmsg(target, nick + ", " + "You should log in before!");
			
		if(!IsAdmin(users[nick]))
			return Privmsg(target, nick + ", " + "You should be admin to use this function!");
			
		if(cmd.len() < 2)
		{
			return Privmsg(target, nick + ", " + "Syntax: " + prefix("part") + " [channel].");
		}
		
		local channel = cmd[1].tostring();
		
		Part(channel);
		Privmsg(target, nick + ", " + "Success!");
		return;
	}
	if(cmd[0] == prefix("msg"))
	{
		if(!IsAuth(nick, host))
			return Privmsg(target, nick + ", " + "You should log in before!");
			
		if(!IsAdmin(users[nick]))
			return Privmsg(target, nick + ", " + "You should be admin to use this function!");
			
		if(cmd.len() < 3)
		{
			return Privmsg(target, nick + ", " + "Syntax: " + prefix("msg") + " [nick/channel] [message].");
		}
		
		local targ = cmd[1].tostring();
		
		local startLen = prefix("msg").len() + targ.len() + 2;
		local msg = params.slice(startLen);
		
		Privmsg(targ, msg);
		Privmsg(target, nick + ", " + "Sent!");
		return;
	}
	if(cmd[0] == prefix("notice"))
	{
		if(!IsAuth(nick, host))
			return Privmsg(target, nick + ", " + "You should log in before!");
			
		if(!IsAdmin(users[nick]))
			return Privmsg(target, nick + ", " + "You should be admin to use this function!");
			
		if(cmd.len() < 3)
		{
			return Privmsg(target, nick + ", " + "Syntax: " + prefix("notice") + " [nick/channel] [message].");
		}
		
		local targ = cmd[1].tostring();
		
		local startLen = prefix("notice").len() + targ.len() + 2;
		local msg = params.slice(startLen);
		
		Notice(targ, msg);
		Privmsg(target, nick + ", " + "Sent!");
		return;
	}
	if(cmd[0] == prefix("setadmin"))
	{
		if(!IsAuth(nick, host))
			return Privmsg(target, nick + ", " + "You should log in before!");
			
		if(IsAdmin(users[nick]) != 1024)
			return Privmsg(target, nick + ", " + "You should be admin to use this function!");
			
		if(cmd.len() < 3)
		{
			return Privmsg(target, nick + ", " + "Syntax: " + prefix("setadmin") + " [account] [level].");
		}
		
		local targ = cmd[1].tostring();
		local level = cmd[2].tointeger();
		
		ini.setKey(targ, "Admin", level);
		ini.saveData();
		Privmsg(target, nick + ", " + "Success!");
		return;
	}
	if(cmd[0] == prefix("setflag"))
	{
		if(!IsAuth(nick, host))
			return Privmsg(target, nick + ", " + "You should log in before!");
			
		if(IsAdmin(users[nick]) != 1024)
			return Privmsg(target, nick + ", " + "You should be admin to use this function!");
			
		if(cmd.len() < 4)
		{
			return Privmsg(target, nick + ", " + "Syntax: " + prefix("setflag") + " [account] [flag] [value].");
		}
		
		local targ = cmd[1].tostring();
		local flag = cmd[2].tostring();
		local value = cmd[3].tostring();
		
		SetFlag(targ, flag, value);
		Privmsg(target, "Success!");
		return;
	}
	if(cmd[0] == prefix("getflag"))
	{
		if(!IsAuth(nick, host))
			return Privmsg(target, nick + ", " + "You should log in before!");
			
		if(IsAdmin(users[nick]) != 1024)
			return Privmsg(target, nick + ", " + "You should be admin to use this function!");
			
		if(cmd.len() < 3)
		{
			return Privmsg(target, "Syntax: " + prefix("getflag") + " [account] [flag].");
		}
		
		local targ = cmd[1].tostring();
		local flag = cmd[2].tostring();
		
		Privmsg(target, nick + ", " + "Flag [" + flag + "]: " + GetFlag(targ, flag));
		return;
	}
	if(cmd[0] == prefix("whois"))
	{
		if(!IsAuth(nick, host))
			return Privmsg(target, nick + ", " + "You should log in before!");
			
		if(IsAdmin(users[nick]) != 1024)
			return Privmsg(target, nick + ", " + "You should be admin to use this function!");
		
		local user = 0;
		if(cmd.len() == 1)
		{
			user = users[nick];
		}
		else
		{
			user = cmd[1].tostring();
		}
		
		if(!ini.keyExists(user, "Password"))
		{
			return Privmsg(target, nick + ", " + "This account isn't registered.");
		}
		
		local host = ini.getKey(user, "Host");
		local level = ini.getKey(user, "Admin");
		local auth = ini.getKey(user, "Auth");
		local last = ini.getKey(user, "Last").tointeger();
		
		last = time() - last;
		last = time() - last;
		last = date(last);
		
		local laststring = "";
		laststring = format("%d-%d-%d %d-%d-%d", last["day"], last["month"], last["year"], last["hour"], last["min"], last["sec"]);
		
		Privmsg(target, nick + ", " + "Whois [" + user + "]: [Host: " + host + "] [Admin: " + level + "] [Auth: " + auth + "] [Last login: " + laststring + "]");
		return;
	}
}

function onPrint(str)
{

}

function onScriptError(error)
{

}

addEventHandler("connect", getRootEntity(), onConnect);
addEventHandler("privmsg", getRootEntity(), onPrivmsg);
addEventHandler("print", getRootEntity(), onPrint);
addEventHandler("scriptError", getRootEntity(), onScriptError);