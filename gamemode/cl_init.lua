--https\//github.com/icedream/gmod-disguiser/blob/master/lua/weapons/disguiser/cl_3rdperson.lua

if CLIENT then
	include ("camera.lua")
end

	--TODO\
	-- Adjust the height of the camera with the mouse wheel.
	--	We can do this logorithmically, and set the initial alt based on the
	--	user's spawn z position.
	-- Keep mouse bound to the game window.
	-- Lock camera to world boundries
	-- Should players be able to aim at the ground?