include("shared.lua")
local CAMERA_ON = false
local CAMERA_POSITION = Vector(0, 0, 0)
local CAMERA_SPEED = 10
local CAMERA_MAXRANGE = Vector(10000, 10000, 10000)
if CLIENT then
  local moveCamera
  moveCamera = function()
    if CAMERA_ON then
      local mousey, mousex = gui.MousePos()
      local move_strip_size = {
        width = ScrW() * 0.05,
        height = ScrH() * 0.05
      }
      local push_camera = {
        left = math.Clamp((-mousey / move_strip_size.width) + 1, 0, 1),
        right = math.Clamp(((mousey - (ScrW() - move_strip_size.width)) / move_strip_size.width) + 1, 0, 1),
        up = math.Clamp((-mousex / move_strip_size.height) + 1, 0, 1),
        down = math.Clamp(((mousex - (ScrH() - move_strip_size.height)) / move_strip_size.height) + 1, 0, 1)
      }
      local camera_velocity = Vector()
      camera_velocity.y = (push_camera.left - push_camera.right) * CAMERA_SPEED
      camera_velocity.x = (push_camera.up - push_camera.down) * CAMERA_SPEED
      CAMERA_POSITION = CAMERA_POSITION + camera_velocity
    end
  end
  local isMouseInWindow
  isMouseInWindow = function()
    return Vector(gui.MousePos()):WithinAABox(Vector(0, 0), Vector(ScrW(), ScrH()))
  end
  local keepMouseInWindow
  keepMouseInWindow = function()
    if system.HasFocus() then
      local new_pos_x = math.Clamp(gui.MouseX(), 0, ScrW() - 1)
      local new_pos_y = math.Clamp(gui.MouseY(), 0, ScrH() - 1)
      return gui.SetMousePos(new_pos_x, new_pos_y)
    end
  end
  local calcCameraView
  calcCameraView = function(ply, pos, angles, fov)
    if CAMERA_ON then
      if system.HasFocus() and isMouseInWindow() then
        moveCamera()
      end
      local view = {
        origin = CAMERA_POSITION,
        angles = -Angle(-70, 0, 0),
        fov = fov
      }
      return view
    end
  end
  hook.Add('CalcView', 'zoba.CalcCameraView', calcCameraView)
  local startFire
  startFire = function(mouseCode, aimVector)
    if mouseCode == 107 then
      return RunConsoleCommand('+attack')
    end
  end
  hook.Add('GUIMousePressed', 'zoba.startFire', startFire)
  local endFire
  endFire = function(mouseCode, aimVector)
    if mouseCode == 107 then
      return RunConsoleCommand('-attack')
    end
  end
  hook.Add('GUIMouseReleased', 'zoba.endFire', endFire)
  local setAimPos
  setAimPos = function()
    if CAMERA_ON then
      local trace_params = {
        start = CAMERA_POSITION,
        endpos = CAMERA_POSITION + gui.ScreenToVector(gui.MousePos()) * 10000,
        filter = function(ent)
          return ent:GetClass() == "worldspawn"
        end
      }
      local trace = util.TraceLine(trace_params).HitPos
      return LocalPlayer():SetEyeAngles((trace - LocalPlayer():GetPos()):Angle())
    end
  end
  hook.Add("Tick", "zoba.setAimPos", setAimPos)
  local startCam
  startCam = function()
    gui.EnableScreenClicker(true)
    CAMERA_POSITION = LocalPlayer():GetPos() + Vector(-200, 0, 500)
    CAMERA_ON = true
    return print("Start: ", CAMERA_ON)
  end
  usermessage.Hook("startcam", startCam)
  local stopCam
  stopCam = function()
    print("Stop")
    gui.EnableScreenClicker(false)
    CAMERA_ON = false
  end
  usermessage.Hook("stopcam", stopCam)
  return hook.Add("ShouldDrawLocalPlayer", "MyShouldDrawLocalPlayer", function(ply)
    return CAMERA_ON
  end)
end
