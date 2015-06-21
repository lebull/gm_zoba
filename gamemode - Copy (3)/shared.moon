--local CMoveData = FindMetaTable( "CMoveData" )

DeriveGamemode( "sandbox" )

calcSetupMove = (ply, mv) ->

	[[if not CAMERA_ON
		return]]

	if mv\GetVelocity! != nil and mv\GetVelocity! != Vector(0, 0, 0)
		new_angle = Angle(0, 0, 0)
		mv\SetMoveAngles(new_angle)
	return mv

hook.Add("SetupMove", "zoba.calcSetupMove", calcSetupMove)

if SERVER
	startPlayerCamera = (ply) ->
		umsg.Start("startcam", ply)
		umsg.End()

	playerSpawn = (ply) ->
		startPlayerCamera(ply)

	hook.Add("PlayerSpawn", "zoba.playerSpawn", playerSpawn)

	stopPlayerCamera = (ply) ->
		umsg.Start("stopcam", ply)
		umsg.End()

	playerDeath = (ply) ->
		stopPlayerCamera(ply)

	hook.Add("PlayerDeath", "zoba.playerDeath", playerDeath)

	concommand.Add( "zoba_start", playerSpawn)
	--concommand.Add( "zoba_stop", stopCam)



