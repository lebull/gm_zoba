--https\//github.com/icedream/gmod-disguiser/blob/master/lua/weapons/disguiser/cl_3rdperson.lua

include( "shared.lua" )

--Global Variables
CAMERA_ON = false
CAMERA_POSITION = Vector(0, 0, 0)
CAMERA_SPEED = 10
CAMERA_MAXRANGE = Vector(10000, 10000, 10000)

if CLIENT

	--Move the camera based on mouse position
	moveCamera = ->
		if CAMERA_ON
			--Move camera based on mouse pos
			mousey, mousex = gui.MousePos()

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
			camera_velocity.y = (push_camera.left - push_camera.right)*CAMERA_SPEED
			camera_velocity.x = (push_camera.up - push_camera.down)*CAMERA_SPEED

			CAMERA_POSITION = CAMERA_POSITION + camera_velocity

	--Just a quick test to see if the mouse is in the window.
	isMouseInWindow = -> Vector(gui.MousePos!)\WithinAABox(Vector(0, 0), Vector(ScrW!, ScrH!))

	--Keep the mouse within the window.
	keepMouseInWindow = ->
		if system.HasFocus!
			new_pos_x = math.Clamp(gui.MouseX!, 0, ScrW! - 1)
			new_pos_y = math.Clamp(gui.MouseY!, 0, ScrH! - 1)
			gui.SetMousePos(new_pos_x, new_pos_y)

	--Figure out where the camera needs to be
	calcCameraView = (ply, pos, angles, fov) ->
	  if CAMERA_ON
			--keepMouseInWindow!
			moveCamera! if system.HasFocus! and isMouseInWindow!

			view = 
				origin: CAMERA_POSITION
				angles: -Angle(-70, 0, 0)
				fov:	  fov

			return view

	hook.Add('CalcView', 'zoba.CalcCameraView', calcCameraView)
	

	--When the mouse is pressed...
	startFire = (mouseCode, aimVector) ->
		RunConsoleCommand('+attack') if mouseCode == 107
	hook.Add('GUIMousePressed', 'zoba.startFire', startFire)
	endFire = (mouseCode, aimVector) ->
		RunConsoleCommand('-attack') if mouseCode == 107
	hook.Add('GUIMouseReleased', 'zoba.endFire', endFire)

	--Set where the player needs to look.
	setAimPos = ->
	  if CAMERA_ON

			--Create a ray trace to determine where in the world the user's cursor is pointing.
			trace_params = 
				start: CAMERA_POSITION
				endpos: CAMERA_POSITION + gui.ScreenToVector(gui.MousePos()) * 10000
				filter:  (ent) -> ent\GetClass() == "worldspawn"

			trace = util.TraceLine(trace_params).HitPos

			--debugoverlay.Cross(ply\GetPos(), 100, 0)
			--debugoverlay.Line(ply\GetPos(), trace, 0.1, Color(0, 255, 0))

			--Force the player's character to look at this spot.
			
			LocalPlayer!\SetEyeAngles((trace - LocalPlayer!\GetPos!)\Angle!)

	hook.Add("Tick", "zoba.setAimPos", setAimPos)

	startCam = ->
		gui.EnableScreenClicker(true)
		CAMERA_POSITION = LocalPlayer()\GetPos() + Vector(-200, 0, 500)
		CAMERA_ON = true
		print("Start: ", CAMERA_ON)

	usermessage.Hook("startcam", startCam)

	stopCam = ->
		print "Stop"
		gui.EnableScreenClicker(false)
		CAMERA_ON = false

	usermessage.Hook("stopcam", stopCam)

	hook.Add( "ShouldDrawLocalPlayer", "MyShouldDrawLocalPlayer", (ply) -> CAMERA_ON)

	--TODO\
	-- Adjust the height of the camera with the mouse wheel.
	--	We can do this logorithmically, and set the initial alt based on the
	--	user's spawn z position.
	-- Keep mouse bound to the game window.
	-- Lock camera to world boundries
	-- Should players be able to aim at the ground?