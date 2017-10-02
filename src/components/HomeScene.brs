sub init()

    m.targetText = m.top.findNode("mainTextLabel")
    m.top.backgroundColor = "0xffffff"

    ' Font file
    m.font = createObject("roSGNode", "Font")
    m.font.id = "targetFont"
    m.font.uri = "pkg:/fonts/Avalon-Medium.otf"
    m.font.size = 30
    m.targetText.font = m.font
    m.resetFont = createObject("roSGNode", "Font")

    ' Get the bounding rect dimensions for the text label
    labelRect = m.targetText.boundingRect()

    ' Assign position translation variables
    centerx = (1920 - labelRect.width) / 2
    centery = (1080 - labelRect.height) / 2.3

    ' Apply position translation on the label
    m.targetText.translation = [ centerx, centery ]

    ' Get font resize action buttons
    m.decreaseButton = m.top.findNode("decFontSizeButton")
    m.increaseButton = m.top.findNode("incFontSizeButton")
    m.changeSize = m.top.findNode("selectLabelListItem")
    m.fontSelector = m.top.findNode("fontSelector")

    buttonDims = m.decreaseButton.boundingRect()
    widthOffset = buttonDims.width

    ' Position buttons
    decCenterX = (1920 / 2) - (buttonDims.width * 2)
    incCenterX = (1920 / 2) + (buttonDims.width)

    decCenterY = (1080 - buttonDims.height) / 1.3
    incCenterY = decCenterY

    m.decreaseButton.translation = [ decCenterX, decCenterY ]
    m.increaseButton.translation = [ incCenterX, decCenterY ]

    ' Enable observers
    m.decreaseButton.observeField("buttonSelected", "decreaseFont")
    m.increaseButton.observeField("buttonSelected", "increaseFont")
    m.changeSize.observeField("buttonSelected", "changeButtonSelected")
    m.fontSelector.observeField("itemSelected", "fontItemSelected")

    m.fontSizeDisplay = m.top.findNode("fontSizeDisplay")
    m.fontSizeDisplay.text = m.font.size
    m.displayedSizeGroup = m.top.findNode("displayedSizeGroup")
    m.displayedSizeGroup.translation = [(incCenterX - (buttonDims.width - 20)), incCenterY]
    m.currentFontLabel = m.top.findNode("currentFontLabel")
    m.currentFontLabel.font.size = 23

    m.top.findNode("minFontReachedMsg").font.size = 20
    m.top.observeField("fontlist", "assignFontListContentNodes")
    m.top.setFocus(true)
end sub

sub assignFontListContentNodes()
    fontsNode = m.top.findNode("fontListContentNode")
    for each font in m.top.fontlist
        if font <> ".DS_Store" then
            childContentNode = fontsNode.createChild("contentNode")
            childContentNode.title = font
        end if
    end for
end sub

sub fontItemSelected()
    if m.top.fontlist <> invalid then
        fontUri = "pkg:/fonts/" + m.top.fontlist[m.fontSelector.itemSelected]
        m.targetText.font = m.resetFont
        m.font.uri = fontUri
        m.targetText.font = m.font
    end if
end sub

sub showMinFontReachedMsg()
    messageLabel = m.top.findNode("minFontReachedMsg")
    messageLabel.visible = true
end sub

sub changeButtonSelected()
    if m.font.size >= 44 then
        m.decreaseButton.setFocus(true)
    else
        m.increaseButton.setFocus(true)
    end if
end sub

' Font decrease observer
function decreaseFont()
    currentsize = m.font.size
    if currentsize = 10 then
        showMinFontReachedMsg()
        return false
    end if
    m.font.size--
    m.fontSizeDisplay.text = m.font.size
end function

' Font increase observer
function increaseFont()
    currentsize = m.font.size
    if currentsize = 10 then
        messageLabel = m.top.findNode("minFontReachedMsg")
        messageLabel.visible = false
    end if
    m.font.size++
    m.fontSizeDisplay.text = m.font.size
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    if press then
        print "onKeyEvent() handler"
        if (key = "left") then
            if (m.changeSize.hasFocus()) then
                m.fontSelector.setFocus(true)
                handled = true
            end if
            if (m.increaseButton.hasFocus()) then
                m.decreaseButton.setFocus(true)
                handled = true
            end if
        end if
        if (key = "right") then
            if m.decreaseButton.hasFocus() then
                m.increaseButton.setFocus(true)
                handled = true
            end if
            if m.fontSelector.hasFocus() then
                m.changeSize.setFocus(true)
                handled = true
            end if
        end if
        if (key = "up") then
            print "up key pressed"
            if (m.decreaseButton.hasFocus()) then
                m.fontSelector.setFocus(true)
                handled = true
            end if
            if (m.increaseButton.hasFocus()) then
                m.changeSize.setFocus(true)
                handled = true
            end if
        end if
        if (key = "down") then
            if (m.changeSize.hasFocus()) then
                m.increaseButton.setFocus(true)
                handled = true
            end if
        end if
    end if
    return handled
end function
