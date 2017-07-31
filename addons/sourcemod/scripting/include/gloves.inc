#if defined _gloves_included_
  #endinput
#endif
#define _gloves_included_
 
native bool Gloves_IsClientUsingGloves(int client);
native void Gloves_RegisterCustomArms(int client, const char[] arms);
