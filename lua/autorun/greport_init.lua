GReport = {}
GReport.Config = GReport.Config or {}
GReport.Config.Lang = GReport.Config.Lang or {}
GReport.Reports = GReport.Reports or {}

function GReport.Print(msg)
  MsgC(Color(150, 150, 255), "[")
  MsgC(Color(200, 200, 200), "GReport")
  MsgC(Color(150, 150, 255), "] ")
  MsgC(Color(200, 200, 200), msg)
  MsgC(Color(200, 200, 200), "\n")
end

if SERVER then
  GReport.Print("Loading...")

  include("greport/gr_netshit.lua")
  include("greport/gr_server.lua")
  include("greport/gr_sql.lua")
  AddCSLuaFile("greport/config/config.lua")
  AddCSLuaFile("greport/gr_client.lua")
  AddCSLuaFile("greport/vgui/gr_derma.lua")
  AddCSLuaFile("greport/vgui/gr_fonts.lua")
  AddCSLuaFile("greport/config/lang.lua")
  if(GReport.Config.SQLStorage == true) then
      GReport.CheckSQLTables()
      for k,v in pairs(GReport.GetSQLReports()) do
          Reporter = util.JSONToTable(v.Reporter)
          Reported = util.JSONToTable(v.Reported)
          table.insert(GReport.Reports, {
              reporter = Reporter,
              reported = Reported,
              reason = v.Reason,
              description = v.Description,
          })
      end
  end

  GReport.Print("Loaded.")
end

if CLIENT then
  include("greport/vgui/gr_derma.lua")
  include("greport/gr_client.lua")
  include("greport/config/lang.lua")
  -- Fonts are included when UI is called to ensure that they can change resulutions and not have to relog
end
