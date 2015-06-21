GM.Name			= "zoba" --What is your Gamemode's name?
GM.Author		= "lebull" -- Who authored it?
GM.Email		= "lebullonwow@yahoo.com" --Your email?
GM.Website      = "example.com" --Website, only if you feel it
 

AddCSLuaFile( "cl_init.lua" ) --Tell the server that the client needs to download cl_init.lua
AddCSLuaFile( "shared.lua" ) --Tell the server that the client needs to download shared.lua

include( 'shared.lua' ) --Tell the server to load shared.lua


[[
        I want to make an object that handles hook implictely.  You should be able to activate and deactivate the
    object to call hook.add and hook.remove.  It should consider functions with names "hook_[hookName]_functionName".
    The name of the hook (2nd parameter of hook.add) should be generated.
]]
