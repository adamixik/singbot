//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix
// License: See LICENSE in root directory
//
//==========================================================================

#ifdef WIN32
  #define EXPORT extern "C" __declspec(dllexport)
#else
  #define EXPORT extern "C"
#endif

#pragma once

#include "../squirrel/squirrel.h"
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <list>
#include "SDK/CUtils.h"
#include "CFunctions.h"
