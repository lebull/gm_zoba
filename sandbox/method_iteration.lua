local TestHook
do
  local _base_0 = {
    add = function(self, event_name, hook_name, func)
      print("Hook Registered:", event_name, hook_name, func)
      self.hooks[event_name] = func
    end,
    run_hooks = function(self, event_name)
      for name, func in pairs(self.hooks) do
        if name == event_name then
          func()
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
      return print("Callback Called:", tostring(self.test))
    end,
    register_hook = function(self, event_name, method, refresh)
      if refresh == nil then
        refresh = false
      end
      local _ = [[        --See if the method is in the hooked methods
        if refresh
            --If so, remove the hook
            nil
        else
            --Don't add the hook
            return nil]]
      local method_name = "hook_" .. tostring(event_name)
      local hook_name = tostring(self.__class.__name) .. "." .. tostring(event_name)
      return method()
    end,
    register_hooks = function(self)
      for x, y in pairs(self) do
        print(x, y)
      end
      return [[                event_name = string.sub(method_name, 6)
                @\register_hook(event_name, method)
        ]]
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      return print("Created")
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
return myFruit:register_hooks()
