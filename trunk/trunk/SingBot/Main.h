//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix, jenksta
// License: See LICENSE in root directory
//
//==========================================================================

#pragma once

#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <string>
#include <list>
#include <map>
#include <queue>
#include <math.h>
#include <assert.h>

#ifdef WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#else
typedef unsigned long DWORD;
typedef unsigned short WORD;
typedef char *PCHAR;
typedef void *PVOID;
typedef unsigned char BYTE;
#define Sleep(ms) usleep(ms * 1000)
#include <dlfcn.h>
#include <sys/time.h>

inline long GetTickCount()
{
        struct timeval tv;

        if(gettimeofday(&tv, NULL) != 0)
                return 0;

        return ((tv.tv_sec * 1000) + (tv.tv_usec / 1000));
}
#endif

// SingBot Debug
#define _SINGBOT_DEBUG

#define INVALID_ENTITY_ID 0xFF

enum eEntityType
{
	ENTITY_TYPE_NONE,
	ENTITY_TYPE_ROOT,
	ENTITY_TYPE_RESOURCE,
	ENTITY_TYPE_TIMER,
	ENTITY_TYPE_BOT,
	ENTITY_TYPE_USER,
	ENTITY_TYPE_CUSTOM,
	ENTITY_TYPE_MAX
};

typedef unsigned short EntityID;
#define MAX_ENTITIES           0xFFFE
#define INVALID_ENTITY_ID_LONG 0xFFFF

#include <IRCSocket.h>
#include <TinyXML/tinyxml.h>
#include <TinyXML/ticpp.h>
#include <squirrel/squirrel.h>
#include <CString.h>
#include <CXML.h>
#include <CConfig.h>
#include <CLibrary.h>
#include <CModules.h>
#include <CIRC.h>

// Scripting
#include <scripting/CEntity.h>
#include <scripting/CRootEntity.h>
#include <scripting/CSquirrelArguments.h>
#include <scripting/CSquirrel.h>
#include <scripting/CTimer.h>
#include <scripting/CTimers.h>
#include <scripting/CResource.h>
#include <scripting/CResourceManager.h>

// Shared natives
#include <scripting/natives/NativesCommon.h>
#include <scripting/natives/CEntityNatives.h>
#include <scripting/natives/CResourceNatives.h>
#include <scripting/natives/CEventNatives.h>
#include <scripting/natives/CTimerNatives.h>

// Natives
#include <scripting/natives/CBotNatives.h>
#include <scripting/natives/CIRCNatives.h>
