--https\//github.com/icedream/gmod-disguiser/blob/master/lua/weapons/disguiser/cl_3rdperson.lua

if CLIENT

	include( "shared.lua" )


	class HoverCam
		new: =>
			@enabled = false
			@position = Vector(0, 0)
			@speed = 10
			@maxrange = Vector(1, 1, 1)*10000
			@_active_hooks = {}

		enable: =>
			@enabled = true
			@position = LocalPlayer()\GetPos() + Vector(-200, 0, 500)
			gui.EnableScreenClicker(true)
			@register_hooks!

		disable: => 
			gui.EnableScreenClicker(false)
			@enabled = false

		hook_Tick: =>
			if @enabled
				--Create a ray trace to determine where in the world the user's cursor is pointing.
				trace_params = 
					start: @position
					endpos: @position + gui.ScreenToVector(gui.MousePos()) * 10000
					filter:  (ent) -> ent\GetClass() == "worldspawn"
				trace = util.TraceLine(trace_params).HitPos
				LocalPlayer!\SetEyeAngles((trace - LocalPlayer!\GetPos!)\Angle!)

		hook_CalcView: (ply, pos, angles, fov) =>
			if @enabled
				--keepMouseInWindow!
				--Just a quick test to see if the mouse is in the window.
				isMouseInWindow = -> Vector(gui.MousePos!)\WithinAABox(Vector(0, 0), Vector(ScrW!, ScrH!))

				@move_camera! if system.HasFocus! and isMouseInWindow!

				view = 
					origin: @position
					angles: -Angle(-70, 0, 0)
					fov:	  fov

				return view
			else
				return nil

		hook_ShouldDrawLocalPlayer: (ply) =>
			return @enabled

		move_camera: =>
			if @enabled
				--Move the camera based on mouse position
				mousey, mousex = gui.MousePos!

				move_strip_size = 
				-- if the mouse w is in the left 5%
					width:  ScrW() * 0.05
					height: ScrH() * 0.05

				push_camera = 
					left: 	math.Clamp((-mousey / move_strip_size.width) + 1, 0, 1)
					right: 	math.Clamp(((mousey - (ScrW() - move_strip_size.width)) / move_strip_size.width) + 1, 0, 1)
					up: 		math.Clamp((-mousex / move_strip_size.height) + 1, 0, 1)
					down: 	math.Clamp(((mousex - (ScrH() - move_strip_size.height)) / move_strip_size.height) + 1, 0, 1)

				camera_velocity = Vector!
				camera_velocity.y = (push_camera.left - push_camera.right)*@speed
				camera_velocity.x = (push_camera.up - push_camera.down)*@speed

				@position += camera_velocity

		getHookNamespace: => 'zoba.HoverCam'

		register_hooks: =>
			namespace = @getHookNamespace!
			hook.Add("Tick", "#{namespace}.hook_Tick", @\hook_Tick)
			hook.Add("CalcView", "#{namespace}.hook_CalcView", @\hook_CalcView)
			hook.Add( "ShouldDrawLocalPlayer", "#{namespace}.hook_ShouldDrawLocalPlayer", @\hook_ShouldDrawLocalPlayer)

			--Unregister hooks
			--loop through methods
				--register_hook(method)

		register_hook: (method) =>
			--assert method starts with hook
			--hook = method - 'hook_'
			--name = namespace + hook
			--call hook.Add(...)
			--Append {hook, name} to @active_hooks

			--Handle client/server/shared hooks

	myCam = HoverCam!
	--myCam\enable!
	usermessage.Hook("startcam", myCam\enable)
	usermessage.Hook("stopcam", myCam\disable)
	--myCam\enable

	[[
		--When the mouse is pressed...
		startFire = (mouseCode, aimVector) ->
			RunConsoleCommand('+attack') if mouseCode == 107
		hook.Add('GUIMousePressed', 'zoba.startFire', startFire)
		endFire = (mouseCode, aimVector) ->
			RunConsoleCommand('-attack') if mouseCode == 107
		hook.Add('GUIMouseReleased', 'zoba.endFire', endFire)
	]]

	--TODO\
	-- Adjust the height of the camera with the mouse wheel.
	--	We can do this logorithmically, and set the initial alt based on the
	--	user's spawn z position.
	-- Keep mouse bound to the game window.
	-- Lock camera to world boundries
	-- Should players be able to aim at the ground?