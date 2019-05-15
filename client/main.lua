Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local alreadFirstaid = false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.firstaidWait)
		alreadFirstaid = false
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		local closestPlayerPed = GetPlayerPed(closestPlayer)
		if IsPedDeadOrDying(closestPlayerPed, 1) and closestDistance < 1.3 then
			if IsControlJustReleased(0, Keys['E']) then		
				ESX.TriggerServerCallback('esx_firstaid:getLicense', function(license)
					if license then
						if not alreadFirstaid then
							alreadFirstaid = true
							local playerPed = PlayerPedId()
							ESX.ShowNotification(_U('first_inprogress'))
							local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
							for i=1, Config.pumpTime, 1 do
								Citizen.Wait(900)
								ESX.Streaming.RequestAnimDict(lib, function()
									TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
								end)
							end
							ESX.ShowNotification(_U('done_firstaid'))
							TriggerServerEvent('esx_firstaid:sendReset', GetPlayerServerId(closestPlayer), Config.addTime)
						else
							ESX.ShowNotification(_U('already_firstaid'))
						end
					else
						ESX.ShowNotification(_U('no_license'))
					end
				end)
			end
		end
	end
end)