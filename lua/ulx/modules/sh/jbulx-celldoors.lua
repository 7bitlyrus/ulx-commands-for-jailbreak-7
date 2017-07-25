
CubeJB_CellDoorOpen = {

  ["jb_new_summer_v2"] = {66,  67},

  ["ba_jail_sand_v3"] = {399,404},

  ["ba_jail_blackops"] = {397,  361,  340,  410},

  ["jb_lego_jail_v4"] = {142,  143},

  ["jb_italia_final"] = {621},

  ["ba_jail_electric_aero_v1_1"] = {192},

  ["jb_carceris"] = {478,479},

  ["ba_jail_laser_v4b"] = {744,745},

}



CubeJB_CellDoorMap = {

  ["jb_new_summer_v2"] = {"cells"},

  ["ba_jail_sand_v3"] = {"JailDoors"},

  ["ba_jail_blackops"] = {"prisondoor"},
  
  ["jb_new_summer_v3"] = {"cells"},

  ["jb_lego_jail_v4"] = {"cell1"},
  
  ["jb_lego_jail_pre_v6-2"] = {"c1"},

  ["jb_italia_final"] = {"door cells"},

  ["ba_jail_electric_aero_v1_1"] = {"Cells_ForceFieldEmitter","Cells_ForceFields"},

  ["jb_carceris"] = {"s1","s2","s3","s4","s5","s6","s7","s8","s9","s10","s11","s12","s13","s14","s15","s16"},

  ["ba_jail_laser_v4b"] = {"celdas.1.puerta","celdas.2.puerta"},

  ["jb_vipinthemix_v1_2"] = {
"Jaildoor_clip1",
"Jaildoor_clip2",
"Jaildoor_clip3",
"Jaildoor_clip4",
"Jaildoor_clip5",
"Jaildoor_clip6",
"Jaildoor_clip7",
"Jaildoor_clip8",
"Jaildoor_clip9",
"Jaildoor_clip10",
"Vipcel_door"
}

}



local CATEGORY_NAME = "Jailbreak"




function ulx.opencells(calling_ply)

  for k, v in pairs(ents.GetAll()) do

    for _, door in pairs(CubeJB_CellDoorMap[game.GetMap()]) do 
      if v:GetName() == nil then continue end

      if (v:GetName() == door and IsEntity(v)) then

       timer.Simple(0,function()  v:Fire("Open") v:Fire("Disable") end)

      end

    end

  end



  ulx.fancyLogAdmin(calling_ply, "#A opened cell doors")

end



local opencells = ulx.command(CATEGORY_NAME, "ulx opencells", ulx.opencells, { "!opencells", "!open"} )

opencells:defaultAccess(ULib.ACCESS_ADMIN)

opencells:help("Opens the cell doors")

