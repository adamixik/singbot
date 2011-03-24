//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix
// License: See LICENSE in root directory
//
//==========================================================================

#pragma once

#include <Main.h>

class CBotNatives
{
public:
	static void LoadFunctions(CSquirrel* pSquirrel);
	static int  Log(SQVM* pVM);

	static int  GetBotNick(SQVM* pVM);
	static int  GetServer(SQVM* pVM);
	static int  GetBotUserName(SQVM* pVM);
	static int  GetBotRealName(SQVM* pVM);
	static int  GetServerPort(SQVM* pVM);
};
