local error_not_jailbreak = "The current gamemode is not jailbreak!"


function ulx.makeguard( calling_ply, target_ply )
	if GAMEMODE_NAME == "jailbreak" then
		target_ply:SetTeam(TEAM_GUARD);
		target_ply:KillSilent();
		target_ply:SendNotification("Forced to guards");
		ulx.fancyLogAdmin( calling_ply, "#A made #T a guard",  target_ply );
	else
		ULib.tsayError(calling_ply, error_not_jailbreak, true);
	end
end
local makeguard = ulx.command("Jailbreak", "ulx makeguard", ulx.makeguard, "!makeguard")
makeguard:defaultAccess( ULib.ACCESS_ADMIN )
makeguard:addParam{ type=ULib.cmds.PlayerArg }
makeguard:help( "Makes target a guard." )

function ulx.makeprisoner( calling_ply, target_ply )
	if GAMEMODE_NAME == "jailbreak" then
		target_ply:SetTeam(TEAM_PRISONER);
		target_ply:KillSilent();
		target_ply:SendNotification("Forced to prisoners");
		ulx.fancyLogAdmin( calling_ply, "#A made #T a prisoner",  target_ply );
	else
		ULib.tsayError(calling_ply, error_not_jailbreak, true);
	end
end
local makeprisoner = ulx.command("Jailbreak", "ulx makeprisoner", ulx.makeprisoner, "!makeprisoner" )
makeprisoner:defaultAccess( ULib.ACCESS_ADMIN )
makeprisoner:addParam{ type=ULib.cmds.PlayerArg }
makeprisoner:help( "Makes target a prisoner." )

function ulx.makespectator( calling_ply, target_ply )
	if GAMEMODE_NAME == "jailbreak" then
		target_ply:SetTeam(TEAM_SPECTATOR);
		target_ply:KillSilent();
		target_ply:SendNotification("Forced to spectators");
		ulx.fancyLogAdmin( calling_ply, "#A made #T a spectator",  target_ply );
	else
		ULib.tsayError(calling_ply, error_not_jailbreak, true);
	end
end
local makespectator = ulx.command("Jailbreak", "ulx makespectator", ulx.makespectator, {"!makespectator", "!makespec"} )
makespectator:defaultAccess( ULib.ACCESS_ADMIN )
makespectator:addParam{ type=ULib.cmds.PlayerArg }
makespectator:help( "Makes target a spectator." )


function ulx.makewarden( calling_ply, target_plys )
	local affected_plys = {}

	for i=1, #target_plys do
		local v = target_plys[ i ]

		if ulx.getExclusive( v, calling_ply ) then
			ULib.tsayError( calling_ply, ulx.getExclusive( v, calling_ply ), true )
		elseif not v:Alive() then
			ULib.tsayError( calling_ply, v:Nick() .. " is dead", true )
		elseif v:IsFrozen() then
			ULib.tsayError( calling_ply, v:Nick() .. " is frozen", true )
		else

		local warden=JB.TRANSMITTER:GetJBWarden()
		if IsValid(warden) then
		warden:RemoveWardenStatus();
		table.insert( affected_plys, warden )
		end
		if !v:Alive() or v:Team() ~= 2 then 
			v:SetTeam(TEAM_GUARD)
			v._jb_forceRespawn=true
			v:Spawn();
		end
		v:AddWardenStatus();
		table.insert( affected_plys, v )
	end
end

ulx.fancyLogAdmin( calling_ply, "#A forced warden #T", affected_plys )
end
local makewarden = ulx.command( "Jailbreak", "ulx makewarden", ulx.makewarden, {"!makewarden", "!warden"} )
makewarden:addParam{ type=ULib.cmds.PlayersArg }
makewarden:defaultAccess( ULib.ACCESS_ADMIN )
makewarden:help( "Makes the target the warden." )



local warden = nil
hook.Add("JailBreakClaimWarden", "teleportguardswarden", function(ply)
	warden = ply
end)
hook.Add("JailBreakRoundEnd", "teleportguardsforgetwarden", function()
	warden = nil
end)

function ulx.teleportguards(calling_ply)
	if (warden == nil) or (warden:Team() ~= TEAM_GUARD) or (!warden:IsPlayer()) then
		calling_ply:ChatPrint("There is no warden!")
	end
	for k,v in pairs(team.GetPlayers(TEAM_GUARD)) do
		v:SetPos(warden:GetPos())
	end
	ulx.fancyLogAdmin(calling_ply, "#A has teleported all guards to the warden")
end
local teleguards = ulx.command(category, "ulx teleportguards", ulx.teleportguards, {"!tpg", "!teleportguards"} )
teleguards:defaultAccess(ULib.ACCESS_ADMIN)
teleguards:help("This teleports all of the guards to the warden!")

