//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix
// License: See LICENSE in root directory
//
//==========================================================================

#include <Main.h>

extern CResourceManager * g_pResourceManager;
extern CIRC * g_pIRC;

void CBotNatives::LoadFunctions(CSquirrel* pSquirrel)
{
	pSquirrel->RegisterFunction("Log", Log, 1, "s");
	pSquirrel->RegisterFunction("GetBotNick", GetBotNick, 0, NULL);
	pSquirrel->RegisterFunction("GetServer", GetServer, 0, NULL);
	pSquirrel->RegisterFunction("GetBotUserName", GetBotUserName, 0, NULL);
	pSquirrel->RegisterFunction("GetBotRealName", GetBotRealName, 0, NULL);
	pSquirrel->RegisterFunction("GetServerPort", GetServerPort, 0, NULL);
}

int CBotNatives::Log(SQVM* pVM)
{
	const char* szText;
	sq_getstring(pVM,2,&szText);

	printf("%s\n", szText);
	return 1;
}

int CBotNatives::GetBotNick(SQVM* pVM)
{
	sq_pushstring(pVM, g_pIRC->GetNick().C_String(), -1);
	return 1;
}
int CBotNatives::GetServer(SQVM* pVM)
{
	sq_pushstring(pVM, g_pIRC->GetServer().C_String(), -1);
	return 1;
}
int CBotNatives::GetBotUserName(SQVM* pVM)
{
	sq_pushstring(pVM, g_pIRC->GetUserName().C_String(), -1);
	return 1;
}
int CBotNatives::GetBotRealName(SQVM* pVM)
{
	sq_pushstring(pVM, g_pIRC->GetRealName().C_String(), -1);
	return 1;
}
int CBotNatives::GetServerPort(SQVM* pVM)
{
	sq_pushinteger(pVM, g_pIRC->GetPort());
	return 1;
}