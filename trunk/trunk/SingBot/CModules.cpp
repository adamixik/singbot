//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix
// License: See LICENSE in root directory
//
//==========================================================================

#include <Main.h>

std::list<CModule*> CModules::m_modules;

CModule::CModule(const char * szPath)
{
	SetValid(false);

	m_library = new CLibrary();

	String strPath;
	strPath.AppendF("modules/%s", szPath);

	if(!m_library) return;

	if(!m_library->Load(strPath.C_String()))
	{
		delete m_library;
		return;
	}

	m_pfnLoadModule = (LoadModule_t)m_library->GetProcedureAddress("LoadModule");
	m_pfnScriptLoad = (ScriptLoad_t)m_library->GetProcedureAddress("ScriptLoad");
	m_pfnScriptUnload = (ScriptUnload_t)m_library->GetProcedureAddress("ScriptUnload");

	if(!m_pfnLoadModule || !m_pfnScriptLoad || !m_pfnScriptUnload)
	{
		delete m_library;
		return;
	}

	strcpy(m_szModuleName, szPath);
	m_pfnLoadModule(m_szModuleName);
	printf("* Loaded module: %s\n", m_szModuleName);

	SetValid(true);
}

CModule::~CModule()
{
	if(m_library)
	{
		m_library->Unload();
		delete m_library;
	}
}

void CModule::ScriptLoad(SQVM* pVM)
{
	if(!m_library)
		return;

	m_pfnScriptLoad(pVM);
}

void CModule::ScriptUnload(SQVM* pVM)
{
	if(!m_library)
		return;

	m_pfnScriptUnload(pVM);
}

//--------------------------------------------------------

void CModules::UnloadAll()
{
	for(std::list<CModule *>::iterator i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		if(*i)
			delete *i;
	}
}

bool CModules::Load(const char * szPath)
{
	CModule *module = new CModule(szPath);

	if(module->GetValid())
		m_modules.push_back(module);

	return true;
}

void CModules::ScriptLoad(SQVM* pVM)
{
	for(std::list<CModule *>::iterator i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		if(*i)
			(*i)->ScriptLoad(pVM);
	}
}

void CModules::ScriptUnload(SQVM* pVM)
{
	for(std::list<CModule *>::iterator i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		if(*i)
			(*i)->ScriptUnload(pVM);
	}
}
