include("config/config.lua")
include("config/lang.lua")

GReport.Staff = GReport.Staff or {}

-- hey look this function again
local function conprint(msg)

  MsgC(Color(150, 150, 255), "[")
  MsgC(Color(200, 200, 200), "GReport")
  MsgC(Color(150, 150, 255), "] ")
  MsgC(Color(200, 200, 200), msg)
  MsgC(Color(200, 200, 200), "\n")

end

local RanCheck = false
hook.Add("PlayerConnect", "greport_checkversion", function()
    if(RanCheck == true) then return end
    conprint("Running version check!")
    http.Post("http://livacoweb.000webhostapp.com/libaries/versions/greport.php", {RunningVar = "1.2"}, function(result)
        conprint(result)
    end, function(fail)
        conprint(fail)
    end)
    RanCheck = true
end)

net.Receive("gr_requestadmin", function(len, ply)
    if(table.HasValue(GReport.Config.StaffGroups, ply:GetUserGroup())) then
        local tabletosend = table.Reverse(GReport.Reports)
        net.Start("gr_adminui")
        net.WriteTable(tabletosend)
        net.Send(ply)
    else
        net.Start("gr_message")
        net.WriteString(GReport.Config.Lang.NoPermissionError)
        net.Send(ply)
    end
end)

hook.Add("PlayerSay", "gr_usercommand", function(ply, text, team)
    local nocaps = string.lower(text)
    if(string.sub(nocaps, 1, #GReport.Config.UICommand) == GReport.Config.UICommand) then
        for k,v in pairs(GReport.Config.BlacklistGroups) do
            if(ply:GetUserGroup() == v) then
                -- no
                net.Start("gr_message")
                net.WriteString(GReport.Config.Lang.NoPermissionError)
                net.Send(ply)
            else
            -- yes
                net.Start("gr_openui")
                net.WriteTable(GReport.Staff)
                if(table.HasValue(GReport.Config.StaffGroups, ply:GetUserGroup())) then
                    net.WriteBool(true)
                end
                net.Send(ply)
            end
        end
    end
end)

hook.Add("PlayerInitialSpawn", "gr_cashe_staff", function(ply)
    if table.HasValue(GReport.Config.StaffGroups, ply:GetUserGroup()) then
        table.insert(GReport.Staff, ply)
    end
end)

hook.Add("PlayerDisconnected", "gr_cashe_staff", function(ply)
    if table.HasValue(GReport.Staff, ply) then
        table.RemoveByValue(GReport.Staff, ply)
    end
end)

hook.Add("PlayerDisconnected", "gr_cashe_staff", function(ply)
    if table.HasValue(GReport.Staff, ply) then
        table.RemoveByValue(GReport.Staff, ply)
    end
end)

hook.Add("ULibUserGroupChange", "gr_cashe_ingame", function(plyid, allows, denies, new, old)
    local ply = player.GetBySteamID(plyid)
    if(ply == false) then
    conprint("Error while updating staff list. Aborting! Send this to my on my website!")
    return
    end

    if(table.HasValue(GReport.Config.StaffGroups, new)) then
        if(!table.HasValue(GReport.Staff, ply)) then
            table.insert(GReport.Staff, ply)
        end
    else
        if(table.HasValue(GReport.Staff, ply)) then
        table.RemoveByValue(GReport.Staff, ply)
        end
    end
end)

net.Receive("gr_receivereport", function(len, ply)
    local suspect = net.ReadEntity()
    local reason = net.ReadString()
    local desc = net.ReadString()
    table.insert(GReport.Reports, {
        reporter = {
            name = ply:Nick(),
            sid = ply:SteamID64()
        },
        reported = {
            name = suspect:Nick(),
            sid = suspect:SteamID64()
        },
        reason = reason,
        description = desc
    })
    net.Start("gr_message")
    net.WriteString(GReport.Config.Lang.SubmittedReport)
    net.Send(ply)
    if(GReport.Config.SQLStorage == true) then
        GReport.SQLStore({name = ply:Nick(), sid = ply:SteamID64()}, {name = suspect:Nick(), sid = suspect:SteamID64()}, reason, desc)
    end
end)
