local error_not_jailbreak = "The current gamemode is not jailbreak!"

hook.Add("PlayerDeath", "showdeathCheck", function(ply)
	ply:SetNWVector("lastDeathPos", ply:GetPos())
end)

function ulx.showdeath(calling_ply,target_ply)
	if target_ply:GetNWVector("lastDeathPos") == nil then Ulib.tsayError(target_ply:Name(), " did not die yet!") return end
	if calling_ply:Alive() then
		local prevPos = calling_ply:GetPos()
		calling_ply:SetPos(target_ply:GetNWVector("lastDeathPos"))
		calling_ply:GodEnable()
		timer.Simple(3, function()
			calling_ply:SetPos(prevPos)
			calling_ply:GodDisable()
		end)
	else
		calling_ply:SetPos(target_ply:GetNWVector("lastDeathPos"))
	end
	ulx.fancyLogAdmin(calling_ply, "#A has teleported to #T's death position", target_ply)
end
local showdeath = ulx.command( "Jailbreak", "ulx showdeath", ulx.showdeath, "!showdeath")
showdeath:addParam{type=ULib.cmds.PlayerArg}
showdeath:defaultAccess(ULib.ACCESS_ADMIN)
showdeath:help("Teleports you to the position where the target died")
