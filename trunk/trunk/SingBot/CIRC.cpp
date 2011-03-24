//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix
// License: See LICENSE in root directory
//
//==========================================================================


#include <Main.h>

#ifdef WIN32
#include <ws2tcpip.h>
#include <process.h>
#else

#endif

extern CResourceManager * g_pResourceManager;
extern CRootEntity * g_pRootEntity;
extern CIRC * g_pIRC;
extern CConfig * g_pConfig;

void FixParams(char * params)
{
	if(params != NULL && params[0] == ':')
	{
		std::string str = params;
		str.replace(0, 1, "");
		strcpy(params, str.c_str());
	}
}

int CIRC::OnMOTD(char* params, irc_reply_data* hostd, void* conn)
{
	IRCSocket* irc_conn=(IRCSocket*)conn;
	g_pRootEntity->CallEvent("connect", NULL);
	return 0;
}

int CIRC::OnPrivmsg(char* params, irc_reply_data* hostd, void* conn)
{
	IRCSocket* irc_conn=(IRCSocket*)conn;
	FixParams(params);
#ifdef _SINGBOT_DEBUG
	printf("PRIVMSG: [%s] [%s] %s\n", hostd->target, hostd->nick, params);
#endif

	CSquirrelArguments args;
	args.push(hostd->target);
	args.push(hostd->nick);
	args.push(hostd->host);
	args.push(hostd->ident);
	args.push(params);
	g_pRootEntity->CallEvent("privmsg", &args);

	return 0;
}

int CIRC::OnJoin(char* params, irc_reply_data* hostd, void* conn)
{
	IRCSocket* irc_conn=(IRCSocket*)conn;
	FixParams(params);
#ifdef _SINGBOT_DEBUG
	printf("JOIN: [%s] [%s]\n", params, hostd->nick);
#endif

	CSquirrelArguments args;
	args.push(hostd->nick);
	args.push(hostd->host);
	args.push(hostd->ident);
	args.push(params);
	g_pRootEntity->CallEvent("join", &args);
	return 0;
}

int CIRC::OnPart(char* params, irc_reply_data* hostd, void* conn)
{
	IRCSocket* irc_conn=(IRCSocket*)conn;
	FixParams(params);
#ifdef _SINGBOT_DEBUG
	printf("PART: [%s] [%s]\n", params, hostd->nick);
#endif

	CSquirrelArguments args;
	args.push(hostd->nick);
	args.push(hostd->host);
	args.push(hostd->ident);
	args.push(params);
	g_pRootEntity->CallEvent("part", &args);
	return 0;
}

int CIRC::OnQuit(char* params, irc_reply_data* hostd, void* conn)
{
	IRCSocket* irc_conn=(IRCSocket*)conn;
	FixParams(params);
#ifdef _SINGBOT_DEBUG
	printf("QUIT: [%s]\n", hostd->nick);
#endif

	CSquirrelArguments args;
	args.push(hostd->nick);
	args.push(hostd->host);
	args.push(hostd->ident);
	g_pRootEntity->CallEvent("quit", &args);
	return 0;
}

int CIRC::OnMode(char* params, irc_reply_data* hostd, void* conn)
{
	IRCSocket* irc_conn=(IRCSocket*)conn;
	FixParams(params);
#ifdef _SINGBOT_DEBUG
	printf("MODE: [%s] [%s] %s\n", hostd->target, hostd->nick, params);
#endif
	return 0;
}

int CIRC::OnNick(char* params, irc_reply_data* hostd, void* conn)
{
	IRCSocket* irc_conn=(IRCSocket*)conn;
	FixParams(params);
#ifdef _SINGBOT_DEBUG
	printf("NICK: [%s] %s\n", hostd->nick, params);
#endif

	CSquirrelArguments args;
	args.push(hostd->nick);
	args.push(hostd->host);
	args.push(hostd->ident);
	args.push(params);
	g_pRootEntity->CallEvent("nick", &args);
	return 0;
}



CIRC::CIRC(char * szServer, int iPort, char * szNick, char * szUserName, char * szRealName, char * szPassword)
{
#ifdef WIN32
	WSADATA wsaData;
	
	if (WSAStartup(MAKEWORD(1, 1), &wsaData))
	{
		printf("Failed to initialise winsock!\n");
	}
#endif
	m_nick = szNick;
	m_server = szServer;
	m_username = szUserName;
	m_realname = szRealName;
	m_port = iPort;

	conn = new IRCSocket();
	conn->start(szServer, iPort, szNick, szUserName, szRealName, szPassword);

	conn->hook_irc_command("001", &OnMOTD);
	conn->hook_irc_command("PRIVMSG", &OnPrivmsg);
	conn->hook_irc_command("JOIN", &OnJoin);
	conn->hook_irc_command("PART", &OnPart);
	conn->hook_irc_command("QUIT", &OnQuit);
	conn->hook_irc_command("MODE", &OnMode);
	conn->hook_irc_command("NICK", &OnNick);

	g_pRootEntity->CallEvent("init", NULL);
}

void CIRC::Process()
{
	conn->message_loop();
	g_pResourceManager->Process(GetTickCount());
}
