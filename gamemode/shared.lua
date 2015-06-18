DeriveGamemode( "sandbox" )

--local CMoveData = FindMetaTable( "CMoveData" )
function calcSetupMove(ply, mv)
	
	if(CAMERA_ON == false) then
		return
	end

	--if(mv:KeyDown(IN_MOVELEFT)) then
	if mv:GetVelocity() != nil and mv:GetVelocity() != Vector(0, 0, 0)then
		---mv:GetAngles().y
		new_angle = Angle(0, 0, 0)
		mv:SetMoveAngles(new_angle)
	end
	return mv
end
hook.Add("SetupMove", "zoba.calcSetupMove", calcSetupMove)


if SERVER then
	local function startPlayerCamera(ply)
		umsg.Start("startcam", pl)
		umsg.End()
	end

	local function stopPlayerCamera(ply)
		umsg.Start("stopcam", ply)
		umsg.End()
	end

	local function playerSpawn( ply )
		startPlayerCamera(ply)
	end
	hook.Add("PlayerSpawn", "zoba.playerSpawn", playerSpawn)

	function GM:PlayerDeath( ply )

		stopPlayerCamera(ply)
	end
end


--TODO: Make sure 