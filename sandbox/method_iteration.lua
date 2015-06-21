local TestHook
do
  local _base_0 = {
    add = function(self, event_name, hook_name, func)
      func()
      self.hooks[event_name] = func
      return print("Hook Registered:", event_name, hook_name, func)
    end,
    run_hooks = function(self, event_name)
      for name, func in pairs(self.hooks) do
        if name == event_name then
          func(badvar)
        end
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.hooks = { }
    end,
    __base = _base_0,
    __name = "TestHook"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  TestHook = _class_0
end
local myHookTester = TestHook()
local GarryAid
do
  local _base_0 = {
    hook_TestMyHook = function(self)
      print("Hook was run")
      return print("Callback Called Correctly:", tostring(self.testvar))
    end,
    register_hook = function(self, event_name, method, refresh)
      if refresh == nil then
        refresh = false
      end
      local method_name = "hook_" .. tostring(event_name)
      local hook_name = tostring(self.__class.__name) .. "." .. tostring(event_name)
      return myHookTester:add(event_name, hook_name, method)
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
      print("Created")
      self.testvar = "No"
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
end
local myFruit = GarryAid()
myFruit.testvar = "Yes"
return myFruit:register_hooks()
