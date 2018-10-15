-- Just to save me time
local function conprint(msg)

  MsgC(Color(150, 150, 255), "[")
  MsgC(Color(200, 200, 200), "GReport")
  MsgC(Color(150, 150, 255), "] ")
  MsgC(Color(200, 200, 200), msg)
  MsgC(Color(200, 200, 200), "\n")

end

GReport = {}
GReport.Config = GReport.Config or {}
GReport.Config.Lang = GReport.Config.Lang or {}

if SERVER then

  conprint("Loading...")
  include("greport/gr_netshit.lua")
  include("greport/gr_server.lua")
  AddCSLuaFile("greport/config/config.lua")
  AddCSLuaFile("greport/gr_client.lua")
  AddCSLuaFile("greport/vgui/gr_derma.lua")
  AddCSLuaFile("greport/vgui/gr_fonts.lua")
  AddCSLuaFile("greport/config/lang.lua")
  conprint("Loaded.")

end

if CLIENT then

  include("greport/vgui/gr_derma.lua")
  include("greport/gr_client.lua")
  include("greport/config/lang.lua")
  -- Fonts are included when UI is called to ensure that they can change resulutions and not have to relog

end
