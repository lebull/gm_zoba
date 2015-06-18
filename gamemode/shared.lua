local calcSetupMove
calcSetupMove = function(ply, mv)
  if not CAMERA_ON then
    return 
  end
  if mv:GetVelocity() ~= nil and mv:GetVelocity() ~= Vector(0, 0, 0) then
    mv:SetMoveAngles(Angle(0, 0, 0))
  end
  return mv
end
hook.Add("SetupMove", "zoba.calcSetupMove", calcSetupMove)
if SERVER then
  local startPlayerCamera = ply(function()
    umsg.Start("startcam", pl)
    return umsg.End()
  end)
  local playerSpawn = ply(function()
    return startPlayerCamera(ply)
  end)
  hook.Add("PlayerSpawn", "zoba.playerSpawn", playerSpawn)
  local stopPlayerCamera = ply(function()
    umsg.Start("stopcam", ply)
    return umsg.End()
  end)
  local playerDeath
  playerDeath = function(ply)
    return stopPlayerCamera(ply)
  end
  return hook.Add("PlayerDeath", "zoba.playerDeath", playerDeath)
end
