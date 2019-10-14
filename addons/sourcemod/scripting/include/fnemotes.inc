#if defined _fnemotes_included_
#endinput
#endif
#define _fnemotes_included_

/* Natives */

/**
 * Checks client's emote status
 *
 * @param client    Client's id
 * @return          True / False
 */
native bool fnemotes_IsClientEmoting(int client);

/**
 * When a client do a emote
 *
 * @param client    Client's id
 */
forward void fnemotes_OnEmote(int client);


public void __pl_fnemotes_SetNTVOptional()
{
	MarkNativeAsOptional("fnemotes_IsClientEmoting");
}