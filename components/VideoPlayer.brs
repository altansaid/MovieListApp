' VideoPlayer.brs - Video player component logic
' Handles video playback with basic controls and navigation

function init()
    print "=== VideoPlayer Initializing ==="
    
    ' Get references to UI elements
    m.videoPlayer = m.top.findNode("videoPlayer")
    m.controlsOverlay = m.top.findNode("controlsOverlay")
    m.instructionsOverlay = m.top.findNode("instructionsOverlay")
    m.videoTitle = m.top.findNode("videoTitle")
    m.playPauseButton = m.top.findNode("playPauseButton")
    m.playPauseLabel = m.top.findNode("playPauseLabel")
    m.backButton = m.top.findNode("backButton")
    m.controlFocus = m.top.findNode("controlFocus")
    m.progressFill = m.top.findNode("progressFill")
    m.currentTime = m.top.findNode("currentTime")
    m.totalTime = m.top.findNode("totalTime")
    
    ' Set up observers
    m.top.observeField("movieData", "onMovieDataChange")
    m.top.observeField("focusedControl", "onControlFocusChange")
    m.top.observeField("controlsVisible", "onControlsVisibilityChange")
    
    ' Set up video player event observers
    m.videoPlayer.observeField("state", "onVideoStateChange")
    m.videoPlayer.observeField("position", "onVideoPositionChange")
    m.videoPlayer.observeField("duration", "onVideoDurationChange")
    
    ' Initialize control focus
    m.top.focusedControl = 0  ' 0 = play/pause, 1 = back
    
    ' Hide instructions after a few seconds
    m.instructionsTimer = CreateObject("roSGNode", "Timer")
    m.instructionsTimer.duration = 3.0
    m.instructionsTimer.observeField("fire", "hideInstructions")
    m.instructionsTimer.control = "start"
    
    ' Set focus
    m.top.setFocus(true)
end function

' Handle movie data changes
function onMovieDataChange()
    movieData = m.top.movieData
    print "VideoPlayer movie data changed"
    
    if movieData <> invalid
        ' Set video title
        if movieData.title <> invalid
            m.videoTitle.text = movieData.title
            print "Loading video: " + movieData.title
        end if
        
        ' Set up video content
        if movieData.videoUrl <> invalid and movieData.videoUrl <> ""
            videoContent = CreateObject("roSGNode", "ContentNode")
            videoContent.url = movieData.videoUrl
            videoContent.title = movieData.title
            videoContent.description = movieData.description
            
            ' Stream format information
            videoContent.streamFormat = "mp4"
            
            m.videoPlayer.content = videoContent
            print "Video content set: " + movieData.videoUrl
        else
            print "Error: No valid video URL provided"
        end if
    end if
end function

' Handle video state changes
function onVideoStateChange()
    state = m.videoPlayer.state
    print "Video state changed to: " + state
    
    if state = "playing"
        m.playPauseLabel.text = "⏸ Pause"
    else if state = "paused"
        m.playPauseLabel.text = "▶ Play"
    else if state = "error"
        print "Error playing video"
        ' Could show an error message here
    end if
end function

' Handle video position changes for progress bar
function onVideoPositionChange()
    position = m.videoPlayer.position
    duration = m.videoPlayer.duration
    
    if duration > 0 then
        ' Update progress bar
        progressPercent = position / duration
        progressWidth = 1800 * progressPercent
        m.progressFill.width = progressWidth
        
        ' Update time displays
        m.currentTime.text = formatTime(position)
    end if
end function

' Handle video duration changes
function onVideoDurationChange()
    duration = m.videoPlayer.duration
    m.totalTime.text = formatTime(duration)
end function

' Format time in MM:SS format
function formatTime(seconds as Float) as String
    minutes = Int(seconds / 60)
    remainingSeconds = Int(seconds) - (minutes * 60)
    
    minutesStr = Str(minutes).Trim()
    secondsStr = Str(remainingSeconds).Trim()
    
    ' Pad with zeros if needed
    if minutes < 10 then minutesStr = "0" + minutesStr
    if remainingSeconds < 10 then secondsStr = "0" + secondsStr
    
    return minutesStr + ":" + secondsStr
end function

' Handle control focus changes
function onControlFocusChange()
    updateControlFocus()
end function

' Handle controls visibility changes
function onControlsVisibilityChange()
    m.controlsOverlay.visible = m.top.controlsVisible
    if m.top.controlsVisible then
        updateControlFocus()
        
        ' Auto-hide controls after 5 seconds
        if m.controlsTimer <> invalid then m.controlsTimer.control = "stop"
        m.controlsTimer = CreateObject("roSGNode", "Timer")
        m.controlsTimer.duration = 5.0
        m.controlsTimer.observeField("fire", "hideControls")
        m.controlsTimer.control = "start"
    end if
end function

' Update visual focus for controls
function updateControlFocus()
    if m.top.controlsVisible then
        focusedControl = m.top.focusedControl
        
        if focusedControl = 0  ' Play/Pause button
            m.controlFocus.translation = [60, 840]
            m.playPauseButton.color = "0x0099FF"
            m.backButton.color = "0x666666"
            
        else if focusedControl = 1  ' Back button
            m.controlFocus.translation = [200, 840]
            m.playPauseButton.color = "0x007ACC"
            m.backButton.color = "0x888888"
        end if
        
        m.controlFocus.visible = true
    else
        m.controlFocus.visible = false
    end if
end function

' Hide instructions overlay
function hideInstructions()
    m.instructionsOverlay.visible = false
end function

' Hide controls overlay
function hideControls()
    m.top.controlsVisible = false
end function

' Execute control action
function executeControlAction()
    focusedControl = m.top.focusedControl
    
    if focusedControl = 0  ' Play/Pause
        state = m.videoPlayer.state
        if state = "playing"
            m.videoPlayer.control = "pause"
        else if state = "paused"
            m.videoPlayer.control = "resume"
        end if
        
    else if focusedControl = 1  ' Back
        m.top.action = "back"
    end if
end function

' Handle key events
function onKeyEvent(key as string, press as boolean) as boolean
    if press then
        print "VideoPlayer key pressed: " + key
        
        ' Any key shows controls (except back)
        if key <> "back" and not m.top.controlsVisible
            m.top.controlsVisible = true
            return true
        end if
        
        ' Navigation keys when controls are visible
        if m.top.controlsVisible
            if key = "left"
                if m.top.focusedControl > 0
                    m.top.focusedControl = m.top.focusedControl - 1
                    return true
                end if
                
            else if key = "right"
                if m.top.focusedControl < 1
                    m.top.focusedControl = m.top.focusedControl + 1
                    return true
                end if
                
            else if key = "OK"
                executeControlAction()
                return true
            end if
        end if
        
        ' Special keys
        if key = "play"
            m.videoPlayer.control = "resume"
            return true
        else if key = "pause"
            m.videoPlayer.control = "pause"
            return true
        else if key = "back"
            m.top.action = "back"
            return true
        end if
    end if
    
    return false
end function
