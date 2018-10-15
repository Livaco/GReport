net.Receive("gr_message", function() -- Just so i can send messages from serverside

  local msg = net.ReadString()
  chat.AddText(GReport.Config.PrefixColor, GReport.Config.Prefix, Color(255, 255, 255), " ", msg)

end)
