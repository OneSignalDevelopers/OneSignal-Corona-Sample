print("CORONA: Start main.lua")

local json = require "json"
local composer = require "composer"
local OneSignal = require ("plugin.OneSignal")

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )

-- NOTIFICATION OPENED CALLBACK
-- This function gets called when the user opens a notification
function NotificationOpenedHandler(message, additionalData, isActive)
	-- Easy way to dump table to string, not necessary to access contents
	local additionalDataString = nil
	if (additionalData) then
		additionalDataString = json.encode( additionalData )
	end

	-- Print all of the handler params
	print("Corona Notification Opened!" ..
	"\nNotification Message: " .. tostring(message) ..
	"\nAdditional Date: " .. tostring(additionalDataString) ..
	"\nIs Active: " .. tostring(isActive))
end

-- IAM CLICK ACTION CALLBACK
-- This function gets called when the user clicks on an IAM element
function InAppMessagedClickHandler(actionTable)
	-- Print all of the handler params from the actionTable
	print("In App Message Clicked!" ..
			" Click Name: " .. tostring( actionTable['click_name'] ) ..
			" Click Url: " .. tostring( actionTable['click_url'] )  ..
			" First Click: " .. tostring( actionTable['first_click'] ) ..
			" Closes Message: " .. tostring( actionTable['closes_message'] ))
end

-- GET TRIGGER VALUE FOR KEY CALLBACK
-- After the trigger value for an trigger key is received it is provided here with the corresponding key
function GetTriggerValueForKeyHandler(key, value)
	-- Print the key, value pair from obtaining the trigger value
	print("Obtained Trigger Value for Key!" ..
			"Trigger Key, Value: " .. tostring( key ) .. ", " .. tostring( value ))
end

-- IAM PUBLIC METHODS
-- Example showcase of IAM methods for public usage in Corona
function ExampleInAppMessagingMethods()
	-- Toggle showing of IAMs for the device
	OneSignal.PauseInAppMessages(false)

	-- Adding a single trigger, value pair or several at a time with a table
	OneSignal.AddTrigger("trigger_1", "one")
	local triggerTable = { ["trigger_2"] = "two", ["trigger_3"] = "three", ["trigger_4"] = "four" }
	OneSignal.AddTriggers(triggerTable)

	-- Removing a single trigger by key or removing several at a time with a table
	OneSignal.RemoveTriggerForKey("trigger_4")
	local removeTriggers = {"trigger_1", "trigger_2"}
	OneSignal.RemoveTriggersForKeys(removeTriggers)

	-- Getting a trigger's value by key and returning the key, value in a callback
	OneSignal.GetTriggerValueForKey("trigger_2", GetTriggerValueForKeyHandler)
	OneSignal.GetTriggerValueForKey("trigger_3", GetTriggerValueForKeyHandler)
end

-- START OF LUA SCRIPT
-- Replace with your AppId
OneSignal.Init("5eb5a37e-b458-11e3-ac11-000c2940e62c", "714322744251", NotificationOpenedHandler)
OneSignal.SetInAppMessageClickHandler(InAppMessagedClickHandler)
ExampleInAppMessagingMethods()

-- Go to view1 scene
composer.gotoScene( "view1" )
