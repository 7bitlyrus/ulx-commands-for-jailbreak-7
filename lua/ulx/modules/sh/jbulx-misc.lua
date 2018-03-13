local error_not_jailbreak = "The current gamemode is not jailbreak!"
local CATEGORY_NAME = "Jailbreak"


function ulx.respawn(calling_ply,target_plys)
	for k,v in pairs(target_plys) do
		if GAMEMODE_NAME == "jailbreak" then v._jb_forceRespawn=true end
		v:Spawn()
	end
	ulx.fancyLogAdmin(calling_ply,"#A respawned #T",target_plys)
end
local respawn = ulx.command(CATEGORY_NAME,"ulx respawn",ulx.respawn,"!respawn")
respawn:defaultAccess(ULib.ACCESS_ADMIN)
respawn:addParam{type=ULib.cmds.PlayersArg}
respawn:help("Respawns target(s).")

function ulx.revive(calling_ply,target_plys)
	local affected_plys = {}
	for k,v in pairs( target_plys ) do
		if v:Team() == TEAM_SPECTATOR then
			ULib.tsayError(calling_ply,v:Nick().." is in spectator mode and cannot be targetted.",true)
		elseif v:Alive() then
			ULib.tsayError(calling_ply,v:Nick().." is already alive, so cannot be revived.",true)
		else
			if GAMEMODE_NAME == "jailbreak" then v._jb_forceRespawn=true end
			v:Spawn()
			table.insert(affected_plys,v)
		end
	end
	ulx.fancyLogAdmin(calling_ply,"#A revived #T",affected_plys)
end
local revive = ulx.command(CATEGORY_NAME,"ulx revive",ulx.revive,"!revive")
revive:defaultAccess(ULib.ACCESS_ADMIN)
revive:addParam{type=ULib.cmds.PlayersArg}
revive:help("Revives target(s).")

function ulx.toggleff(calling_ply)
	if GAMEMODE_NAME != "jailbreak" then ULib.tsayError(calling_ply,error_not_jailbreak,true) else
		JB.TRANSMITTER:SetJBWarden_PVPDamage(!JB.TRANSMITTER:GetJBWarden_PVPDamage());
		JB:BroadcastNotification("Friendly fire is now "..(JB.TRANSMITTER:GetJBWarden_PVPDamage() and "enabled" or "disabled"))
		ulx.fancyLogAdmin( calling_ply, "#A toggled friendly fire")
	end
end
local toggleff = ulx.command(CATEGORY_NAME,"ulx toggleff",ulx.toggleff,{"!toggleff","!tff","!ff"})
toggleff:defaultAccess(ULib.ACCESS_ADMIN)
toggleff:help("Toggles friendly fire.")

function ulx.togglepickup( calling_ply )
	if GAMEMODE_NAME != "jailbreak" then ULib.tsayError(calling_ply,error_not_jailbreak,true) else
		JB.TRANSMITTER:SetJBWarden_ItemPickup(!JB.TRANSMITTER:GetJBWarden_ItemPickup());
		JB:BroadcastNotification("Item pickup is now "..(JB.TRANSMITTER:GetJBWarden_ItemPickup() and "enabled" or "disabled"))
		ulx.fancyLogAdmin(calling_ply,"#A toggled item pickup")
	end
end
local togglepickup = ulx.command(CATEGORY_NAME,"ulx togglepickup",ulx.togglepickup,{"!togglepickup","!tpu","!togglepu","!tpickup","!pickup"})
togglepickup:defaultAccess(ULib.ACCESS_ADMIN)
togglepickup:help("Toggles item pickup.")

function ulx.demotewarden( calling_ply )
	if GAMEMODE_NAME != "jailbreak" then ULib.tsayError(calling_ply,error_not_jailbreak,true) else
		if IsValid(JB.TRANSMITTER:GetJBWarden()) then
			ulx.fancyLogAdmin(calling_ply,"#A removed the warden status from #T",JB.TRANSMITTER:GetJBWarden())
			JB.TRANSMITTER:GetJBWarden():RemoveWardenStatus();
			target_ply:SendNotification("Demoted from warden")
		else
			ULib.tsayError(calling_ply,"There is no warden to demote!",true);
		end
	end
end
local demotewarden = ulx.command(CATEGORY_NAME,"ulx demotewarden",ulx.demotewarden,{"!demotewarden","!dewarden","!unwarden","!dw"})
demotewarden:defaultAccess(ULib.ACCESS_ADMIN)
demotewarden:help("Remove the warden status from the current warden.")

function ulx.slaynr(calling_ply,target_plys,rounds,remove)
	if GAMEMODE_NAME != "jailbreak" then ULib.tsayError(calling_ply,error_not_jailbreak,true) else
		local affected_plys = {}
		if remove then
			for k,v in pairs(target_plys) do
				local current_slays = tonumber(v:GetPData("slaynr_slays")) or 0
				if rounds > current_slays then
					ULib.tsayError(calling_ply,v:Nick().." does not have that many slays to remove.",true)
				else
					local new_slays = current_slays - rounds
					if rounds == 0 or new_slays == 0 then
						v:RemovePData("slaynr_slays")
					else
						v:SetPData("slaynr_slays",new_slays)
					end
					table.insert(affected_plys,v)
				end
			end
			if rounds == 0 then
				ulx.fancyLogAdmin(calling_ply,"#A removed all slays from #T",affected_plys)
			else
				ulx.fancyLogAdmin(calling_ply,"#A removed "..rounds.." slays from #T",affected_plys)
			end
		else
			if rounds == 0 then
				ULib.tsayError(calling_ply,"You can't slay a player for zero rounds!")
			else
				for k,v in pairs(target_plys) do
					local current_slays = tonumber(v:GetPData("slaynr_slays")) or 0
					local new_slays = current_slays + rounds
					v:SetPData("slaynr_slays",new_slays)
					table.insert(affected_plys,v)
				end
				ulx.fancyLogAdmin(calling_ply,"#A will slay #T for "..rounds.." rounds",affected_plys)
			end
		end
	end
end
local slaynr = ulx.command(CATEGORY_NAME,"ulx slaynr",ulx.slaynr,"!slaynr")
slaynr:addParam{type=ULib.cmds.PlayersArg}
slaynr:addParam{type=ULib.cmds.NumArg,default=1,min=0,hint="rounds",ULib.cmds.optional,ULib.cmds.round}
slaynr:addParam{type=ULib.cmds.BoolArg,invisible=true}
slaynr:defaultAccess(ULib.ACCESS_ADMIN)
slaynr:help("Slay target(s) next round")
slaynr:setOpposite("ulx rslaynr",{_,_,_,true},"!rslaynr")

function ulx.cslaynr(calling_ply,target_ply)
	if GAMEMODE_NAME != "jailbreak" then ULib.tsayError(calling_ply,error_not_jailbreak,true) else
		local slays = tonumber(target_ply:GetPData("slaynr_slays")) or 0
		if slays > 0 then
			ULib.tsay(calling_ply,target_ply:Nick().." has "..slays.." slays remaining.",true)
		else
			ULib.tsay(calling_ply,target_ply:Nick().." has no slays.",true)
		end
	end
end
local cslaynr = ulx.command(CATEGORY_NAME,"ulx cslaynr",ulx.cslaynr,"!cslaynr")
cslaynr:addParam{type=ULib.cmds.PlayerArg,default="^",ULib.cmds.optional}
cslaynr:defaultAccess(ULib.ACCESS_ADMIN) --Allow access to all for self, but only allow staff to check others' slays for desired results
cslaynr:help("Check target's slays")

function ulx.showdeath(calling_ply,target_ply)
	local deathpos = target_ply:GetNWVector("lastDeathPos")
	if deathpos == nil then Ulib.tsayError(target_ply:Name(), " did not die yet!") return end
	if calling_ply:Alive() then
		local prevPos = calling_ply:GetPos()
		calling_ply:SetPos(deathpos)
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
local showdeath = ulx.command(CATEGORY_NAME,"ulx showdeath",ulx.showdeath,{"!showdeath","!tpd","!tpdeath"})
showdeath:addParam{type=ULib.cmds.PlayerArg,default="^",ULib.cmds.optional}
showdeath:defaultAccess(ULib.ACCESS_ADMIN)
showdeath:help("Teleports you to the position where the target died")


hook.Add("JailBreakRoundStart","jbulx-RoundStart-SlayNR",function()
	local affected_plys = {}
	for _,v in pairs(player.GetAll()) do
		local slays_left = tonumber(v:GetPData("slaynr_slays")) or 0
		if v:Alive() and slays_left > 0 then
			table.insert(affected_plys,v)
			v:KillSilent()
			local new_slays = slays_left - 1
			if v:Team() == 2 then
				v:ConCommand("jb_team_select_prisoner")
			end
			v:SetPData("slaynr_slays",new_slays)
		end
	end
	local count_plys = 0
	for _ in pairs(affected_plys) do count_plys = count_plys + 1 end
	if count_plys == 1 then
		ulx.fancyLog("#T was slain for their actions in previous rounds",affected_plys)
	elseif count_plys > 1 then
		ulx.fancyLog("#T were slain for their action in previous rounds",affected_plys)
	end
end)

hook.Add("PlayerDeath","jbulx-PlayerDeath",function(ply)
	ply:SetNWVector("lastDeathPos",ply:GetPos())
end)
