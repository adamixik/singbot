//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix
// License: See LICENSE in root directory
//
//==========================================================================


#include "Main.h"

FUNCTION_IMPL(HelloWorld)
{
	printf("Hello world from example module!\n");

	sq_pushbool(pVM, true);
	return 1;
}