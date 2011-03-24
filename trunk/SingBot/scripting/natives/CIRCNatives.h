//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix
// License: See LICENSE in root directory
//
//==========================================================================

#pragma once

#include <Main.h>

class CIRCNatives
{
public:
	static void LoadFunctions(CSquirrel* pSquirrel);
	static int  Raw(SQVM* pVM);
	static int  Join(SQVM* pVM);
	static int  JoinPass(SQVM* pVM);
	static int  Part(SQVM* pVM);
	static int  Privmsg(SQVM* pVM);
	static int  Notice(SQVM* pVM);
	static int  Mode(SQVM* pVM);
};
