local error_not_jailbreak = "The current gamemode is not jailbreak!"
local CATEGORY_NAME = "Jailbreak"

function ulx.guardban(calling_ply,target_ply,banlength,unban)
	if GAMEMODE_NAME != "jailbreak" then ULib.tsayError(calling_ply,error_not_jailbreak,true) else
		if banlength == 0 then
			if unban then
				if tonumber(target_ply:GetPData("guardbanned",0)) > os.time() or tobool(target_ply:GetPData("guardbanned_perm",false)) then
					target_ply:RemovePData("guardbanned")
					target_ply:RemovePData("guardbanned_perm")
					target_ply:RemovePData("guardbanned_on")
					target_ply:RemovePData("guardbanned_by")
					ulx.fancyLogAdmin(calling_ply,"#A unbanned #T from guards",target_ply)
				else
					ULib.tsayError(calling_ply,"That player is not guardbanned!",true)
				end
			else
				target_ply:SetPData("guardbanned_perm",true)
				target_ply:SetPData("guardbanned_on",os.time())
				target_ply:SetPData("guardbanned_by",string.format("%s (%s)",calling_ply:Name(),calling_ply:SteamID()))
				ulx.fancyLogAdmin(calling_ply,"#A banned #T from guards permanently",target_ply)
			end
		else
			target_ply:SetPData("guardbanned",os.time()+banlength*60)
			target_ply:SetPData("guardbanned_on",os.time())
			target_ply:SetPData("guardbanned_by",string.format("%s (%s)",calling_ply:Name(),calling_ply:SteamID()))
			ulx.fancyLogAdmin(calling_ply,"#A banned #T from guards for "..banlength.." minutes",target_ply)
		end
		if not unban and target_ply:Team() == TEAM_GUARD then
			target_ply:SetTeam(TEAM_PRISONER)
			target_ply:KillSilent()
			target_ply:SendNotification("Forced to prisoners")
		end
	end
end
local guardban = ulx.command(CATEGORY_NAME,"ulx guardban",ulx.guardban,{"!guardban","!gb","!banguard"})
guardban:defaultAccess(ULib.ACCESS_ADMIN)
guardban:addParam{type=ULib.cmds.PlayerArg}
guardban:addParam{type=ULib.cmds.NumArg,min=0,default=960,hint="ban length, 0 for permanent",ULib.cmds.optional}
guardban:addParam{type=ULib.cmds.BoolArg,invisible=true}
guardban:setOpposite("ulx unguardban",{_,_,0,true},{"!unguardban","!guardunban","!ungb","!unbanguard"})
guardban:help("Bans target from guards.")

function ulx.wardenban(calling_ply,target_ply,banlength,unban)
	if GAMEMODE_NAME != "jailbreak" then ULib.tsayError(calling_ply,error_not_jailbreak,true) else
		if banlength == 0 then
			if unban then
				if tonumber(target_ply:GetPData("wardenbanned",0)) > os.time() or tobool(target_ply:GetPData("wardenbanned_perm",false)) then
					target_ply:RemovePData("wardenbanned")
					target_ply:RemovePData("wardenbanned_perm")
					target_ply:RemovePData("wardenbanned_on")
					target_ply:RemovePData("wardenbanned_by")
					ulx.fancyLogAdmin(calling_ply,"#A unbanned #T from warden",target_ply)
				else
					ULib.tsayError(calling_ply,"That player is not wardenbanned!",true)
				end
			else
				target_ply:SetPData("wardenbanned_perm",true)
				target_ply:SetPData("wardenbanned_on",os.time())
				target_ply:SetPData("wardenbanned_by",string.format("%s (%s)",calling_ply:Name(),calling_ply:SteamID()))
				ulx.fancyLogAdmin(calling_ply,"#A banned #T from warden permanently",target_ply)
			end
		else
			target_ply:SetPData("wardenbanned",os.time()+banlength*60)
			target_ply:SetPData("wardenbanned_on",os.time())
			target_ply:SetPData("wardenbanned_by",string.format("%s (%s)",calling_ply:Name(),calling_ply:SteamID()))
			ulx.fancyLogAdmin(calling_ply,"#A banned #T from warden for "..banlength.." minutes",target_ply)
		end
		target_ply:RemoveWardenStatus()
	end
end
local wardenban = ulx.command(CATEGORY_NAME,"ulx wardenban",ulx.wardenban,{"!wardenban","!wb","!banwarden"})
wardenban:defaultAccess(ULib.ACCESS_ADMIN)
wardenban:addParam{type=ULib.cmds.PlayerArg}
wardenban:addParam{type=ULib.cmds.NumArg,min=0,default=960,hint="ban length, 0 for permanent",ULib.cmds.optional}
wardenban:addParam{type=ULib.cmds.BoolArg,invisible=true}
wardenban:setOpposite("ulx unwardenban",{_,_,0,true},{"!unwardenban","!wardenunban","!unwb","!unbanwarden"})
wardenban:help("Ban target from warden")

function ulx.guardbaninfo( calling_ply, target_ply)
	if GAMEMODE_NAME != "jailbreak" then ULib.tsayError(calling_ply,error_not_jailbreak,true) else
		if tobool(target_ply:GetPData("guardbanned_perm",false)) then
			ULib.tsay(calling_ply,target_ply:Name().." was guardbanned permanently by "..target_ply:GetPData("guardbanned_by","an unknown person" )..".")
			ULib.tsay(calling_ply,"The ban was issued about "..math.Round((os.time()-target_ply:GetPData("guardbanned_on",0))/60).." minutes ago.")
		elseif tonumber(target_ply:GetPData("guardbanned",0)) > os.time() then
			ULib.tsay(calling_ply,target_ply:Name().." was guardbanned by "..target_ply:GetPData("guardbanned_by","an unknown person" )..".")
			ULib.tsay(calling_ply,"The ban was issued about "..math.Round((os.time()-target_ply:GetPData("guardbanned_on",0))/60).." minutes ago and will expire in about "..math.Round((target_ply:GetPData("guardbanned",0)-os.time())/60).." minutes.")
		else 
			ULib.tsayError(calling_ply,target_ply:Name().." is not guardbanned!")
		end
	end
end
local guardbaninfo = ulx.command(CATEGORY_NAME, "ulx guardbaninfo", ulx.guardbaninfo, {"!guardbaninfo", "!gbinfo"}, true )
guardbaninfo:defaultAccess(ULib.ACCESS_ADMIN) --Allow all to use this command on themself and staff on others for desired results
guardbaninfo:addParam{type=ULib.cmds.PlayerArg,default="^",ULib.cmds.optional}
guardbaninfo:help("Prints info about a guardban.")

function ulx.wardenbaninfo(calling_ply,target_ply)
	if GAMEMODE_NAME != "jailbreak" then ULib.tsayError(calling_ply,error_not_jailbreak,true) else
		if tobool(target_ply:GetPData("wardenbanned_perm",false)) then
			ULib.tsay(calling_ply,target_ply:Name().." was wardenbanned permanently by "..target_ply:GetPData("wardenbanned_by","an unknown person" )..".")
			ULib.tsay(calling_ply,"The ban was issued about "..math.Round((os.time()-target_ply:GetPData("wardenbanned_on",0))/60).." minutes ago.")
		elseif tonumber(target_ply:GetPData("wardenbanned",0)) > os.time() then
			ULib.tsay(calling_ply,target_ply:Name().." was wardenbanned by "..target_ply:GetPData("wardenbanned_by","an unknown person")..".")
			ULib.tsay(calling_ply,"The ban was issued about "..math.Round((os.time()-target_ply:GetPData("guardbanned_on",0))/60).." minutes ago and will expire in about "..math.Round((target_ply:GetPData("guardbanned",0)-os.time())/60).." minutes.")
		else
			ULib.tsayError(calling_ply,target_ply:Name() .." is not guardbanned!")
		end
	end
end
local wardenbaninfo = ulx.command(CATEGORY_NAME, "ulx wardenbaninfo", ulx.wardenbaninfo, {"!wardenbaninfo", "!wbinfo"}, true )
wardenbaninfo:defaultAccess( ULib.ACCESS_ADMIN ) --Allow all to use this command on themself and staff on others for desired results
wardenbaninfo:addParam{type=ULib.cmds.PlayerArg,default="^",ULib.cmds.optional}
wardenbaninfo:help("Prints info about a wardenban.")


hook.Add("JailBreakPlayerSwitchTeam","jbulx_JailBreakPlayerSwitchTeam",function(player,team)
	if (tonumber(player:GetPData("guardbanned",0)) > os.time() or (tobool(player:GetPData("guardbanned_perm",false)))) and team == TEAM_GUARD then
		player:SetTeam(TEAM_PRISONER)
		player:KillSilent()
		player:SendNotification("Forced to prisoners")
		if tobool(player:GetPData("guardbanned_perm",false)) then
			ULib.tsayError(player,"You are permanently banned from joining guards!")
		else
			ULib.tsayError(player,"You are banned from joining guards! You will be unbanned in about "..math.Round((player:GetPData("guardbanned",0)-os.time())/60).." minutes.")
		end
		ulx.fancyLog("#T attemped to join guards while guardbanned.",player,true)
	end
end)

hook.Add("JailBreakClaimWarden","jbulx_JailBreakClaimWarden",function(player)
	if tonumber(player:GetPData("wardenbanned",0)) > os.time() or (tobool(player:GetPData("wardenbanned_perm",false))) then
		player:RemoveWardenStatus()
		player:SendNotification("Demoted from warden")
		if tobool(player:GetPData("wardenbanned_perm",false)) then
			ULib.tsayError(player,"You are permanently banned from becoming warden!")
		else
			ULib.tsayError(player,"You are banned from becoming warden! You will be unbanned in about "..math.Round((player:GetPData("guardbanned",0)-os.time())/60).." minutes.")
		end
		ulx.fancyLog("#T attemped to become warden while wardenbanned.",ply,true)
	end
end)
