local Webhook = {}

do
	Webhook.__index = Webhook

	function Webhook.new(Content, Username, Avatar)
		local Message = {
			["content"] = Content or "",
			["username"] = Username or "",
			["avatar_url"] = Avatar or "",
		}

		return setmetatable({Message = Message}, Webhook)
	end

	function Webhook:Content(Content)
		self.Message["content"] = Content
	end

	function Webhook:Embed()
		
	end

	function Webhook:Send(WebhookURLs)
		local WBody = game:GetService("HttpService"):JSONEncode(self.Message)
		local WHeaders = {["content-type"] = "application/json"}

		if typeof(WebhookURLs) == "table" then
			for _, url in pairs(WebhookURLs) do
				local WRequest = http_request or request or HttpPost or syn.request or http.request
				local WHook = {Url = url, Body = WBody, Method = "POST", Headers = WHeaders}
				warn("Sending webhook notification...")
				WRequest(WHook)
			end
		else
			local WRequest = http_request or request or HttpPost or syn.request or http.request
			local WHook = {Url = WebhookURLs, Body = WBody, Method = "POST", Headers = WHeaders}
			warn("Sending webhook notification...")
			WRequest(WHook)
		end
	end
end

return Webhook
