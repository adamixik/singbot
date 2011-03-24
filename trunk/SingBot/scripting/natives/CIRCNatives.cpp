//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix
// License: See LICENSE in root directory
//
//==========================================================================

#include <Main.h>

extern CResourceManager * g_pResourceManager;
extern CIRC * g_pIRC;

#define GET_STRING(idx, var, _var) \
		const char * _var; \
		sq_getstring(pVM, idx, &_var); \
		char *var = new char[strlen(_var)+1]; \
		strcpy(var, _var); \


void CIRCNatives::LoadFunctions(CSquirrel* pSquirrel)
{
	pSquirrel->RegisterFunction("Raw", Raw, -1, "s");
	pSquirrel->RegisterFunction("Join", Join, 1, "s");
	pSquirrel->RegisterFunction("JoinPass", JoinPass, 2, "ss");
	pSquirrel->RegisterFunction("Part", Part, 1, "s");
	pSquirrel->RegisterFunction("Privmsg", Privmsg, 2, "ss");
	pSquirrel->RegisterFunction("Notice", Notice, 2, "ss");
	pSquirrel->RegisterFunction("Mode", Mode, 2, "ss");
}

int CIRCNatives::Raw(SQVM* pVM)
{
	GET_STRING(2, szText, _szText);

	g_pIRC->GetConnection()->raw(szText);
	return 1;
}

int CIRCNatives::Join(SQVM* pVM)
{
	GET_STRING(2, szText, _szText);

	g_pIRC->GetConnection()->join(szText);
	return 1;
}

int CIRCNatives::JoinPass(SQVM* pVM)
{
	GET_STRING(2, szText, _szText);
	GET_STRING(3, szPass, _szPass);

	g_pIRC->GetConnection()->join(szText, szPass);
	return 1;
}

int CIRCNatives::Part(SQVM* pVM)
{
	GET_STRING(2, szText, _szText);

	g_pIRC->GetConnection()->part(szText);
	return 1;
}

int CIRCNatives::Privmsg(SQVM* pVM)
{
	GET_STRING(2, szTarget, _szTarget);
	GET_STRING(3, szText, _szText);

	g_pIRC->GetConnection()->privmsg(szTarget, szText);
	return 1;
}

int CIRCNatives::Notice(SQVM* pVM)
{
	GET_STRING(2, szTarget, _szTarget);
	GET_STRING(3, szText, _szText);

	g_pIRC->GetConnection()->notice(szTarget, szText);
	return 1;
}

int CIRCNatives::Mode(SQVM* pVM)
{
	GET_STRING(2, szTarget, _szTarget);
	GET_STRING(3, szModes, _szModes);

	g_pIRC->GetConnection()->mode(szTarget, szModes, "");
	return 1;
}
