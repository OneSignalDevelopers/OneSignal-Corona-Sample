local widget = require( "widget" )

print("START!")

-- This function gets called when the user opens a notification or one is received when the app is open and active.
-- Change the code below to fit your app's needs.
function DidReceiveRemoteNotification(message, additionalData, isActive)
    if (additionalData) then
        if (additionalData.discount) then
            native.showAlert( "Discount!", message, { "OK" } )
            -- Take user to your app store
        elseif (additionalData.actionSelected) then -- Interactive notification button pressed
            native.showAlert("Button Pressed!", "ButtonID:" .. additionalData.actionSelected, { "OK"} )
        end
    else
        native.showAlert("OneSignal Message", message, { "OK" } )
    end
end

local OneSignal = require("plugin.OneSignal")

-- Will show popup dialogs when the device registers with Apple/Google and with OneSignal.
-- Errors will be shown as popups too if there are any issues.
-- The logging levels are as follows: 0 = None, 1 = Errors, 2 = Warnings, 3 = Info, 4 = Debug, 5 = Verbose
-- OneSignal.SetLogLevel(4, 4)

OneSignal.Init("b2f7f966-d8cc-11e4-bed1-df8f05be55ba", "703322744261", DidReceiveRemoteNotification)

-- START: Tags button
local buttonHandlerSendTags = function( event )
	OneSignal.SendTag("CoronaTag1", "value1")
	OneSignal.SendTags({["CoronaTag2"] = "value2",["CoronaTag3"] = "value3"})
end

local tagsButton = widget.newButton
{
	id = "SendTags",
	defaultFile = "buttonGray.png",
	overFile = "buttonWhite.png",
	label = "Send Tags",
	font = native.systemFont,
	labelColor =  { default={ 1, 1, 1 }},
	fontSize = 28,
	emboss = true,
	onPress = buttonHandlerSendTags,
}
tagsButton.x = 160; tagsButton.y = 100
-- END: Tags button


-- START: Get Ids button

function IdsAvailable(userID, pushToken)
    print("userId:" .. userId)
    if (pushToken) then -- nil if there was a connection issue or on iOS notification permissions were not accepted.
        print("pushToken:" .. pushToken)
    end
    
    native.showAlert("Ids", "userId: " .. userID .. "\n\n" .. "pushToken: " .. (pushToken or "nil"), {"Ok"});
end

local buttonHandlerGetIds = function( event )
	OneSignal.IdsAvailableCallback(IdsAvailable)
end

local getIdsButton = widget.newButton
{
	id = "GetIds",
	defaultFile = "buttonGray.png",
	overFile = "buttonWhite.png",
	label = "Get Ids",
	font = native.systemFont,
	labelColor =  { default={ 1, 1, 1 }},
	fontSize = 28,
	emboss = true,
	onPress = buttonHandlerGetIds,
}
getIdsButton.x = 160; getIdsButton.y = 200
-- END: Get Ids button

