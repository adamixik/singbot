//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix
// License: See LICENSE in root directory
//
//==========================================================================

#include <Main.h>

typedef bool (* LoadModule_t)(char * szName);
typedef void (* ScriptLoad_t)(SQVM* pVM);
typedef void (* ScriptUnload_t)(SQVM* pVM);

class CModule
{
public:
	CModule(const char * szPath);
	~CModule();

	void ScriptLoad(SQVM* pVM);
	void ScriptUnload(SQVM* pVM);

	bool GetValid() { return m_bValid; }
private:
	CLibrary * m_library;

	LoadModule_t m_pfnLoadModule;
	ScriptLoad_t m_pfnScriptLoad;
	ScriptUnload_t m_pfnScriptUnload;

	char m_szModuleName[128];

	bool m_bValid;

	void SetValid(bool bValid) { m_bValid = bValid; }
};

class CModules
{
public:
	static void UnloadAll();
	static bool Load(const char * szPath);
	static void ScriptLoad(SQVM* pVM);
	static void ScriptUnload(SQVM* pVM);
private:
	static std::list<CModule*> m_modules;
};