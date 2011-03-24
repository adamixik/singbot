//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix
// License: See LICENSE in root directory
//
//==========================================================================

#include "../Main.h"

extern SQVM * g_VMs[];

void RegisterFunction(HSQUIRRELVM pVM, char * szFunc, SQFUNCTION func, int params, const char * szTemplate)
{
	sq_pushroottable(pVM);

	sq_pushstring(pVM, szFunc, -1);
	sq_newclosure(pVM, func, 0);
	if(params != -1)
	{
		sq_setparamscheck(pVM, params, szTemplate);
	}
	sq_createslot(pVM, -3);
}

void RegisterVariable(HSQUIRRELVM pVM, const char * szVarName, bool bValue)
{
	sq_pushstring(pVM, szVarName, -1);
	sq_pushbool(pVM, bValue);
	sq_createslot(pVM, -3);
}

void RegisterVariable(HSQUIRRELVM pVM, const char * szVarName, int iValue)
{
	sq_pushstring(pVM, szVarName, -1);
	sq_pushinteger(pVM, iValue);
	sq_createslot(pVM, -3);
}

void RegisterVariable(HSQUIRRELVM pVM, const char * szVarName, float fValue)
{
	sq_pushstring(pVM, szVarName, -1);
	sq_pushfloat(pVM, fValue);
	sq_createslot(pVM, -3);
}

void RegisterVariable(HSQUIRRELVM pVM, const char * szVarName, const char * szValue)
{
	sq_pushstring(pVM, szVarName, -1);
	sq_pushstring(pVM, szValue, -1);
	sq_createslot(pVM, -3);
}
