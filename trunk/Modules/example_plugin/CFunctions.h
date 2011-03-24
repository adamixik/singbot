//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix
// License: See LICENSE in root directory
//
//==========================================================================

#include "Main.h"
#pragma once

#define FUNCTION(name) static SQInteger name(SQVM* pVM);
#define FUNCTION_IMPL(name) SQInteger CFunctions::name(SQVM* pVM)

class CFunctions
{
public:
	FUNCTION(HelloWorld);
};