class TestHook
    new: =>
        @hooks = {}

    add: (event_name, hook_name, func) =>
        @hooks[event_name] = func
        print("Hook Registered:", event_name, hook_name, func)

    run_hooks: (event_name) =>
        for name, func in pairs(@hooks)
            if name == event_name
                nil


myHookTester = TestHook!

class GarryAid

    new: =>
        print("Created")
        @testvar = "No"

    hook_TestMyHook: =>
        print("Hook was run")
        print("Callback Called Correctly:", tostring(@testvar))

    register_hook: (event_name, method, refresh = false) =>
        --If there is a list of hooks somewhere in memory, we
        --should totally check against it.
        
        -- --See if the method is in the hooked methods
        -- if refresh
        --     --If so, remove the hook
        --     nil
        -- else
        --     --Don't add the hook
        --     return nil

        method_name = "hook_#{event_name}"
        hook_name = "#{@@.__name}.#{event_name}"
        myHookTester\add(event_name, hook_name, => method(self)!)
        
        --@_hooked_methods.add(method_name)

    register_hooks: =>
        --print x, y for x, y in pairs()
        for method_name, method in pairs(getmetatable(self))
            --print method_name, method, @
            if string.match(method_name, "^hook_")
                @\register_hook('TestMyHook', method)


myFruit = GarryAid!
--myFruit\register_hook('TestMyHook')
myFruit.testvar = "Yes"

myFruit\register_hooks!
--myHookTester\run_hooks('TestMyHook')
