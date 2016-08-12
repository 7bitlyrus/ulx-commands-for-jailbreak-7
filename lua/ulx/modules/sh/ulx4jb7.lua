local error_not_jailbreak = "The current gamemode is not jailbreak!"


function ulx.guardban( calling_ply, target_ply, unban )
	if GAMEMODE_NAME == "jailbreak" then
		if unban then
			if target_ply._ulx4jb7_guardbanned then
				target_ply._ulx4jb7_guardbanned=false
				ulx.fancyLogAdmin( calling_ply, "#A unbanned #T from guards",  target_ply );
			else
				return
			end
		else
			target_ply._ulx4jb7_guardbanned=true
			ulx.fancyLogAdmin( calling_ply, "#A banned #T from guards",  target_ply );
			if target_ply:Team() == TEAM_GUARD then
				target_ply:SetTeam(TEAM_PRISONER);
				target_ply:KillSilent();
				target_ply:SendNotification("Forced to prisoners");
			end
		end
	else
		ULib.tsayError(calling_ply, error_not_jailbreak, true);
	end
end
local guardban = ulx.command("Jailbreak", "ulx guardban", ulx.guardban, "!guardban" )
guardban:defaultAccess( ULib.ACCESS_ADMIN )
guardban:addParam{ type=ULib.cmds.PlayerArg }
guardban:addParam{ type=ULib.cmds.BoolArg, invisible=true }
guardban:setOpposite( "ulx unguardban", { _, _, true }, {"!unguardban", "!guardunban"} )
guardban:help( "Bans target from guards." )

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

function ulx.revive( calling_ply, target_plys )
	for k,v in pairs( target_plys ) do
		if GAMEMODE_NAME == "jailbreak" then
			v._jb_forceRespawn=true
		end
		v:Spawn()
	end
	ulx.fancyLogAdmin( calling_ply, "#A revived #T",  target_plys )
end
local revive = ulx.command("Jailbreak", "ulx revive", ulx.revive, "!revive")
revive:defaultAccess( ULib.ACCESS_ADMIN )
revive:addParam{ type=ULib.cmds.PlayersArg }
revive:help( "Revives target(s)." )



hook.Add( "JailBreakPlayerSwitchTeam", "ulx4jb7_JailBreakPlayerSwitchTeam", function(player, team)
	if player._ulx4jb7_guardbanned and team == TEAM_GUARD then
		player:SetTeam(TEAM_PRISONER);
		player:KillSilent();
		player:SendNotification("Forced to prisoners");
		ULib.tsayError(player, "You are banned from joining guards!")
	end
end )