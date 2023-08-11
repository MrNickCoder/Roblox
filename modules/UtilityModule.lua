local Utility = {}
do
	
	function Utility:Comma_Value(Text)
		local Value = Text;
		while true do
			local Str, Num = string.gsub(Value, "^(-?%d+)(%d%d%d)", "%1,%2");
			Value = Str
			if Num ~= 0 then else break end
		end
		return Value
	end
	
	function Utility:Show(UIObjects, Visible)
		for Index, Value in pairs(UIObjects) do
			Value.Visible = Visible
		end
	end
	
	function Utility:SaveConfig(Config, Directory, File)
		local HttpService = game:GetService("HttpService")
		if not isfolder(Directory) then makefolder(Directory) end

		writefile(Directory .. "/" .. File, HttpService:JSONEncode(Config))
		return Utility:LoadConfig(Config, Directory, File)
	end

	function Utility:LoadConfig(Config, Directory, File)
		local Success, Response = pcall(function()
			local HttpService = game:GetService("HttpService")
			if not isfolder(Directory) then makefolder(Directory) end

			return HttpService:JSONDecode(readfile(Directory .. "/" .. File))
		end)

		if Success then return Response
		else return Utility:SaveConfig(Config, Directory, File) end
	end
	
end

return Utility
