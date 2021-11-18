/*  CS:GO Gloves SourceMod Plugin
 *
 *  Copyright (C) 2017 Kağan 'kgns' Üstüngel
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("Gloves_IsClientUsingGloves", Native_IsClientUsingGloves);
	CreateNative("Gloves_RegisterCustomArms", Native_RegisterCustomArms);
	CreateNative("Gloves_SetArmsModel", Native_SetArmsModel);
	CreateNative("Gloves_GetArmsModel", Native_GetArmsModel);
	return APLRes_Success;
}

public int Native_IsClientUsingGloves(Handle plugin, int numParams)
{
	int clientIndex = GetNativeCell(1);
	int playerTeam = GetClientTeam(clientIndex);
	return g_iGloves[clientIndex][playerTeam] != 0;
}

public int Native_RegisterCustomArms(Handle plugin, int numParams)
{
	int clientIndex = GetNativeCell(1);
	int playerTeam = GetClientTeam(clientIndex);
	GetNativeString(2, g_CustomArms[clientIndex][playerTeam], 256);
}

public int Native_SetArmsModel(Handle plugin, int numParams)
{
	int clientIndex = GetNativeCell(1);
	int playerTeam = GetClientTeam(clientIndex);
	GetNativeString(2, g_CustomArms[clientIndex][playerTeam], 256);
	if(g_iGloves[clientIndex][playerTeam] == 0)
	{
		SetEntPropString(clientIndex, Prop_Send, "m_szArmsModel", g_CustomArms[clientIndex][playerTeam]);
	}
}

public int Native_GetArmsModel(Handle plugin, int numParams)
{
	int clientIndex = GetNativeCell(1);
	int playerTeam = GetClientTeam(clientIndex);
	int size = GetNativeCell(3);
	SetNativeString(2, g_CustomArms[clientIndex][playerTeam], size);
}

public int Native_SetClientGloves(Handle plugin, int numparams)
{
	int client = GetNativeCell(1);
	char updateFields[128], teamName[4];

	int team = GetNativeCell(4);

	g_iGroup[client][team] = GetNativeCell(2);
	g_iGloves[client][team] = GetNativeCell(3);
	if(team == CS_TEAM_T)
	{
		teamName = "t";
	}
	else if(team == CS_TEAM_CT)
	{
		teamName = "ct";
	}
	Format(updateFields, sizeof(updateFields), "%s_group = %i, %s_glove = %i", teamName, g_iGroup[client][team], teamName, g_iGloves[client][team]);
	UpdatePlayerData(client, updateFields);
	
	if(team == GetClientTeam(client))
	{
		int activeWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
		if(activeWeapon != -1)
		{
			SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", -1);
		}
		GivePlayerGloves(client);
		if(activeWeapon != -1)
		{
			DataPack dpack;
			CreateDataTimer(0.1, ResetGlovesTimer, dpack);
			dpack.WriteCell(client);
			dpack.WriteCell(activeWeapon);
		}
	}
	
	return 0;
}