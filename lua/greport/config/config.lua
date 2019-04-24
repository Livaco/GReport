/*
This is the default configuration. Use this to edit anything.
If you need help with this make a support ticket on my website https://livacoweb.000webhostapp.com/index.php
*/

-- The command users should use to open the UI
GReport.Config.UICommand = "!report"

-- The prefix the addon uses for chat messages.
GReport.Config.Prefix = "[GReport]"

-- The color of the prefix.
GReport.Config.PrefixColor = Color(0, 200, 0)

-- The name of the staff groups for the side of the panel, and to access the admin panel. Only tested with ULX, if another admin mod doesn't work make a ticket to me.
GReport.Config.StaffGroups = {"owner", "superadmin", "admin"}

-- What groups should not have access to the addon.
GReport.Config.BlacklistGroups = {"noaccess"}

-- Whether users should see players SteamID's
GReport.Config.ShowPlayerSteamIDs = true

-- What the notice says at the side of the screen when making a report.
GReport.Config.Notice = [[
Please note that false-reports or reports that have little to no information will have their authors punished!
Thank you.
]]

-- The reasons for making a report, seperate these using commas.
GReport.Config.Reasons = {"RDM", "CDM", "Bug Abuse", "Other"}

-- If all reports should be stored permanently (using MySQLite).
GReport.Config.SQLStorage = true 