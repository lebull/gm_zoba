local GarryAidManager
do
  local _base_0 = { }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "GarryAidManager"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  GarryAidManager = _class_0
end
local GarryAid
do
  local _base_0 = {
    register_hook = function(self, event_name, method, refresh)
      if refresh == nil then
        refresh = false
      end
      print("Hook Added:", event_name, method)
      local method_name = "hook_" .. tostring(event_name)
      local hook_name = tostring(self.__class.__name) .. "." .. tostring(event_name)
      return hook.Add(event_name, hook_name, function(...)
        return method(self, ...)
      end)
    end,
    register_hooks = function(self)
      for method_name, method in pairs(getmetatable(self)) do
        if string.match(method_name, "^hook_") then
          self:register_hook('TestMyHook', method)
        end
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      return self:register_hooks()
    end,
    __base = _base_0,
    __name = "GarryAid"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  GarryAid = _class_0
  return _class_0
end
