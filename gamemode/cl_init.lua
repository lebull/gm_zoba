<<<<<<< HEAD
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
=======
local _ = [[/**
 *	https://github.com/icedream/gmod-disguiser/blob/master/lua/weapons/disguiser/cl_3rdperson.lua
 *
 *	TODO:
 *
 *
 *	Fire weapon when in camera
 *	Keep mouse bound to the game window.
 *	Lock camera to world boundries
 */]]
include("shared.lua")
if CLIENT then
  CAMERA_POSITION = Vector(0, 0, 0)
  CAMERA_SPEED = 10
  CAMERA_ON = false
  CAMERA_MAXRANGE = Vector(10000, 10000, 10000)
  local pushCamera
  pushCamera = function()
    if not CAMERA_ON then
      return 
    end
    local mousey, mousex = gui.MousePos()
    local horizontal_move_width = ScrW() * 0.05
    local vertical_move_width = ScrH() * 0.05
    local push_camera = {
      left = math.Clamp((-mousey / horizontal_move_width) + 1, 0, 1),
      right = math.Clamp(((mousey - (ScrW() - horizontal_move_width)) / horizontal_move_width) + 1, 0, 1),
      up = math.Clamp((-mousex / vertical_move_width) + 1, 0, 1),
      down = math.Clamp(((mousex - (ScrH() - vertical_move_width)) / vertical_move_width) + 1, 0, 1)
    }
    local camera_velocity = Vector()
    camera_velocity.y = (push_camera.left - push_camera.right) * CAMERA_SPEED
    camera_velocity.x = (push_camera.up - push_camera.down) * CAMERA_SPEED
    CAMERA_POSITION = CAMERA_POSITION + camera_velocity
  end
  local isMouseInWindow
  isMouseInWindow = function()
    if not (0 <= gui.MouseX() and gui.MouseX() <= ScrW()) then
      return false
    end
    if not (0 <= gui.MouseY() and gui.MouseY() <= ScrH()) then
      return false
    end
    return true
  end
  local calcOverheadView
  calcOverheadView = function(ply, pos, angles, fov)
    if not CAMERA_ON then
      return 
    end
    if system.HasFocus() and isMouseInWindow() then
      pushCamera()
    end
    local view = {
      angles = -Angle(-70, 0, 0),
      origin = CAMERA_POSITION,
      fov = fov
    }
    return view
  end
  hook.Add("CalcView", "zoba.calcOverheadView", calcOverheadView)
  local fireOnClick
  fireOnClick = function(mouseCode, aimVector)
    if mouseCode == 107 then
      return LocalPlayer():Fire()
    end
  end
  hook.Add("GUIMousePressed", "zoba.lookToFire", fireOnClick)
  local setAimPos
  setAimPos = function()
    if not CAMERA_ON then
      return 
    end
    local ply = LocalPlayer()
    local trace_params = {
      start = CAMERA_POSITION,
      endpos = CAMERA_POSITION + gui.ScreenToVector(gui.MousePos()) * 10000,
      filter = ent(function()
        return ent:GetClass() == "worldspawn"
      end)
    }
    local trace = util.TraceLine(trace_params).HitPos
    return ply:SetEyeAngles((trace - ply:GetPos()):Angle())
  end
  hook.Add("Tick", "zoba.setAimPos", setAimPos)
  local adjustCameraHeight
  adjustCameraHeight = function()
    return nil
  end
  local startCam
  startCam = function()
    gui.EnableScreenClicker(true)
    CAMERA_POSITION = LocalPlayer():GetPos() + Vector(-200, 0, 500)
    CAMERA_ON = true
  end
  usermessage.Hook("startcam", startCam)
  local stopCam
  stopCam = function()
    print("Stop")
    gui.EnableScreenClicker(false)
    CAMERA_ON = false
  end
  usermessage.Hook("stopcam", stopCam)
  return hook.Add("ShouldDrawLocalPlayer", "zoba.ShouldDrawLocalPlayer", ply(function()
    return CAMERA_ON
  end))
end
>>>>>>> origin/master
