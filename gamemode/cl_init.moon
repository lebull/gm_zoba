[[
/**
 *	https://github.com/icedream/gmod-disguiser/blob/master/lua/weapons/disguiser/cl_3rdperson.lua
 *
 *	TODO:
 *
 *
 *	Fire weapon when in camera
 *	Keep mouse bound to the game window.
 *	Lock camera to world boundries
 */]]

include( "shared.lua" )

if CLIENT

	--Global Variables
	export CAMERA_POSITION = Vector(0, 0, 0)
	export CAMERA_SPEED = 10
	export CAMERA_ON = false
	export CAMERA_MAXRANGE = Vector(10000, 10000, 10000)
		


	--Move the camera based on mouse position
	--Clean this feek up
	pushCamera = ->
		return if not CAMERA_ON

		--Move camera based on mouse pos
		
		mousey, mousex = gui.MousePos!

		-- if the mouse w is in the left 5%
		horizontal_move_width = ScrW! * 0.05
		vertical_move_width = ScrH! * 0.05

		push_camera = 
				-- Ok, lets take the width.  If mouse is on px#0, then camera_velocity.x = -1.  If it's at px#<horizontal_move_width>, then its 0.
				left: 	math.Clamp((-mousey / horizontal_move_width) + 1, 0, 1)
				--If it's at ScrW! - horizontal_move_width, camera.velocity = 0.  If it's at ScrW!, camera_velocity.x = 1.
				right: 	math.Clamp(((mousey - (ScrW! - horizontal_move_width)) / horizontal_move_width) + 1, 0, 1)
				up: 	math.Clamp((-mousex / vertical_move_width) + 1, 0, 1)
				down: 	math.Clamp(((mousex - (ScrH! - vertical_move_width)) / vertical_move_width) + 1, 0, 1)

		camera_velocity = Vector!
		camera_velocity.y = (push_camera.left - push_camera.right)*CAMERA_SPEED
		camera_velocity.x = (push_camera.up - push_camera.down)*CAMERA_SPEED

		CAMERA_POSITION += camera_velocity

	--Just a quick test to see if the mouse is in the window.
	isMouseInWindow = ->
		return false if not (0 <= gui.MouseX! and gui.MouseX! <= ScrW!)
		return false if not (0 <= gui.MouseY! and gui.MouseY! <= ScrH!)
		return true

	--Figure out where the camera needs to be
	calcOverheadView = (ply, pos, angles, fov) ->
		return if not CAMERA_ON

		pushCamera! if system.HasFocus! and isMouseInWindow!

		view = 
			angles: -Angle(-70, 0, 0),
			origin: CAMERA_POSITION,
			fov: fov

		return view
	hook.Add("CalcView", "zoba.calcOverheadView", calcOverheadView)

	fireOnClick = (mouseCode, aimVector) -> LocalPlayer!\Fire! if mouseCode == 107
	hook.Add("GUIMousePressed","zoba.lookToFire",fireOnClick)
	--hook_GUIMousePressed_fireOnClick

	--Set where the player needs to look.
	setAimPos = ->	
		return if not CAMERA_ON

		ply = LocalPlayer!

		--Create a ray trace to determine where in the world the user's cursor is pointing.
		trace_params = 
			start: 	CAMERA_POSITION
			endpos: CAMERA_POSITION + gui.ScreenToVector(gui.MousePos!) * 10000
			filter: ent -> ent\GetClass! == "worldspawn"

		trace = util.TraceLine(trace_params).HitPos
		--debugoverlay.Cross(ply:GetPos!, 100, 0)
		--debugoverlay.Line(ply:GetPos!, trace, 0.1, Color(0, 255, 0))

		--Force the player's character to look at this spot.
		ply\SetEyeAngles((trace - ply\GetPos!)\Angle!)

	hook.Add("Tick", "zoba.setAimPos", setAimPos)

	--TODO:  Adjust the height of the camera with the mouse wheel.
	--	We can do this logorithmically, and set the initial alt based on the
	--	user's spawn z position.
	adjustCameraHeight = ->
		nil

	startCam = ->
		gui.EnableScreenClicker(true)
		CAMERA_POSITION = LocalPlayer!\GetPos! + Vector(-200, 0, 500)
		CAMERA_ON = true

	usermessage.Hook("startcam", startCam)

	stopCam = ->
		print "Stop"
		gui.EnableScreenClicker(false)
		CAMERA_ON = false

	usermessage.Hook("stopcam", stopCam)

	--Draw the local player if the camera is on.
	hook.Add( "ShouldDrawLocalPlayer", "zoba.ShouldDrawLocalPlayer",  ply -> CAMERA_ON)