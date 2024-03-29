//============== Networked: IV - http://code.networked-iv.com ==============
//
// File: CResource.h
// Project: Server
// Author(s): mabako
// License: See LICENSE in root directory
//
//==========================================================================

#pragma once

#include <Main.h>

class CResource : public CEntity
{
public:
	enum eResourceState
	{
		STATE_ERROR,
		STATE_LOADED,
		STATE_RUNNING,
		STATE_STARTUP_CANCELLED
	};

					CResource(String name);
					~CResource();

	bool			Reload();
	bool			Start();
	bool			Stop();
	bool			IsValidMeta();
	void			Process(DWORD dwTickCount);

	eResourceState	GetState();
	String			GetName();
	String			GetPath();
	CSquirrel*		GetVM();
	CTimers*		GetTimers();

	bool			SetParent(CEntity* pEntity);

private:
	bool			m_bValidMeta;
	bool			m_bSecure;
	String			m_strName;
	String			m_strResourcePath;
	eResourceState	m_eState;

	std::list<String> m_scripts;

	CSquirrel*		m_pVM;
	CTimers*		m_pTimers;
};
