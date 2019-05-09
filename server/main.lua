ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('esx_firstaid:sendReset')
AddEventHandler('esx_firstaid:sendReset', function(target, addTime)
	TriggerClientEvent('esx_ambulancejob:receiveReset', target, true, addTime)
end)

ESX.RegisterServerCallback('esx_firstaid:getLicense', function (source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier,
	}, function (result)
		for k,v in pairs(result) do
			if v.type == 'firstaidcourse' then
				cb(true)
			end
		end
	end)
end)

ESX.RegisterUsableItem('firstaidpass', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner AND `type` = @type', {
		['@owner'] = xPlayer.identifier,
		['@type'] = 'firstaidcourse',
	}, function (result)
		if result[1] == nil then
			MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
				['@type']  = 'firstaidcourse',
				['@owner'] = xPlayer.identifier
			}, function(rowsChanged)

			end)
		end
	end)
end)