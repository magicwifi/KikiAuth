--[[
LuCI - Lua Configuration Interface

Copyright 2008 Nguyen Khac Duy <nkduy2010@gmail.com>
Copyright 2008 Nguyen Hong Quan <ng.hong.quan@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

]]--
module("luci.controller.kikiauth.authserver", package.seeall)

function index()
    entry({"kikiauth", "ping"}, call("action_say_pong"), "Click here", 10).dependent=false
    entry({"kikiauth", "auth"}, call("action_auth_response_to_gw"), "", 20).dependent=false
    entry({"kikiauth", "portal"}, call("action_redirect_to_success_page"), "Success page", 30).dependent=false
    entry({"kikiauth", "login"}, template("kikiauth/login"), "Login page", 40).dependent=false
    entry({"kikiauth", "oauth", "googlecallback"}, template("kikiauth/googlecallback"), "", 50).dependent=false
    entry({"kikiauth", "oauth", "facebookcallback"}, template("kikiauth/facebookcallback"), "", 60).dependent=false
end

function action_say_pong()
    luci.http.prepare_content("text/plain")
    luci.http.write("Pong")
end

function action_redirect_to_success_page()
    luci.http.redirect("http://mbm.vn")
end

function action_auth_response_to_gw()
	local token = luci.http.formvalue("token")
	local url = "https://graph.facebook.com/me?access_token=%s" % {token}
	local response
	local wget = assert(io.popen("wget --no-check-certificate -qO- %s" % {url}))
	if wget then
		response = wget:read("*all")
		wget:close()
	end

	--[[
	local logfile = "/var/log/luciaa.log"
	if nixio.fs.access(logfile) then
		local dd = os.date('%Y/%m/%d')
		local data = "%s: %s \n" % {dd, url}
		data = data .. "1: " .. l .. "\n"
		local wget = assert(io.popen("wget --no-check-certificate -O- %s" % {url}))
	    if wget then
			data = data .. "2: " .. wget:read("*all")
			wget:close()
		end
		nixio.fs.writefile(logfile, data)
	end
	]]--

	if response then
		luci.http.write("Auth: 1")
	else
		luci.http.write("Auth: 6")
	end
end