class TestHook
    new: =>
        @hooks = {}

    add: (event_name, hook_name, func) =>
        print("Hook Registered:", event_name, hook_name, func)
        @hooks[event_name] = func

    run_hooks: (event_name) =>
        for name, func in pairs(@hooks)
            if name == event_name
                func!

myHookTester = TestHook!


class GarryAid

    hook_TestMyHook: =>
        print("Callback Called:", tostring(@))

    register_hook: (event_name, method, refresh = false) =>
        --If there is a list of hooks somewhere in memory, we
        --should totally check against it.
        [[
        --See if the method is in the hooked methods
        if refresh
            --If so, remove the hook
            nil
        else
            --Don't add the hook
            return nil]]

        method_name = "hook_#{event_name}"
        hook_name = "#{@@.__name}.#{event_name}"
        myHookTester\add(event_name, hook_name, method)
        --@_hooked_methods.add(method_name)

    register_hooks: =>

        [print(key, value) for key, value in pairs(@@.__base)]
        for method_name, method in pairs(@@.__base)
            if string.match(method_name, "^hook_")
                event_name = string.sub(method_name, 6)
                --@\register_hook(event_name, method)


myFruit = GarryAid!
--myFruit\register_hook('TestMyHook')
myFruit\register_hooks!
myHookTester\run_hooks('TestMyHook')