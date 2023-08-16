local HttpService = game:GetService("HttpService")

local Webhook = {}
local Embed = {}
local Field = {}

-----------------------
----- [ Webhook ] -----
-----------------------
do
	Webhook.__index = Webhook
	Webhook.__tostring = function(self)
		local Data = {}
		Data["content"] = self["content"]

		if self["username"] ~= "" then Data["username"] = self["username"] end
		if self["avatar_url"] ~= "" then Data["avatar_url"] = self["avatar_url"] end
		if #self["embeds"] > 0 then
			Data["embeds"] = {}
			for i = 1, #self["embeds"] do
				Data["embeds"][i] = HttpService:JSONDecode(tostring(self["embeds"][i]))
			end
		end

		return HttpService:JSONEncode(Data)
	end

	function Webhook.new(content, username, avatar_url)
		local Data = {
			["avatar_url"] = avatar_url or "",
			["username"] = username or "",
			["content"] = content or "",
			["embeds"] = {},
		}
		return setmetatable(Data, Webhook)
	end

	-----------------------
	----- [ Methods ] -----
	-----------------------
	function Webhook:Append(text)
		local temp = self["content"] .. text
		if #temp > 2000 then
			warn('Message body cannot exceed 2000 characters')
			return
		end
		self["content"] = temp
	end

	function Webhook:AppendLine(text)
		self:Append(text .. "\n")
	end

	function Webhook:SetUsername(username)
		self["username"] = username
	end

	function Webhook:SetAvatarUrl(url)
		self["avatar_url"] = url
	end

	function Webhook:NewEmbed(...)
		local embed = Embed.new(...)
		self["embeds"][#self["embeds"]+1] = embed
		return embed
	end

	function Webhook:CountEmbeds()
		return #self["embeds"]
	end

	function Webhook:Send(url)
		local headers = { ["content-type"] = "application/json" }

		if typeof(url) == "string" then
			local request = http_request or request or HttpPost or syn.request or http.request
			local hook = { Url = url; Body = tostring(self); Method = "POST"; Headers = headers }
			warn("Sending webhook notification...")
			request(hook)
		elseif typeof(url) == "table" then
			for _, uri in pairs(url) do
				local request = http_request or request or HttpPost or syn.request or http.request
				local hook = { Url = uri; Body = tostring(self); Method = "POST"; Headers = headers }
				warn("Sending webhook notification...")
				request(hook)
			end
		else
			local request = http_request or request or HttpPost or syn.request or http.request
			local hook = { Url = url; Body = tostring(self); Method = "POST"; Headers = headers }
			warn("Sending webhook notification...")
			request(hook)
		end
	end
end

----------------------
----- [ Embeds ] -----
----------------------
do
	Embed.__index = Embed
	Embed.__tostring = function(self)
		local Data = {}

		if self["title"] ~= "" then Data["title"] = self["title"] end
		if self["description"] ~= "" then Data["description"] = self["description"] end
		if Data["color"] ~= 0 then Data["color"] = self["color"] end
		if self["url"] ~= "" then Data["url"] = self["url"] end
		if self["timestamp"] ~= 0 then Data["timestamp"] = self["timestamp"] end
		if self["footer"]["text"] ~= "" or self["footer"]["icon_url"] ~= "" then
			Data["footer"] = {
				["text"] = self["footer"]["text"];
				["icon_url"] = self["footer"]["icon_url"];
			}
		end
		if self["image"]  ~= "" then
			Data["image"] = {
				["url"] = self["image"]
			}
		end
		if self["thumbnail"] ~= "" then
			Data["thumbnail"] = {
				["url"] = self["thumbnail"]
			}
		end
		if self["author"]["name"] ~= "" then
			Data["author"] = {
				["name"] = self["author"]["name"],
				["url"] = self["author"]["url"],
				["icon_url"] = self["author"]["icon_url"]
			}
		end
		if #self["fields"] > 0 then
			Data["fields"] = {}
			for i = 1, #self["fields"] do
				Data["fields"][i] = HttpService:JSONDecode(tostring(self["fields"][i]))
			end
		end

		return HttpService:JSONEncode(Data)
	end

	function Embed.new(title, description)
		local Data = {
			["title"] = title or "";
			["description"] = description or "";
			["url"] = "";
			["timestamp"] = 0;
			["color"] = 0;
			["footer"] = { ["text"] = ""; ["icon_url"] = ""; };
			["image"] = "";
			["thumbnail"] = "";
			["author"] = { ["name"] = ""; ["url"] = ""; ["icon_url"] = ""; };
			["fields"] = {};
		}
		return setmetatable(Data, Embed)
	end

	-----------------------
	----- [ Methods ] -----
	-----------------------
	function Embed:SetTitle(title)
		if #title > 256 then
			warn('Title cannot exceed 256 characters')
			return
		end
		self["title"] = title
	end

	function Embed:Append(text)
		local temp = self["description"] .. text
		if #temp > 2048 then
			warn('Append description cannot exceed 2048 characters')
			return
		end
		self["description"] = temp
	end

	function Embed:AppendLine(text)
		self:Append(text .. "\n")
	end

	function Embed:SetURL(url)
		self["url"] = url
	end

	function Embed:SetTimestamp(epoch)
		if epoch == nil then epoch = tick() end
		local temp = os.date('!*t', epoch)
		self["timestamp"] = 
			temp["year"] .. '-' 
			.. string.format("%02d", temp["month"]) .. '-'
			.. string.format("%02d", temp["day"]) .. 'T'
			.. string.format("%02d", temp["hour"]) .. ':'
			.. string.format("%02d", temp["min"]) .. ':'
			.. string.format("%02d", temp["sec"]) .. 'Z'
	end

	function Embed:SetColor3(color)
		local value = bit32.lshift(math.floor(color["r"] * 255 + 0.5), 8)
		value = bit32.lshift(math.floor(color["g"] * 255 + 0.5) + value, 8)
		value = value + math.floor(color["b"] * 255 + 0.5)
		self["color"] = value
	end

	function Embed:AppendFooter(text)
		local temp = self["footer"]["text"] .. text
		if #temp > 2048 then
			warn('Append footer cannot exceed 2048 characters')
			return
		end
		self["footer"]["text"] = temp
	end

	function Embed:AppendFooterLine(text)
		self:AppendFooter(text .. "\n")
	end

	function Embed:SetFooterIconURL(url)
		self["footer"]["icon_url"] = url
	end

	function Embed:SetImageURL(url)
		self["image"] = url
	end

	function Embed:SetThumbnailIconURL(url)
		self["thumbnail"] = url
	end

	function Embed:SetAuthorName(name)
		if #name > 256 then
			warn('Author name cannot exceed 256 characters')
		end
		self["author"]["name"] = name
	end

	function Embed:SetAuthorURL(url)
		self["author"]["url"] = url
	end

	function Embed:SetAuthorIconURL(url)
		self["author"]["icon_url"] = url
	end

	function Embed:NewField(...)
		local field = Field.new(...)
		self["fields"][#self["fields"]+1] = field
		return field
	end

	function Embed:CountFields()
		return #self["fields"]
	end

end

---------------------
----- [ Field ] -----
---------------------
do
	Field.__index = Field
	Field.__tostring = function(self)
		return HttpService:JSONEncode({
			["name"] = self["name"];
			["value"] = self["value"];
			["inline"] = self["inline"];
		})
	end

	function Field.new(name, value, inline)
		local Data = {
			["name"] = name or "";
			["value"] = value or "";
			["inline"] = inline or false;
		}
		return setmetatable(Data, Field)
	end

	-----------------------
	----- [ Methods ] -----
	-----------------------
	function Field:SetName(name)
		if #name > 256 then
			warn('Name must not exceed 256 characters')
			return
		end
		self["name"] = name
	end

	function Field:Append(text)
		local temp = self["value"] .. text
		if #temp > 1024 then
			warn('Field content cannot exceed 1024 characters')
			return
		end
		self["value"] = temp
	end

	function Field:AppendLine(text)
		self:Append(text .. "\n")
	end

	function Field:SetIsInLine(inline)
		self["inline"] = inline
	end

end

return Webhook
