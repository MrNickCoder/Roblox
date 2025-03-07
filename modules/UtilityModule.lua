local Utility = {
	Threads = {},
	AllIDs = {},
	FoundAnything = "",
	ActualHour = os.date("!*t").hour,
}
do
	function Utility:Instance(Name, Data)
		local Object = Instance.new(Name, Data.Parent);
		for Index, Value in next, Data do
			if Index ~= "Parent" then
				if typeof(Value) == "Instance" then Value.Parent = Object;
				else Object[Index] = Value; end
			end
		end
		return Object;
	end
	
	function Utility:Comma_Value(Text:string)
		local Value = Text;
		while true do
			local Str, Num = string.gsub(Value, "^(-?%d+)(%d%d%d)", "%1,%2");
			Value = Str
			if Num ~= 0 then else break end
		end
		return Value
	end

	function Utility:Combine_Table(...:{any})
		local newTable = {}
		for _, v in ipairs({...}) do
			for i, x in ipairs(v) do
				table.insert(newTable, x)
			end
		end
		return newTable
	end
	
	function Utility:Length(Table:{any})
		local Counter = 0
		for _, v in pairs(Table) do Counter += 1; end
		return Counter
	end

	function Utility:Show(UIObjects:{GuiObject}, Visible:boolean)
		for Index, Value in pairs(UIObjects) do
			Value.Visible = Visible
		end
	end
	
	function Utility:SaveConfig(Config:{any}, Directory:string, File:string)
		local HttpService = game:GetService("HttpService")
		if not isfolder(Directory) then
			local Folders = Directory:split("/")
			local tempDirectory = Folders[1]
			for _, folder in pairs(Folders) do
				if folder == tempDirectory then makefolder(folder); continue; end
				tempDirectory = tempDirectory .. "/" .. folder
				makefolder(tempDirectory)
			end
		end

		writefile(Directory .. "/" .. File, HttpService:JSONEncode(Config))
		return self:LoadConfig(Config, Directory, File)
	end

	function Utility:LoadConfig(Config:{any}, Directory:string, File:string)
		local Success, Response = pcall(function()
			local HttpService = game:GetService("HttpService")
			if not isfolder(Directory) then
				local Folders = Directory:split("/")
				local tempDirectory = Folders[1]
				for _, folder in pairs(Folders) do
					if folder == tempDirectory then makefolder(folder); continue; end
					tempDirectory = tempDirectory .. "/" .. folder
					makefolder(tempDirectory)
				end
			end

			return HttpService:JSONDecode(readfile(Directory .. "/" .. File))
		end)

		if Success then return Response
		else return self:SaveConfig(Config, Directory, File) end
	end

	function Utility:GetFiles(Directory:string)
		if not isfolder(Directory) then makefolder(Directory) end
		return listfiles(Directory)
	end
	
	function Utility:Thread(ID:string, Callback)
		local Thread = coroutine.create(Callback)
		self.Threads[ID] = Thread

		return setmetatable({
			ID = ID,
			Thread = Thread,
			Start = function() coroutine.resume(Thread); end,
			Stop = function() coroutine.close(Thread); end,
			Status = function() return coroutine.status(Thread) end,
		}, {})
	end

	function Utility:StopAllThreads()
		for i, v in pairs(self.Threads) do
			if coroutine.status(v) == "running" then
				coroutine.close(v)
			end
			self.Threads = {}
		end
	end

	function Utility:Teleporter(PlaceID)
		local Deleted = false
    	local Last
		local ServerFile = pcall(function() Utility.AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json")) end)
		if not ServerFile then
			table.insert(Utility.AllIDs, Utility.ActualHour)
			writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(Utility.AllIDs))
		end

		local Site;
		if Utility.FoundAnything == "" then
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. Utility.FoundAnything))
		end

		local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
			Utility.FoundAnything = Site.nextPageCursor
		end

		local Num = 0;
        local ExtraNum = 0
		for Index, Server in pairs(Site.data) do
            ExtraNum += 1
            local Possible = true
            ID = tostring(Server.id)
            if tonumber(Server.maxPlayers) > tonumber(Server.playing) then
                if ExtraNum ~= 1 and tonumber(Server.playing) < Last or ExtraNum == 1 then Last = tonumber(Server.playing)
                elseif ExtraNum ~= 1 then continue end

                for _, Existing in pairs(Utility.AllIDs) do
                    if Num ~= 0 then
                        if ID == tostring(Existing) then Possible = false end
                    else
                        if tonumber(Utility.ActualHour) ~= tonumber(Existing) then
                            local delFile = pcall(function()
                                delfile("NotSameServers.json")
                                AllIDs = {}
                                table.insert(Utility.AllIDs, Utility.ActualHour)
                            end)
                        end
                    end
                    Num = Num + 1
                end
                if Possible == true then
                    table.insert(Utility.AllIDs, ID)
                    task.wait()
                    pcall(function()
                        writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(Utility.AllIDs))
                        task.wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    task.wait(4)
                end
            end
        end
	end

end

return Utility
