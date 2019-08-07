local json = require( "json" )
local native = require( "native" )
local widget = require( "widget" )
local composer = require( "composer" )
local OneSignal = require( "plugin.OneSignal" )

local scene = composer.newScene()

function GetYSpacingFromButton( button, padding )
	return button.y + button.height + padding
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- create a white background to fill screen
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 1 )	-- white

	local textOptions = {
			text = "",
			width = 280,
			fontSize = 14,
			align = "left"  -- Alignment parameter
	}
	local textBox = display.newText( textOptions )
	textBox.anchorX = 0
	textBox.anchorY = 0
	textBox.x = 24;
	textBox:setFillColor( 0, 0, 0 )

	-- Send tags event handler
	local buttonHandlerSendTags = function( event )
		-- Send a single tag in key, value fashion
		OneSignal.SendTag( "CoronaTag1", "value1" )

		-- Send several tags at once using a table
		local tagsTable = {["CoronaTag2"] = "value2", ["CoronaTag3"] = "value3"}
		OneSignal.SendTags( tagsTable )

		textBox.text = "Sent tags\nCoronaTag1, value1\n['CoronaTag2'] = 'value2', ['CoronaTag3'] = 'value3'"
	end

	local getTagsCallback = function ( tags )
		local tagsString = json.encode(tags);
		textBox.text = tagsString
		print("TAGS: " .. tagsString)
	end

	local buttonHandlerGetTags = function( event )
		-- Send a single tag in key, value fashion
		OneSignal.GetTags( getTagsCallback )
	end

	-- START: OneSignal Logo
	-- Create a vector rectangle
	local oneSignalLogo = display.newRect( 0, 0, 140, 140 )
	-- Set the fill (paint) to use the bitmap image
	local oneSignalLogoPaint = {
		type = "image",
		filename = "onesignal.png"
	}
	-- Fill the circle
	oneSignalLogo.fill = oneSignalLogoPaint
	oneSignalLogo.x = display.contentCenterX; oneSignalLogo.y = 80;
	-- END: OneSignal Logo

		-- START: Send tags button
	local sendTagsButton = widget.newButton(
	    {
				label = "Send Tags",
				emboss = true,
				shape = "roundedRect",
				width = 280,
				height = 40,
				cornerRadius = 4,
				fillColor = { default={ 0.9, 0.3, 0.3, 1 }, over={ 0.8, 0.3, 0.3, 1 } },
				strokeColor = { default={ 0.9, 0.3, 0.3, 1 }, over={ 0.8, 0.3, 0.3, 1 } },
				strokeWidth = 0,
				labelColor = { default={ 1, 1, 1, 1 }, over={ 1, 1, 1, 1 } }
	    }
	)
	sendTagsButton:addEventListener( "tap", buttonHandlerSendTags )
	sendTagsButton.x = display.contentCenterX; sendTagsButton.y = oneSignalLogo.y + 88;
	-- END: Send tags button

	-- START: Get tags button
	local getTagsButton = widget.newButton(
	    {
				label = "Get Tags",
				emboss = true,
				shape = "roundedRect",
				width = 280,
				height = 40,
				cornerRadius = 4,
				fillColor = { default={ 0.9, 0.3, 0.3, 1 }, over={ 0.8, 0.3, 0.3, 1 } },
				strokeColor = { default={ 0.9, 0.3, 0.3, 1 }, over={ 0.8, 0.3, 0.3, 1 } },
				strokeWidth = 0,
				labelColor = { default={ 1, 1, 1, 1 }, over={ 1, 1, 1, 1 } }
	    }
	)
	getTagsButton:addEventListener( "tap", buttonHandlerGetTags )
	getTagsButton.x = display.contentCenterX; getTagsButton.y = GetYSpacingFromButton(sendTagsButton, 12);
	-- END: Get tags button

	-- START: Add trigger key text field
	local addTriggerKeyTextField = native.newTextField( 24, 0, 130, 30 )
	addTriggerKeyTextField.anchorX = 0
	addTriggerKeyTextField.text = "key"
	addTriggerKeyTextField.size = 16
	addTriggerKeyTextField.y = GetYSpacingFromButton(getTagsButton, 12);
	addTriggerKeyTextField:resizeHeightToFitFont()
	-- END: Add trigger key text field

	-- START: Add trigger value text field
	local addTriggerValueTextField = native.newTextField( 0, 0, 130, 30 )
	addTriggerValueTextField.anchorX = 0
	addTriggerValueTextField.text = "value"
	addTriggerValueTextField.size = 16
	addTriggerValueTextField.x = addTriggerKeyTextField.width + 38
	addTriggerValueTextField.y = GetYSpacingFromButton(getTagsButton, 12);
	addTriggerValueTextField:resizeHeightToFitFont()
	-- END: Add trigger value text field

	local buttonHandlerAddTrigger = function( event )
		-- Add a trigger in key, value fashion
		OneSignal.AddTrigger( addTriggerKeyTextField.text, addTriggerValueTextField.text )
		local addTriggerString = "Adding Trigger Key: " .. addTriggerKeyTextField.text .. " Value: " .. addTriggerValueTextField.text
		textBox.text = addTriggerString
		print(addTriggerString)
	end

	-- START: Add trigger button
	local addTriggerButton = widget.newButton(
		{
			label = "Add Trigger",
			emboss = true,
			shape = "roundedRect",
			width = 280,
			height = 40,
			cornerRadius = 4,
			fillColor = { default={ 0.9, 0.3, 0.3, 1 }, over={ 0.8, 0.3, 0.3, 1 } },
			strokeColor = { default={ 0.9, 0.3, 0.3, 1 }, over={ 0.8, 0.3, 0.3, 1 } },
			strokeWidth = 0,
			labelColor = { default={ 1, 1, 1, 1 }, over={ 1, 1, 1, 1 } }
		}
	)
	addTriggerButton:addEventListener( "tap", buttonHandlerAddTrigger )
	addTriggerButton.x = display.contentCenterX; addTriggerButton.y = GetYSpacingFromButton(addTriggerKeyTextField, 12);
	-- END: Add trigger button

	-- START: Add trigger key text field
	local removeTriggerKeyTextField = native.newTextField( 0, 0, 272, 30 )
	removeTriggerKeyTextField.text = "key"
	removeTriggerKeyTextField.size = 16
	removeTriggerKeyTextField.x = display.contentCenterX
	removeTriggerKeyTextField.y = GetYSpacingFromButton(addTriggerButton, 12)
	removeTriggerKeyTextField:resizeHeightToFitFont()
	-- END: Add trigger key text field

	local buttonHandlerRemoveTrigger = function( event )
		-- Remove a single trigger with key
		OneSignal.RemoveTriggerForKey( removeTriggerKeyTextField.text )
		local removeTriggerString = "Removing Trigger Key: " .. removeTriggerKeyTextField.text
		textBox.text = removeTriggerString
		print(removeTriggerString)
	end

	-- START: Remove trigger button
	local removeTriggerButton = widget.newButton(
		{
			label = "Remove Trigger",
			emboss = true,
			shape = "roundedRect",
			width = 280,
			height = 40,
			cornerRadius = 4,
			fillColor = { default={ 0.9, 0.3, 0.3, 1 }, over={ 0.8, 0.3, 0.3, 1 } },
			strokeColor = { default={ 0.9, 0.3, 0.3, 1 }, over={ 0.8, 0.3, 0.3, 1 } },
			strokeWidth = 0,
			labelColor = { default={ 1, 1, 1, 1 }, over={ 1, 1, 1, 1 } }
		}
	)
	removeTriggerButton:addEventListener( "tap", buttonHandlerRemoveTrigger )
	removeTriggerButton.x = display.contentCenterX; removeTriggerButton.y = GetYSpacingFromButton(removeTriggerKeyTextField, 12);
	-- END: Remove trigger button

	-- Set texBox below lowest view element
	textBox.y = GetYSpacingFromButton(removeTriggerButton, 0);

	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( background )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
