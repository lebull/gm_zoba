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
