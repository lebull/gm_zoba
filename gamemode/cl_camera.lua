--https\//github.com/icedream/gmod-disguiser/blob/master/lua/weapons/disguiser/cl_3rdperson.lua

if CLIENT then

	local DERP_CAMERA_HEIGHT = 300

	local CAMERA_ENABLED	= false
	local CAMERA_POSITION 	= Vector(0, 0)
	local CAMERA_SPEED 		= 4
	local CAMERA_MAXRANGE 	= Vector(1, 1, 1)*10000 --TODO: Calc from map boundries
	local CAMERA_LOCKED 	= false

	local AIM_TARGET		= nil

	local function enable_camera()
		CAMERA_ENABLED  = true
		CAMERA_POSITION = LocalPlayer():GetPos() + Vector(-200, 0, DERP_CAMERA_HEIGHT)
		gui.EnableScreenClicker(true)
	end

	local function disable_camera()
		gui.EnableScreenClicker(false)
		CAMERA_ENABLED = false
	end

	local function setAimPosToMouse()

		trace_params 		= {}
		trace_params.start 	= CAMERA_POSITION
		trace_params.endpos = CAMERA_POSITION + gui.ScreenToVector(gui.MousePos()) * 10000
		trace_params.filter = function (ent) 
						return (ent:GetClass() == "worldspawn")
					end
		
		trace = util.TraceLine(trace_params).HitPos

		target_angle = (trace - LocalPlayer():GetPos()):Angle()
		target_angle.p = 0

		LocalPlayer():SetEyeAngles(target_angle)
	end

	local function tick()
		if CAMERA_ENABLED then
			if AIM_TARGET == nil then
				setAimPosToMouse()
			end
		end
	end
	
	hook.Add('Tick', 'zoba.camera.tick', tick)

	local function pushCameraWithMouse()
		if CAMERA_ENABLED then
			--Move the camera based on mouse position

			mousex = gui.MouseX()
			mousey = gui.MouseY()

			move_strip_size = {}
			move_strip_size.width  = ScrW() * 0.05 -- if the mouse w is in the left 5%
			move_strip_size.height = ScrH() * 0.05
			
			push_camera 		= {}
			push_camera.left 	= math.Clamp((-mousex / move_strip_size.width) + 1, 0, 1)
			push_camera.right	= math.Clamp(((mousex - (ScrW() - move_strip_size.width)) / move_strip_size.width) + 1, 0, 1)
			push_camera.up		= math.Clamp((-mousey / move_strip_size.height) + 1, 0, 1)
			push_camera.down 	= math.Clamp(((mousey - (ScrH() - move_strip_size.height)) / move_strip_size.height) + 1, 0, 1)

			camera_velocity   = Vector()
			camera_velocity.y = (push_camera.left - push_camera.right) * CAMERA_SPEED
			camera_velocity.x = (push_camera.up - push_camera.down) * CAMERA_SPEED

			CAMERA_POSITION = CAMERA_POSITION + camera_velocity
		end
	end

	local function calcView(ply, pos, angles, fov)
		if CAMERA_ENABLED then
			--keepMouseInWindow!
			--Just a quick test to see if the mouse is in the window.

			if CAMERA_LOCKED then
				CAMERA_POSITION = Vector(
					LocalPlayer():GetPos().x,
					LocalPlayer():GetPos().y,
					DERP_CAMERA_HEIGHT
				)
			else
				if system.HasFocus() 
					and Vector(gui.MousePos()):WithinAABox(Vector(0, 0), Vector(ScrW(), ScrH()))
					then --Mouse is in the window 
					pushCameraWithMouse() 
				end

			end

			view 		= {}
			view.origin = CAMERA_POSITION
			view.angles = -Angle(-70, 0, 0)
			view.fov 	= fov

			return view
		else
			return nil
		end
	end

	hook.Add('CalcView', 'zoba.camera.calc_view', calcView)

	local function shouldDrawLocalPlayer(ply)
		return CAMERA_ENABLED
	end
	hook.Add('ShouldDrawLocalPlayer', 'zoba.camera.shouldDrawLocalPlayer', shouldDrawLocalPlayer)

	--When the mouse is pressed...
	function startFire(mouseCode, aimVector)
		if mouseCode == 107 then
			RunConsoleCommand('+attack')
		end
	end
	hook.Add('GUIMousePressed', 'zoba.startFire', startFire)

	function endFire (mouseCode, aimVector)
		if mouseCode == 107 then 
			RunConsoleCommand('-attack')
		end
	end
	hook.Add('GUIMouseReleased', 'zoba.endFire', endFire)

	usermessage.Hook("startcam", enable_camera)
	usermessage.Hook("stopcam", disable_camera)
end