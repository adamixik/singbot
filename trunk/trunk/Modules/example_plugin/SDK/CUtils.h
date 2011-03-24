//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix
// License: See LICENSE in root directory
//
//==========================================================================

#include "Main.h"

void RegisterFunction(HSQUIRRELVM pVM, char * szFunc, SQFUNCTION func, int params, const char * szTemplate);
void RegisterVariable(HSQUIRRELVM pVM, const char * szVarName, bool bValue);
void RegisterVariable(HSQUIRRELVM pVM, const char * szVarName, int iValue);
void RegisterVariable(HSQUIRRELVM pVM, const char * szVarName, float fValue);
void RegisterVariable(HSQUIRRELVM pVM, const char * szVarName, const char * szValue);
