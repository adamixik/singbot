//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix
// License: See LICENSE in root directory
//
//==========================================================================

#pragma once
#include "Main.h"

class CIRC
{
public:
	CIRC(char * szServer, int iPort, char * szNick, char * szUserName, char * szRealName, char * szPassword);
	IRCSocket * GetConnection() { return conn; };

	String GetNick() { return m_nick; }
	String GetServer() { return m_server; }
	String GetUserName() { return m_username; }
	String GetRealName() { return m_realname; }
	int GetPort() { return m_port; }

	void Process();
private:
	IRCSocket * conn;
	String m_nick;
	String m_server;
	String m_username;
	String m_realname;
	int m_port;

	// Events
	static int OnMOTD(char* params, irc_reply_data* hostd, void* conn);
	static int OnPrivmsg(char* params, irc_reply_data* hostd, void* conn);
	static int OnJoin(char* params, irc_reply_data* hostd, void* conn);
	static int OnPart(char* params, irc_reply_data* hostd, void* conn);
	static int OnQuit(char* params, irc_reply_data* hostd, void* conn);
	static int OnMode(char* params, irc_reply_data* hostd, void* conn);
	static int OnNick(char* params, irc_reply_data* hostd, void* conn);
};
