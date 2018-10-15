include("greport/config/config.lua")

-- functions
local blur = Material("pp/blurscreen")
local function DrawBlur(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

local function OutlinedBox(x, y, w, h, thickness, clr)
	surface.SetDrawColor(clr)
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect(x + i, y + i, w - i * 2, h - i * 2)
	end
end

-- actual ui
net.Receive("gr_openui", function()

	include("greport/vgui/gr_fonts.lua")

  local stafftable = net.ReadTable()
	local accessstaff = net.ReadBool()

  local frame = vgui.Create("DFrame")
  frame:SetSize(ScrW() * 0.8, ScrH() * 0.8)
  frame:Center()
  frame:MakePopup()
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	frame:TDLib():FadeIn()
	frame.Paint = function(s, w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    DrawBlur(frame, 5) -- I'm aware there is one built into tdlib but its pretty bad so i made my own
    OutlinedBox(0, 0, w, h, 2, Color(0, 0, 0, 200))
		draw.RoundedBox(0, 0, 0, w, h * 0.035, Color(0, 0, 0, 255))
		draw.SimpleText(GReport.Config.Lang.UserTitle, "gr_userpaneltitle", w * 0.005, h * 0.005, Color(255, 255, 255, 255), 0, 0)

	end

	local closethatshit = vgui.Create("DButton", frame)
	closethatshit:SetSize(frame:GetWide() * 0.02, frame:GetTall() * 0.035)
	closethatshit:SetPos(frame:GetWide() * 0.98, frame:GetTall() * 0)
	closethatshit:TDLib():CircleHover()
	closethatshit:SetText("")
	closethatshit.Paint = function(s, w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))
		draw.SimpleText("X", "gr_userpaneltitle", w / 2, h / 2, Color(255, 255, 255), 1, 1)

	end
	closethatshit.DoClick = function()

		frame:Close()

	end

	if(accessstaff == true) then

		local StaffPanelButton = vgui.Create("DButton", frame)
		StaffPanelButton:SetSize(frame:GetWide() * 0.1, frame:GetTall() * 0.035)
		StaffPanelButton:SetPos(frame:GetWide() * 0.88, frame:GetTall() * 0)
		StaffPanelButton:TDLib():CircleHover()
		StaffPanelButton:SetText("")
		StaffPanelButton.Paint = function(s, w, h)

			draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))
			draw.SimpleText("Admin", "gr_userpaneltitle", w / 2, h / 2, Color(255, 255, 255), 1, 1)

		end
		StaffPanelButton.DoClick = function()

			frame:Close()
			net.Start("gr_requestadmin")
			net.SendToServer()

		end

	end

	local StaffPanel = vgui.Create("DPanel", frame)
	StaffPanel:SetPos(frame:GetWide() * 0.7, frame:GetTall() * 0.04)
	StaffPanel:SetSize(frame:GetWide() * 0.295, frame:GetTall() * 0.95)
	StaffPanel.Paint = function(s, w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
		draw.SimpleText("Staff Online", "gr_userpaneltitle", w * 0.5, h * 0.005, Color(255, 255, 255, 255), 1, 0)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawLine(w * 0.1, h * 0.05, w * 0.9, h * 0.05)

	end

	local StaffScroll = vgui.Create("DScrollPanel", StaffPanel)
	StaffScroll:SetSize(StaffPanel:GetWide(), StaffPanel:GetTall() * 0.925)
	StaffScroll:SetPos(0, StaffPanel:GetTall() * 0.075)
	StaffScroll.Paint = function(s, w, h)

		--draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))

	end

	local StaffPanelHeight = 0

	if(table.Count(stafftable) == 0) then

		local DLabel = StaffScroll:Add("DLabel")
		DLabel:Dock(FILL)
		DLabel:SetContentAlignment(8)
		DLabel:SetFont("gr_userpaneltitle")
		DLabel:SetText("There is no staff online!")
		DLabel:SetTextColor(Color(255, 255, 255))


	else

		for k,v in ipairs(stafftable) do

			local StaffPanel = StaffScroll:Add("DPanel")
			StaffPanel:SetSize(StaffScroll:GetWide(), StaffScroll:GetTall() * 0.15)
      StaffPanel:SetPos(0, StaffPanelHeight)
			StaffPanel.Paint = function(s, w, h)

				surface.SetDrawColor(255, 255, 255)
				surface.DrawLine(StaffPanel:GetWide() * 0.45, StaffPanel:GetTall() * 0.5, StaffPanel:GetWide() * 0.75, StaffPanel:GetTall() * 0.5)

			end

			local Avatar = vgui.Create("DPanel", StaffPanel)
			Avatar:SetSize(StaffPanel:GetWide() * 0.2, StaffPanel:GetTall() * 0.85)
      Avatar:SetPos(StaffPanel:GetWide() * 0.1, StaffPanel:GetTall() * 0.05)
			Avatar:TDLib():CircleAvatar():SetPlayer(v, 128)

			local Name = vgui.Create("DLabel", StaffPanel)
			Name:SetSize(StaffPanel:GetWide() * 0.5, StaffPanel:GetTall())
			Name:SetPos(StaffPanel:GetWide() * 0.35, StaffPanel:GetTall() * 0.25)
			Name:SetFont("gr_userpaneltitle")
			Name:SetText("There is no staff online!")
			Name:SetContentAlignment(8)
			Name:SetTextColor(Color(255, 255, 255, 255))
			Name:SetText(v:Nick())

			local Group = vgui.Create("DLabel", StaffPanel)
			Group:SetSize(StaffPanel:GetWide() * 0.5, StaffPanel:GetTall())
			Group:SetPos(StaffPanel:GetWide() * 0.35, StaffPanel:GetTall() * 0.55)
			Group:SetFont("gr_userpaneltitle")
			Group:SetText("There is no staff online!")
			Group:SetContentAlignment(8)
			Group:SetTextColor(Color(255, 255, 255, 255))
			Group:SetText(v:GetUserGroup())

			StaffPanelHeight = StaffPanelHeight + StaffScroll:GetTall() * 0.15

		end

	end

	local Notice = vgui.Create("RichText", frame)
	Notice:SetPos(frame:GetWide() * 0.005, frame:GetTall() * 0.04)
	Notice:SetSize(frame:GetWide() * 0.25, frame:GetTall() * 0.95)
	Notice.Paint = function(s, w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))

	end
	Notice.PerformLayout = function()

		Notice:SetFGColor(Color(255, 255, 255))

	end
	Notice:AppendText(GReport.Config.Notice)

  local PlayerSelect = vgui.Create("DComboBox", frame)
	PlayerSelect:SetPos(frame:GetWide() * 0.265, frame:GetTall() * 0.04)
	PlayerSelect:SetSize(frame:GetWide() * 0.425, frame:GetTall() * 0.03)
	PlayerSelect:SetSortItems(false)
	PlayerSelect:TDLib():CircleHover()
	PlayerSelect:SetTextColor(Color(255, 255, 255, 255))
	PlayerSelect:SetValue(GReport.Config.Lang.PlayerSelectText)

	for k,v in pairs(player.GetAll()) do

		if(GReport.Config.ShowPlayerSteamIDs == true) then

			PlayerSelect:AddChoice(v:Nick() .. " - " .. v:SteamID(), v)

		else

			PlayerSelect:AddChoice(v:Nick(), v)

		end

	end

	PlayerSelect.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
	end

	local Reason = vgui.Create("DComboBox", frame)
	Reason:SetPos(frame:GetWide() * 0.265, frame:GetTall() * 0.08)
	Reason:SetSize(frame:GetWide() * 0.425, frame:GetTall() * 0.03)
	Reason:SetSortItems(false)
	Reason:TDLib():CircleHover()
	Reason:SetTextColor(Color(255, 255, 255, 255))
	Reason:SetValue(GReport.Config.Lang.ReasonSelectText)
	Reason.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
	end
	for k,v in pairs(GReport.Config.Reasons) do

		Reason:AddChoice(v)

	end

	local OtherDetails = vgui.Create("DTextEntry", frame)
	OtherDetails:SetPos(frame:GetWide() * 0.265, frame:GetTall() * 0.12)
	OtherDetails:SetSize(frame:GetWide() * 0.425, frame:GetTall() * 0.825)
	OtherDetails:SetValue(GReport.Config.Lang.DescriptionDefault) -- Since I custom-painted it, SetPlaceHolderText doesn't seem to work so i've just gone with this.
	OtherDetails:SetMultiline(true)
	OtherDetails.Paint = function(s, w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))

		s:DrawTextEntryText(Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255))

	end

	local SubmitButton = vgui.Create("DButton", frame)
	SubmitButton:SetPos(frame:GetWide() * 0.265, frame:GetTall() * 0.96)
	SubmitButton:SetSize(frame:GetWide() * 0.425, frame:GetTall() * 0.03)
	SubmitButton:SetColor(Color(255, 255, 255, 255))
	SubmitButton:SetText("Submit")
	SubmitButton:TDLib():ClearPaint()
	:Background(Color(0, 0, 0, 200))
  :CircleHover()

	SubmitButton.DoClick = function()

		local Reporter = LocalPlayer()
		local Reported = PlayerSelect:GetOptionData(PlayerSelect:GetSelectedID())
		local Reasona = Reason:GetOptionText(Reason:GetSelectedID())
		local Description = OtherDetails:GetValue()

		if(Reasona == nil) then

			chat.AddText(GReport.Config.PrefixColor, GReport.Config.Prefix, Color(255, 255, 255), " " .. GReport.Config.Lang.NoReason)
			frame:Close()
			return

		end

		if(Description == "") then

			chat.AddText(GReport.Config.PrefixColor, GReport.Config.Prefix, Color(255, 255, 255), " " .. GReport.Config.Lang.NoDescription)
			frame:Close()
			return

		end

		if(Reported == nil) then

			chat.AddText(GReport.Config.PrefixColor, GReport.Config.Prefix, Color(255, 255, 255), " " .. GReport.Config.Lang.NoPlayer)
			frame:Close()
			return

		end

		frame:Close()
		ShowPreview(Reporter, Reported, Reasona, Description)

	end

end)

function ShowPreview(reporter, reported, reason, description)

	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrW() * 0.5, ScrH() * 0.5)
  frame:Center()
  frame:MakePopup()
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	frame:TDLib():FadeIn()
	frame.Paint = function(s, w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    DrawBlur(frame, 5)
    OutlinedBox(0, 0, w, h, 2, Color(0, 0, 0, 200))
		draw.RoundedBox(0, 0, 0, w, h * 0.035, Color(0, 0, 0, 255))
		draw.SimpleText("Confirm Report", "gr_userpanelconfirmtitle", w * 0.005, h * 0.004, Color(255, 255, 255, 255), 0, 0)
		surface.SetDrawColor(255, 255, 255)
		draw.SimpleText("Are you sure you want to submit this report?", "gr_userpanelconfirmtitle", w * 0.5, h * 0.07, Color(255, 255, 255, 255), 1, 0)

	end

	local closethatnigger = vgui.Create("DButton", frame)
	closethatnigger:SetSize(frame:GetWide() * 0.02, frame:GetTall() * 0.035)
	closethatnigger:SetPos(frame:GetWide() * 0.98, frame:GetTall() * 0)
	closethatnigger:TDLib():CircleHover()
	closethatnigger:SetText("")
	closethatnigger.Paint = function(s, w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))
		draw.SimpleText("X", "gr_userpaneltitle", w / 2, h / 2, Color(255, 255, 255), 1, 1)

	end
	closethatnigger.DoClick = function()

		frame:Close()

	end

	local ReportingAvatar = vgui.Create("DPanel", frame)
	ReportingAvatar:SetPos(frame:GetWide() * 0.05, frame:GetTall() * 0.1)
	ReportingAvatar:SetSize(frame:GetWide() * 0.1, frame:GetTall() * 0.18)
	ReportingAvatar:TDLib():ClearPaint()
	:CircleAvatar()
	:SetPlayer(reporter, 128)

	local ReportingAvatar = vgui.Create("DPanel", frame)
	ReportingAvatar:SetPos(frame:GetWide() * 0.85, frame:GetTall() * 0.1)
	ReportingAvatar:SetSize(frame:GetWide() * 0.1, frame:GetTall() * 0.18)
	ReportingAvatar:TDLib():ClearPaint()
	:CircleAvatar()
	:SetPlayer(reported, 128)

	local ReportingLabel = vgui.Create("DLabel", frame)
	ReportingLabel:SetPos(frame:GetWide() * 0.175, frame:GetTall() * 0.145)
	ReportingLabel:SetColor(Color(255, 255, 255, 255))
	ReportingLabel:SetFont("gr_userpaneltitle")
	ReportingLabel:SetText("Reporting Player: \n" .. reporter:Nick())
	ReportingLabel:SizeToContents()

	local ReportedLabel = vgui.Create("DLabel", frame)
	ReportedLabel:SetPos(frame:GetWide() * 0.175, frame:GetTall() * 0.145)
	ReportedLabel:SetColor(Color(255, 255, 255, 255))
	ReportedLabel:SetFont("gr_userpaneltitle")
	ReportedLabel:SetText("Reported Player:")
	ReportedLabel:SizeToContents()
	ReportedLabel:AlignRight(frame:GetWide() * 0.175)

	local ReportedLabel2 = vgui.Create("DLabel", frame)
	ReportedLabel2:SetPos(frame:GetWide() * 0.175, frame:GetTall() * 0.185)
	ReportedLabel2:SetColor(Color(255, 255, 255, 255))
	ReportedLabel2:SetFont("gr_userpaneltitle")
	ReportedLabel2:SetText(reported:Nick())
	ReportedLabel2:SizeToContents()
	ReportedLabel2:AlignRight(frame:GetWide() * 0.175)

	local Reason = vgui.Create("DLabel", frame)
	Reason:SetPos(frame:GetWide() * 0.05, frame:GetTall() * 0.3)
	Reason:SetColor(Color(255, 255, 255, 255))
	Reason:SetFont("gr_userpaneltitle")
	Reason:SetText("Reason: " .. reason)
	Reason:SizeToContents()

	local Descriptione = vgui.Create("RichText", frame)
	Descriptione:SetPos(frame:GetWide() * 0.05, frame:GetTall() * 0.35)
	Descriptione:SetSize(frame:GetWide() * 0.9, frame:GetTall() * 0.55)
	Descriptione.Paint = function(s, w, h)
	end
	Descriptione.PerformLayout = function()

		Descriptione:SetFGColor(Color(255, 255, 255))

	end
	Descriptione:AppendText(description)
	Descriptione.Paint = function(s, w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))

	end

	local YesButton = vgui.Create("DButton", frame)
	YesButton:SetPos(frame:GetWide() * 0.05, frame:GetTall() * 0.925)
	YesButton:SetSize(frame:GetWide() * 0.35, frame:GetTall() * 0.05)
	YesButton:SetText("")
	YesButton.Paint = function(s, w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
		draw.SimpleText(GReport.Config.Lang.YesButton, "gr_userpaneltitle", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)

	end
	YesButton:TDLib():CircleHover()
	YesButton.DoClick = function()

		net.Start("gr_receivereport")
		net.WriteEntity(reported)
		net.WriteString(reason)
		net.WriteString(description)
		net.SendToServer()
		
		frame:Close()

	end

	local NoButton = vgui.Create("DButton", frame)
	NoButton:SetPos(frame:GetWide() * 0.6, frame:GetTall() * 0.925)
	NoButton:SetSize(frame:GetWide() * 0.35, frame:GetTall() * 0.05)
	NoButton:SetText("")
	NoButton.Paint = function(s, w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
		draw.SimpleText(GReport.Config.Lang.NoButton, "gr_userpaneltitle", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1)

	end
	NoButton:TDLib():CircleHover()

end

net.Receive("gr_adminui", function()

	local reporttable = net.ReadTable()

	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrW() * 0.8, ScrH() * 0.8)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	frame:TDLib():FadeIn()
	frame.Paint = function(s, w, h)

	  draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
	  DrawBlur(frame, 5)
	  OutlinedBox(0, 0, w, h, 2, Color(0, 0, 0, 200))
	  draw.RoundedBox(0, 0, 0, w, h * 0.035, Color(0, 0, 0, 255))
	  draw.SimpleText(GReport.Config.Lang.AdminTitle, "gr_userpaneltitle", w * 0.005, h * 0.005, Color(255, 255, 255, 255), 0, 0)

	end

	local closethatshit = vgui.Create("DButton", frame)
	closethatshit:SetSize(frame:GetWide() * 0.02, frame:GetTall() * 0.035)
	closethatshit:SetPos(frame:GetWide() * 0.98, frame:GetTall() * 0)
	closethatshit:TDLib():CircleHover()
	closethatshit:SetText("")
	closethatshit.Paint = function(s, w, h)

	  draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))
	  draw.SimpleText("X", "gr_userpaneltitle", w / 2, h / 2, Color(255, 255, 255), 1, 1)

	end
	closethatshit.DoClick = function()

	  frame:Close()

	end

	local ReportPanel = vgui.Create("DScrollPanel", frame)
	ReportPanel:SetPos(0, frame:GetTall() * 0.035)
	ReportPanel:SetSize(frame:GetWide(), frame:GetTall() * 0.96)
	ReportPanel.Paint = function() end

	local ReportHeight = 0

	if(table.Count(reporttable) == 0) then

		local DLabel = ReportPanel:Add("DLabel")
	  DLabel:SetContentAlignment(8)
	  DLabel:Dock(FILL)
	  DLabel:SetSize(ReportPanel:GetWide(), ReportPanel:GetTall())
	  DLabel:DockMargin(0, ReportPanel:GetTall() * 0.05, 0, 0)
	  DLabel:SetFont("gr_userpaneltitle")
	  DLabel:SetText("No reports have been made!")

	else

	  for k,v in ipairs(reporttable) do

			-- show reports
			local DPanel = ReportPanel:Add("DPanel")
			DPanel:SetPos(0, ReportHeight)
			DPanel:SetSize(ReportPanel:GetWide(), ReportPanel:GetTall() * 0.03)
			DPanel.Paint = function(s, w, h)

				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))

			end

			local ReporterLabel = vgui.Create("DLabel", DPanel)
			ReporterLabel:SetPos(DPanel:GetWide() * 0.01, DPanel:GetTall() * 0.1)
			ReporterLabel:SetColor(Color(255, 255, 255, 255))
			ReporterLabel:SetFont("gr_adminpanelplayer")
			ReporterLabel:SetText("Reporter: " .. v.reporter:Nick())
			ReporterLabel:SetContentAlignment(8)
			ReporterLabel:SizeToContents()

			local ReportedLabel = vgui.Create("DLabel", DPanel)
			ReportedLabel:SetPos(DPanel:GetWide() * 0.25, DPanel:GetTall() * 0.1)
			ReportedLabel:SetColor(Color(255, 255, 255, 255))
			ReportedLabel:SetFont("gr_adminpanelplayer")
			ReportedLabel:SetText("Reported: " .. v.reported:Nick())
			ReportedLabel:SetContentAlignment(8)
			ReportedLabel:SizeToContents()

			local ReasonLabel = vgui.Create("DLabel", DPanel)
			ReasonLabel:SetPos(DPanel:GetWide() * 0.5, DPanel:GetTall() * 0.1)
			ReasonLabel:SetColor(Color(255, 255, 255, 255))
			ReasonLabel:SetFont("gr_adminpanelplayer")
			ReasonLabel:SetText("Reason: " .. v.reason)
			ReasonLabel:SetContentAlignment(8)
			ReasonLabel:SizeToContents()

			local ViewButton = vgui.Create("DButton", DPanel)
			ViewButton:SetSize(DPanel:GetWide() * 0.1, DPanel:GetTall())
			ViewButton:SetPos(DPanel:GetWide() * 0.9, DPanel:GetTall() * 0)
			ViewButton:TDLib():CircleHover()
			ViewButton:SetText("")
			ViewButton.Paint = function(s, w, h)

			  draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))
			  draw.SimpleText("View More", "gr_userpaneltitle", w / 2, h / 2, Color(255, 255, 255), 1, 1)

			end
			ViewButton.DoClick = function()

				MoreBox(v.reporter, v.reported, v.reason, v.description)

			end

			ReportHeight = ReportHeight + (ReportPanel:GetTall() * 0.04)

		end

	end

end)

function MoreBox(reporter, reported, reason, desc)

	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrW() * 0.5, ScrH() * 0.5)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	frame:TDLib():FadeIn()
	frame.Paint = function(s, w, h)

	  draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
	  DrawBlur(frame, 5)
	  OutlinedBox(0, 0, w, h, 2, Color(0, 0, 0, 200))
	  draw.RoundedBox(0, 0, 0, w, h * 0.035, Color(0, 0, 0, 255))
	  draw.SimpleText(GReport.Config.Lang.InfoTitle, "gr_infopaneltitle", w * 0.005, h * 0.005, Color(255, 255, 255, 255), 0, 0)

	end

	local closethatshit = vgui.Create("DButton", frame)
	closethatshit:SetSize(frame:GetWide() * 0.02, frame:GetTall() * 0.035)
	closethatshit:SetPos(frame:GetWide() * 0.98, frame:GetTall() * 0)
	closethatshit:TDLib():CircleHover()
	closethatshit:SetText("")
	closethatshit.Paint = function(s, w, h)

	  draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 200))
	  draw.SimpleText("X", "gr_userpaneltitle", w / 2, h / 2, Color(255, 255, 255), 1, 1)

	end
	closethatshit.DoClick = function()

	  frame:Close()

	end

	local ReportingAvatar = vgui.Create("DPanel", frame)
	ReportingAvatar:SetPos(frame:GetWide() * 0.05, frame:GetTall() * 0.1)
	ReportingAvatar:SetSize(frame:GetWide() * 0.1, frame:GetTall() * 0.18)
	ReportingAvatar:TDLib():ClearPaint()
	:CircleAvatar()
	:SetPlayer(reporter, 128)

	local ReportingAvatar = vgui.Create("DPanel", frame)
	ReportingAvatar:SetPos(frame:GetWide() * 0.85, frame:GetTall() * 0.1)
	ReportingAvatar:SetSize(frame:GetWide() * 0.1, frame:GetTall() * 0.18)
	ReportingAvatar:TDLib():ClearPaint()
	:CircleAvatar()
	:SetPlayer(reported, 128)

	local ReportingLabel = vgui.Create("DLabel", frame)
	ReportingLabel:SetPos(frame:GetWide() * 0.175, frame:GetTall() * 0.145)
	ReportingLabel:SetColor(Color(255, 255, 255, 255))
	ReportingLabel:SetFont("gr_userpaneltitle")
	ReportingLabel:SetText("Reporting Player: \n" .. reporter:Nick())
	ReportingLabel:SizeToContents()

	local ReportedLabel = vgui.Create("DLabel", frame)
	ReportedLabel:SetPos(frame:GetWide() * 0.175, frame:GetTall() * 0.145)
	ReportedLabel:SetColor(Color(255, 255, 255, 255))
	ReportedLabel:SetFont("gr_userpaneltitle")
	ReportedLabel:SetText("Reported Player:")
	ReportedLabel:SizeToContents()
	ReportedLabel:AlignRight(frame:GetWide() * 0.175)

	local ReportedLabel2 = vgui.Create("DLabel", frame)
	ReportedLabel2:SetPos(frame:GetWide() * 0.175, frame:GetTall() * 0.185)
	ReportedLabel2:SetColor(Color(255, 255, 255, 255))
	ReportedLabel2:SetFont("gr_userpaneltitle")
	ReportedLabel2:SetText(reported:Nick())
	ReportedLabel2:SizeToContents()
	ReportedLabel2:AlignRight(frame:GetWide() * 0.175)

	local Reason = vgui.Create("DLabel", frame)
	Reason:SetPos(frame:GetWide() * 0.05, frame:GetTall() * 0.3)
	Reason:SetColor(Color(255, 255, 255, 255))
	Reason:SetFont("gr_userpaneltitle")
	Reason:SetText("Reason: " .. reason)
	Reason:SizeToContents()

	local Descriptione = vgui.Create("RichText", frame)
	Descriptione:SetPos(frame:GetWide() * 0.05, frame:GetTall() * 0.35)
	Descriptione:SetSize(frame:GetWide() * 0.9, frame:GetTall() * 0.55)
	Descriptione.Paint = function(s, w, h)
	end
	Descriptione.PerformLayout = function()

		Descriptione:SetFGColor(Color(255, 255, 255))

	end
	Descriptione:AppendText(desc)
	Descriptione.Paint = function(s, w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))

	end

end
