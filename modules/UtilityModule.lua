local Threads = {}

local ThreadMethods = {}
do
	function ThreadMethods.new(ID, Callback)
		local Thread = coroutine.create(Callback)

		return setmetatable({
			ID = ID,
			Thread = Thread,
		}, ThreadMethods)
	end
	function ThreadMethods:Start() coroutine.resume(self.Thread); Threads[self.ID] = self.Thread end
	function ThreadMethods:Stop() coroutine.close(self.Thread); Threads[self.ID] = nil end
	function ThreadMethods:Status() return coroutine.status(self.Thread) end
end

local Utility = {}
do
	
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
	
	function Utility:Show(UIObjects:{GuiObject}, Visible:boolean)
		for Index, Value in pairs(UIObjects) do
			Value.Visible = Visible
		end
	end
	
	function Utility:SaveConfig(Config:{any}, Directory:string, File:string)
		local HttpService = game:GetService("HttpService")
		if not isfolder(Directory) then makefolder(Directory) end

		writefile(Directory .. "/" .. File, HttpService:JSONEncode(Config))
		return Utility:LoadConfig(Config, Directory, File)
	end

	function Utility:LoadConfig(Config:{any}, Directory:string, File:string)
		local Success, Response = pcall(function()
			local HttpService = game:GetService("HttpService")
			if not isfolder(Directory) then makefolder(Directory) end

			return HttpService:JSONDecode(readfile(Directory .. "/" .. File))
		end)

		if Success then return Response
		else return Utility:SaveConfig(Config, Directory, File) end
	end
	
	function Utility:Thread(...) return ThreadMethods.new(...) end

	function Utility:StopAllThreads()
		for _, v in pairs(Threads) do
			if v:Status() == "running" then v:Stop() end
		end
	end
end

return Utility
