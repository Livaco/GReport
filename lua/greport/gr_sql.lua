function GReport.CheckSQLTables()
    if(sql.TableExists("greport_reports")) then
        GReport.Print("SQL Table exists. Continuing.")
    else
        GReport.Print("Creating SQL Table.")
        local Query = sql.Query("CREATE TABLE greport_reports(ID INTEGER PRIMARY KEY AUTOINCREMENT, Reporter TEXT, Reported TEXT, Reason TEXT, Description TEXT);")
        if(Query != false) then
            GReport.Print("Table created.")
        else
            GReport.Print("Table was not created. Restart your server so it can try again!!!!!!!")
        end
    end
end

function GReport.SQLStore(Reporter, Reported, Reason, Description)
    local Query = sql.Query("INSERT INTO greport_reports(Reporter, Reported, Reason, Description) VALUES("..sql.SQLStr(util.TableToJSON(Reporter))..", "..sql.SQLStr(util.TableToJSON(Reported))..", "..sql.SQLStr(Reason)..", "..sql.SQLStr(Description)..");")
    if(Query == false) then
        GReport.Print("Error while inserting that last report that came through. SQL:")
        GReport.Print("INSERT INTO greport_reports(Reporter, Reported, Reason, Description) VALUES("..sql.SQLStr(util.TableToJSON(Reporter))..", "..sql.SQLStr(util.TableToJSON(Reported))..", "..sql.SQLStr(Reason)..", "..sql.SQLStr(Description)..");")
    end
end

function GReport.GetSQLReports()
    local Query = sql.Query("SELECT * FROM greport_reports ORDER BY ID ASC")
    if(Query != false) then
        return Query
    else
        GReport.Print("Error while selecting reports from SQL. Returning nothing.")
    end
end