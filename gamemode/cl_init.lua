--https://github.com/icedream/gmod-disguiser/blob/master/lua/weapons/disguiser/cl_3rdperson.lua


include( "shared.lua" )

--Global Variables
local CAMERA_POSITION = Vector(0, 0, 0)
local CAMERA_SPEED = 10
local CAMERA_ON = false

local CAMERA_MAXRANGE = Vector(10000, 10000, 10000)

--Move the camera based on mouse position
local function moveCamera()

	if(CAMERA_ON == false) then
		return
	end

	--Move camera based on mouse pos
	local camera_velocity = Vector()
	local mousey, mousex = gui.MousePos()

	-- if the mouse w is in the left 5%
	horizontal_move_width = ScrW() * 0.05
	vertical_move_width = ScrH() * 0.05

	-- Ok, lets take the width.  If mouse is on px#0, then camera_velocity.x = -1.  If it's at px#<horizontal_move_width>, then its 0.
	local push_camera_left = math.Clamp((-mousey / horizontal_move_width) + 1, 0, 1)
	--If it's at ScrW() - horizontal_move_width, camera.velocity = 0.  If it's at ScrW(), camera_velocity.x = 1.
	local push_camera_right = math.Clamp(((mousey - (ScrW() - horizontal_move_width)) / horizontal_move_width) + 1, 0, 1)

	local push_camera_up = math.Clamp((-mousex / vertical_move_width) + 1, 0, 1)
	local push_camera_down = math.Clamp(((mousex - (ScrH() - vertical_move_width)) / vertical_move_width) + 1, 0, 1)

	camera_velocity.y = (push_camera_left - push_camera_right)*CAMERA_SPEED
	camera_velocity.x = (push_camera_up - push_camera_down)*CAMERA_SPEED

	--CAMERA_POSITION =math.Clamp(CAMERA_POSITION + camera_velocity, -CAMERA_MAXRANGE, CAMERA_MAXRANGE)
	CAMERA_POSITION = CAMERA_POSITION + camera_velocity
	
end

--Just a quick test to see if the mouse is in the window.
local function isMouseInWindow()
	if Vector(gui.MousePos()):WithinAABox(Vector(0, 0), Vector(ScrW(), ScrH())) then
		return true
	else
		return false
	end
end

--Keep the mouse within the window.
local function keepMouseInWindow()

	if system.HasFocus() then
		new_pos_x = math.Clamp(gui.MouseX(), 0, ScrW() - 1)
		new_pos_y = math.Clamp(gui.MouseY(), 0, ScrH() - 1)
		gui.SetMousePos(new_pos_x, new_pos_y)
	end
end

--Figure out where the camera needs to be
local function calcCameraView(ply, pos, angles, fov)

	if(CAMERA_ON == false) then
		return
	end

	keepMouseInWindow()

	if system.HasFocus() and isMouseInWindow() then
		moveCamera()
	end
	
	local view = {}

	view.angles = -Angle(-70, 0, 0)
	view.origin = CAMERA_POSITION
	view.fov = fov
	return view
end
hook.Add('CalcView', 'zoba.CalcCameraView', calcCameraView)

--When the mouse is pressed...
local function startFire(mouseCode, aimVector)
	print(mouseCode)
	if mouseCode == 107 then
		RunConsoleCommand('+attack')
	end
end
hook.Add('GUIMousePressed', 'zoba.startFire', startFire)

--When the mouse is pressed...
local function stopFire(mouseCode, aimVector)
	print(mouseCode)
	if mouseCode == 107 then
		RunConsoleCommand('-attack')
	end
end
hook.Add('GUIMouseReleased', 'zoba.stopFire', stopFire)


--Set where the player needs to look.
local function setAimPos()
	if(CAMERA_ON == false) then
		return
	end

	local ply = LocalPlayer()

	--Create a ray trace to determine where in the world the user's cursor is pointing.
	local trace_params = {}
	trace_params.start = CAMERA_POSITION
	trace_params.endpos = trace_params.start + gui.ScreenToVector(gui.MousePos()) * 10000
	trace_params.filter = function( ent ) 
		--if (ent:GetClass() == "worldspawn") then return true else return false end
		return ent:GetClass() == "worldspawn"
	end
	local trace = util.TraceLine(trace_params).HitPos

	--debugoverlay.Cross(ply:GetPos(), 100, 0)
	--debugoverlay.Line(ply:GetPos(), trace, 0.1, Color(0, 255, 0))

	--Force the player's character to look at this spot.
	ply:SetEyeAngles((trace - ply:GetPos()):Angle())
end
hook.Add("Tick", "setAimPos", setAimPos)

local function startCam()
	gui.EnableScreenClicker(true)
	CAMERA_POSITION = LocalPlayer():GetPos() + Vector(-200, 0, 500)
	CAMERA_ON = true
end
usermessage.Hook("startcam", startCam)

local function stopCam()
	print "Stop"
	gui.EnableScreenClicker(false)
	CAMERA_ON = false
end
usermessage.Hook("stopcam", stopCam)

hook.Add( "ShouldDrawLocalPlayer", "MyShouldDrawLocalPlayer", function( ply )
	return CAMERA_ON
end )

--TODO:
--  Adjust the height of the camera with the mouse wheel.
--	We can do this logorithmically, and set the initial alt based on the
--	user's spawn z position.
-- Keep mouse bound to the game window.
-- Lock camera to world boundries
-- Should players be able to aim at the ground?