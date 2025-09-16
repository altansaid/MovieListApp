' MovieDetails.brs - Movie details component logic
' Handles displaying detailed movie information and navigation options

function init()
    print "=== MovieDetails Initializing ==="
    
    ' Get references to UI elements
    m.moviePoster = m.top.findNode("moviePoster")
    m.movieTitle = m.top.findNode("movieTitle")
    m.movieYear = m.top.findNode("movieYear")
    m.movieGenre = m.top.findNode("movieGenre")
    m.movieDuration = m.top.findNode("movieDuration")
    m.movieDescription = m.top.findNode("movieDescription")
    m.playButton = m.top.findNode("playButton")
    m.backButton = m.top.findNode("backButton")
    m.buttonFocus = m.top.findNode("buttonFocus")
    
    ' Set up observers for data changes
    m.top.observeField("movieData", "onMovieDataChange")
    m.top.observeField("focusedButton", "onButtonFocusChange")
    
    ' Initialize button focus
    m.top.focusedButton = 0  ' 0 = play, 1 = back
    updateButtonFocus()
    
    ' Set focus
    m.top.setFocus(true)
end function

' Handle movie data changes
function onMovieDataChange()
    movieData = m.top.movieData
    print "MovieDetails data changed"
    
    if movieData <> invalid
        ' Set movie poster
        if movieData.posterUrl <> invalid
            m.moviePoster.uri = movieData.posterUrl
        end if
        
        ' Set movie title
        if movieData.title <> invalid
            m.movieTitle.text = movieData.title
            print "Displaying movie: " + movieData.title
        end if
        
        ' Set movie metadata
        if movieData.year <> invalid
            m.movieYear.text = Str(movieData.year)
        end if
        
        if movieData.genre <> invalid
            m.movieGenre.text = movieData.genre
        end if
        
        if movieData.duration <> invalid
            m.movieDuration.text = movieData.duration
        end if
        
        ' Set movie description
        if movieData.description <> invalid
            m.movieDescription.text = movieData.description
        end if
    end if
end function

' Handle button focus changes
function onButtonFocusChange()
    updateButtonFocus()
end function

' Update visual focus indicator for buttons
function updateButtonFocus()
    focusedButton = m.top.focusedButton
    
    if focusedButton = 0  ' Play button focused
        ' Position focus indicator on play button
        m.buttonFocus.translation = [520, 540]  ' Same as play button position
        m.playButton.color = "0x0099FF"  ' Brighter blue
        m.backButton.color = "0x666666"  ' Normal gray
        
    else if focusedButton = 1  ' Back button focused
        ' Position focus indicator on back button
        m.buttonFocus.translation = [700, 540]  ' Same as back button position
        m.playButton.color = "0x007ACC"  ' Normal blue
        m.backButton.color = "0x888888"  ' Brighter gray
    end if
    
    m.buttonFocus.visible = true
end function

' Execute the currently focused button action
function executeButtonAction()
    focusedButton = m.top.focusedButton
    
    if focusedButton = 0  ' Play button
        print "Play button pressed"
        m.top.action = "play"
        
    else if focusedButton = 1  ' Back button
        print "Back button pressed"
        m.top.action = "back"
    end if
end function

' Handle key events for navigation
function onKeyEvent(key as string, press as boolean) as boolean
    if press then
        print "MovieDetails key pressed: " + key
        
        ' Handle left/right navigation between buttons
        if key = "left"
            if m.top.focusedButton > 0
                m.top.focusedButton = m.top.focusedButton - 1
                return true
            end if
            
        else if key = "right"
            if m.top.focusedButton < 1  ' 0-1 range for 2 buttons
                m.top.focusedButton = m.top.focusedButton + 1
                return true
            end if
            
        ' Handle OK button to execute action
        else if key = "OK"
            executeButtonAction()
            return true
            
        ' Handle back button to go back
        else if key = "back"
            m.top.action = "back"
            return true
        end if
    end if
    
    return false
end function
