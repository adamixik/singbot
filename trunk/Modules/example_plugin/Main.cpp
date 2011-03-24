//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix
// License: See LICENSE in root directory
//
//==========================================================================

#include <stdio.h>
#include "Main.h"
#include "SDK/CUtils.h"
#include "CFunctions.h"

std::list<SQVM*> g_VMs;

char * g_szModuleName = "Example module";

EXPORT void LoadModule(char * szModuleName)
{
	printf(">> Hello world from %s plugin!\n", g_szModuleName);
	strcpy(szModuleName, g_szModuleName);	
}

EXPORT void UnloadModule()
{
	printf(">> %s plugin got unloaded.\n", g_szModuleName);
}

EXPORT void ScriptLoad(SQVM * pVM)
{
	g_VMs.push_back(pVM);
	RegisterFunction(pVM, "HelloWorld", CFunctions::HelloWorld, -1, NULL);
}

EXPORT void ScriptUnload(SQVM * pVM)
{

}
