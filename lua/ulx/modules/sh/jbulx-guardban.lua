local error_not_jailbreak = "The current gamemode is not jailbreak!"


function ulx.guardban( calling_ply, target_ply, unban )
	if GAMEMODE_NAME == "jailbreak" then
		if unban then
			if tonumber(target_ply:GetPData( "guardbanned", 0 )) > os.time() then
				target_ply:RemovePData( "guardbanned" )
				target_ply:RemovePData( "guardbanned_on" )
				target_ply:RemovePData( "guardbanned_by" )
				ulx.fancyLogAdmin( calling_ply, "#A unbanned #T from guards",  target_ply );
			else
				ULib.tsayError(calling_ply, "That player is not guardbanned!", true);
			end
		else
			target_ply:SetPData( "guardbanned", os.time()+57600 )
			target_ply:SetPData( "guardbanned_on", os.time() )
			target_ply:SetPData( "guardbanned_by", string.format( "%s (%s)", calling_ply:Name(), calling_ply:SteamID()))
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
guardban:help( "Bans target from guards temporarily." )


function ulx.guardbaninfo( calling_ply, target_ply)
	if GAMEMODE_NAME == "jailbreak" then
		if tonumber(target_ply:GetPData( "guardbanned", 0 )) > os.time() then
			ULib.tsay( calling_ply, target_ply:Name() .. " was guardbanned by " .. target_ply:GetPData( "guardbanned_by", "an unknown person" ) .. ".")
			ULib.tsay( calling_ply, "The ban was issued about " .. math.Round((os.time()-target_ply:GetPData( "guardbanned_on", 0 ))/60) .. " minutes ago and will expire in about " .. math.Round((target_ply:GetPData( "guardbanned", 0 )-os.time())/60) .. " minutes.")
		else 
			ULib.tsayError(calling_ply, target_ply:Name() .. " is not guardbanned!")
		end
	else
		ULib.tsayError(calling_ply, error_not_jailbreak, true);
	end
end
local guardbaninfo = ulx.command("Jailbreak", "ulx guardbaninfo", ulx.guardbaninfo, {"!guardbaninfo", "!gbinfo"}, true )
guardbaninfo:defaultAccess( ULib.ACCESS_ADMIN )
guardbaninfo:addParam{ type=ULib.cmds.PlayerArg }
guardbaninfo:help( "Prints info about a guardban." )



hook.Add( "JailBreakPlayerSwitchTeam", "jbulx_JailBreakPlayerSwitchTeam", function(player, team)
	if tonumber(player:GetPData( "guardbanned", 0 )) > os.time() and team == TEAM_GUARD then
		player:SetTeam(TEAM_PRISONER);
		player:KillSilent();
		player:SendNotification("Forced to prisoners");
		ULib.tsayError(player, "You are banned from joining guards! You will be unbanned in about " .. math.Round((player:GetPData( "guardbanned", 0 )-os.time())/60) .. " minutes.")
		ulx.fancyLogAdmin( nil, true,  "#T attemped to join guards while guardbanned.", player)
	end
end )