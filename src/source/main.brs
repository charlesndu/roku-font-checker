' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

sub Main()
    showChannelSGScreen()
end sub

sub showChannelSGScreen()
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")

    screen.setMessagePort(m.port)
    scene = screen.CreateScene("HomeScene")

    syslog = createObject("roSystemLog")
    syslog.setMessagePort(m.port)

    syslog.EnableType("http.error")
    syslog.EnableType("http.connect")
    syslog.EnableType("bandwidth.minute")

    fontsDirectory = "pkg:/fonts"
    scene.fontlist = getFontList(fontsDirectory)
    screen.show()

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub

function getFontList(path as String) as Object
    list = []
    contents = ListDir(path)
    for each file in contents
        if file <> ".DS_Store" then
            list.push(file)
        end if
    end for
    return list
end function
