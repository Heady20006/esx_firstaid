ADD THIS TO esx_ambulancejob/client/main.lua

RegisterNetEvent('esx_ambulancejob:receiveReset')
AddEventHandler('esx_ambulancejob:receiveReset', function(state, addTime)
	if state then
		bleedoutTimer = bleedoutTimer + addTime
	end
end)