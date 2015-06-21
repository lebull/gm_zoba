if CLIENT then
  include("shared.lua")
  local HoverCam
  do
    local _base_0 = {
      enable = function(self)
        self.enabled = true
        self.position = LocalPlayer():GetPos() + Vector(-200, 0, 500)
        gui.EnableScreenClicker(true)
        return self:register_hooks()
      end,
      disable = function(self)
        gui.EnableScreenClicker(false)
        self.enabled = false
      end,
      hook_Tick = function(self)
        if self.enabled then
          local trace_params = {
            start = self.position,
            endpos = self.position + gui.ScreenToVector(gui.MousePos()) * 10000,
            filter = function(ent)
              return ent:GetClass() == "worldspawn"
            end
          }
          local trace = util.TraceLine(trace_params).HitPos
          return LocalPlayer():SetEyeAngles((trace - LocalPlayer():GetPos()):Angle())
        end
      end,
      hook_CalcView = function(self, ply, pos, angles, fov)
        if self.enabled then
          local isMouseInWindow
          isMouseInWindow = function()
            return Vector(gui.MousePos()):WithinAABox(Vector(0, 0), Vector(ScrW(), ScrH()))
          end
          if system.HasFocus() and isMouseInWindow() then
            self:move_camera()
          end
          local view = {
            origin = self.position,
            angles = -Angle(-70, 0, 0),
            fov = fov
          }
          return view
        else
          return nil
        end
      end,
      hook_ShouldDrawLocalPlayer = function(self, ply)
        return self.enabled
      end,
      move_camera = function(self)
        if self.enabled then
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
          camera_velocity.y = (push_camera.left - push_camera.right) * self.speed
          camera_velocity.x = (push_camera.up - push_camera.down) * self.speed
          self.position = self.position + camera_velocity
        end
      end,
      getHookNamespace = function(self)
        return 'zoba.HoverCam'
      end,
      register_hooks = function(self)
        local namespace = self:getHookNamespace()
        hook.Add("Tick", tostring(namespace) .. ".hook_Tick", (function()
          local _base_1 = self
          local _fn_0 = _base_1.hook_Tick
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)())
        hook.Add("CalcView", tostring(namespace) .. ".hook_CalcView", (function()
          local _base_1 = self
          local _fn_0 = _base_1.hook_CalcView
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)())
        return hook.Add("ShouldDrawLocalPlayer", tostring(namespace) .. ".hook_ShouldDrawLocalPlayer", (function()
          local _base_1 = self
          local _fn_0 = _base_1.hook_ShouldDrawLocalPlayer
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)())
      end,
      register_hook = function(self, method) end
    }
    _base_0.__index = _base_0
    local _class_0 = setmetatable({
      __init = function(self)
        self.enabled = false
        self.position = Vector(0, 0)
        self.speed = 10
        self.maxrange = Vector(1, 1, 1) * 10000
        self._active_hooks = { }
      end,
      __base = _base_0,
      __name = "HoverCam"
    }, {
      __index = _base_0,
      __call = function(cls, ...)
        local _self_0 = setmetatable({}, _base_0)
        cls.__init(_self_0, ...)
        return _self_0
      end
    })
    _base_0.__class = _class_0
    HoverCam = _class_0
  end
  local myCam = HoverCam()
  usermessage.Hook("startcam", (function()
    local _base_0 = myCam
    local _fn_0 = _base_0.enable
    return function(...)
      return _fn_0(_base_0, ...)
    end
  end)())
  usermessage.Hook("stopcam", (function()
    local _base_0 = myCam
    local _fn_0 = _base_0.disable
    return function(...)
      return _fn_0(_base_0, ...)
    end
  end)())
  return [[		--When the mouse is pressed...
		startFire = (mouseCode, aimVector) ->
			RunConsoleCommand('+attack') if mouseCode == 107
		hook.Add('GUIMousePressed', 'zoba.startFire', startFire)
		endFire = (mouseCode, aimVector) ->
			RunConsoleCommand('-attack') if mouseCode == 107
		hook.Add('GUIMouseReleased', 'zoba.endFire', endFire)
	]]
end
