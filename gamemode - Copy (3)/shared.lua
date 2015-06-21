DeriveGamemode("sandbox")
local calcSetupMove
calcSetupMove = function(ply, mv)
  local _ = [[if not CAMERA_ON
		return]]
  if mv:GetVelocity() ~= nil and mv:GetVelocity() ~= Vector(0, 0, 0) then
    local new_angle = Angle(0, 0, 0)
    mv:SetMoveAngles(new_angle)
  end
  return mv
end
hook.Add("SetupMove", "zoba.calcSetupMove", calcSetupMove)
if SERVER then
  local startPlayerCamera
  startPlayerCamera = function(ply)
    umsg.Start("startcam", ply)
    return umsg.End()
  end
  local playerSpawn
  playerSpawn = function(ply)
    return startPlayerCamera(ply)
  end
  hook.Add("PlayerSpawn", "zoba.playerSpawn", playerSpawn)
  local stopPlayerCamera
  stopPlayerCamera = function(ply)
    umsg.Start("stopcam", ply)
    return umsg.End()
  end
  local playerDeath
  playerDeath = function(ply)
    return stopPlayerCamera(ply)
  end
  hook.Add("PlayerDeath", "zoba.playerDeath", playerDeath)
  return concommand.Add("zoba_start", playerSpawn)
end
