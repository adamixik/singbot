//============== SingBot2 - svn://adamix.ru/singbot2 ======================
//
// Author(s): adamix
// License: See LICENSE in root directory
//
//==========================================================================

#include "Main.h"
#include "CIRC.h"

CResourceManager * g_pResourceManager = NULL;
CRootEntity * g_pRootEntity = NULL;
CIRC * g_pIRC = NULL;
CConfig * g_pConfig = NULL;

int main()
{
	CEntityIDs::Initalize();
	g_pRootEntity = new CRootEntity();
	g_pResourceManager = new CResourceManager();
	g_pConfig = new CConfig();

	if(!g_pConfig->Open("SingBot2.conf"))
	{
		printf("Can't open SingBot2.conf. Halt!");
		exit(1);
	}

	if(g_pConfig->GetXML()->findNode("Module"))
	{
		while(true)
		{
			String strModule = g_pConfig->GetXML()->nodeContent();

			if(strModule && !strModule.IsEmpty())
				CModules::Load(strModule.C_String());

			if(!g_pConfig->GetXML()->nextNode() || strcmp(g_pConfig->GetXML()->nodeName(), "Module") != 0)
				break;
		}
	}
	g_pConfig->GetXML()->nodeToRoot();

	if(g_pConfig->GetXML()->findNode("Resource"))
	{
		while(true)
		{
			String strResource = g_pConfig->GetXML()->nodeContent();

			if(strResource && !strResource.IsEmpty())
				g_pResourceManager->Load(strResource);

			if(!g_pConfig->GetXML()->nextNode() || strcmp(g_pConfig->GetXML()->nodeName(), "Resource") != 0)
				break;
		}
	}
	g_pConfig->GetXML()->nodeToRoot();

	String server, nick, username, realname, password;
	int port;
	g_pConfig->GetValueAsString("Server", "irc.gtanet.com", &server);
	g_pConfig->GetValueAsString("Nick", "SingBot2", &nick);
	g_pConfig->GetValueAsString("UserName", "SingBot", &username);
	g_pConfig->GetValueAsString("RealName", "SingBot", &realname);
	g_pConfig->GetValueAsString("Password", "", &password);
	g_pConfig->GetValueAsInteger("Port", 6667, &port);

	printf("-----------------------------------------\n");
	printf("Server: %s\n", server.C_String());
	printf("Port: %d\n", port);
	printf("Nick: %s\n", nick.C_String());
	printf("Username: %s\n", username.C_String());
	printf("Realname: %s\n", realname.C_String());
	printf("-----------------------------------------\n");

	g_pIRC = new CIRC(server.GetData(), port, nick.GetData(), username.GetData(), realname.GetData(), password.GetData());

	while(true)
	{
		g_pIRC->Process();
		Sleep(50);
	}
}
