local Fruit
do
  local _base_0 = {
    color = "",
    size = "",
    eat = function(self)
      return print("Om nom nom on a ", self.__name)
    end,
    hook_TestMyHook = function(self)
      return print("I will be a callback!")
    end,
    register_hooks = function(self)
      for i, v in ipairs(self) do
        print(i, v)
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "Fruit"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Fruit = _class_0
end
local myFruit = Fruit
