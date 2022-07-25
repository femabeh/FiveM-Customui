ESX = nil

CreateThread(function()
	while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end
	while ESX.GetPlayerData().job == nil do Wait(100) end
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
  PlayerLoaded = true
	if Config.ui.showID then
		local playerID = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))).." | PLZ: "..exports.nearest_postal:getPostal()
		SendNUIMessage({action = "setValue", key = "id", value = playerID})
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local shouldshow = true
local showhud = true

Citizen.CreateThread(function()
	if Config.ui.mapcommand == true then
		RegisterCommand('showmap', function(source, args)
			DisplayRadar(true)
		end,false)

		RegisterCommand('hidemap', function()
			DisplayRadar(false)
		end,false)
	end
end)

RegisterCommand('showhud', function(source, args)
	showhud = true
end,false)

RegisterCommand('hidehud', function()
	showhud = false
end,false)

Citizen.CreateThread(function()
	while Config.ui.actpausemenu do
		Citizen.Wait(0)
		if IsPauseMenuActive() then
			showhud = false
		elseif not IsPauseMenuActive() then
			showhud = true
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if showhud == false then
			TriggerEvent('customui:toggle', false)
		elseif shouldshow == true then
			TriggerEvent('customui:toggle', true)
		end
	end
end)

RegisterNetEvent('customui:toggle')
AddEventHandler('customui:toggle', function(show)
	SendNUIMessage({action = "toggle", show = show})
end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(100)
	
		local playerStatus
		local showPlayerStatus = 0
		playerStatus = { action = 'setStatus', status = {} }

		TriggerEvent('esx:getSharedObject', function(obj)
			ESX = obj
			ESX.PlayerData = ESX.GetPlayerData()
  		end)

		if Config.ui.showID then
			local playerID = "ID: "..GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))).." | PLZ: "..exports.nearest_postal:getPostal()
			SendNUIMessage({action = "setValue", key = "id", value = playerID})
		end


		if ESX.PlayerData.job then
			local job
			local blackMoney
			local bank
			local money

			if ESX.PlayerData.job.label == ESX.PlayerData.job.grade_label then
				job = ESX.PlayerData.job.grade_label
			else
				job = ESX.PlayerData.job.label .. ' - ' .. ESX.PlayerData.job.grade_label
			end


			for i=1, #ESX.PlayerData.accounts, 1 do
				if ESX.PlayerData.accounts[i].name == 'money' then
					money = ESX.PlayerData.accounts[i].money
				end
			end

			SendNUIMessage({action = "setValue", key = "job", value = job})
			SendNUIMessage({action = "setValue", key = "money", value = money.." €"})

			local playerStatus
			local showPlayerStatus = 0

			if Config.ui.showHunger then
				TriggerEvent('esx_status:getStatus', 'hunger', function(status)
					SendNUIMessage({action = "setValue", key = "hunger", value = Round(status.getPercent())})
				end)
			end

			if Config.ui.showThirst then
				TriggerEvent('esx_status:getStatus', 'thirst', function(status)
					SendNUIMessage({action = "setValue", key = "water", value = Round(status.getPercent())})
				end)
			end
		end
  	end
end)
