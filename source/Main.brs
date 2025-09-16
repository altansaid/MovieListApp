' Main.brs - Entry point for MovieListApp Roku Channel
' This file initializes the application and sets up the main scene

function Main() as Void
    print "=== MovieListApp Starting ==="
    
    ' Initialize the SceneGraph screen
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    
    ' Create the main scene from our MainScene component
    scene = screen.CreateScene("MainScene")
    screen.show()
    
    ' Start the main event loop
    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        
        if msgType = "roSGScreenEvent" then
            if msg.isScreenClosed() then
                print "Screen closed, exiting application"
                return
            end if
        end if
    end while
end function
