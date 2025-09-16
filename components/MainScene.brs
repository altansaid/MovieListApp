' MainScene.brs - Main scene logic for MovieListApp
' Handles navigation between movie list, details, and video player views

function init()
    print "=== MainScene Initializing ==="
    
    ' Get references to important UI elements
    m.contentGroup = m.top.findNode("contentGroup")
    
    ' Set up field observers to handle view changes
    m.top.observeField("currentView", "onViewChange")
    m.top.observeField("selectedMovieId", "onMovieSelected")
    
    ' Load movie data
    m.movieData = LoadMovieData()
    
    ' Initialize the movie list view
    showMovieList()
    
    ' Set up key event handling
    m.top.setFocus(true)
end function

' Handle view changes (movieList, movieDetails, videoPlayer)
function onViewChange()
    currentView = m.top.currentView
    print "View changing to: " + currentView
    
    if currentView = "movieList"
        showMovieList()
    else if currentView = "movieDetails"
        showMovieDetails()
    else if currentView = "videoPlayer"
        showVideoPlayer()
    end if
end function

' Show the movie list view
function showMovieList()
    print "Showing movie list view"
    
    ' Clear existing content
    m.contentGroup.removeChildrenIndex(m.contentGroup.getChildCount(), 0)
    
    ' Create and add movie list component
    m.movieList = CreateObject("roSGNode", "MovieList")
    
    ' Set position below title bar
    m.movieList.translation = [0, 120]
    
    ' Load movie data into the list
    if m.movieData <> invalid
        content = CreateMovieContentNodes(m.movieData)
        m.movieList.content = content
    end if
    
    ' Set up event handlers for movie selection
    m.movieList.observeField("selectedItem", "onMovieItemSelected")
    
    ' Add to content group and set focus
    m.contentGroup.appendChild(m.movieList)
    m.movieList.setFocus(true)
end function

' Show the movie details view
function showMovieDetails()
    print "Showing movie details view"
    
    ' Clear existing content
    m.contentGroup.removeChildrenIndex(m.contentGroup.getChildCount(), 0)
    
    ' Create movie details component
    m.movieDetails = CreateObject("roSGNode", "MovieDetails")
    m.movieDetails.translation = [0, 120]
    
    ' Get the selected movie data
    selectedMovie = GetMovieById(m.top.selectedMovieId, m.movieData)
    if selectedMovie <> invalid
        m.movieDetails.movieData = selectedMovie
    end if
    
    ' Set up event handlers
    m.movieDetails.observeField("action", "onDetailsAction")
    
    ' Add to content group and set focus
    m.contentGroup.appendChild(m.movieDetails)
    m.movieDetails.setFocus(true)
end function

' Show the video player view
function showVideoPlayer()
    print "Showing video player view"
    
    ' Clear existing content
    m.contentGroup.removeChildrenIndex(m.contentGroup.getChildCount(), 0)
    
    ' Create video player component
    m.videoPlayer = CreateObject("roSGNode", "VideoPlayer")
    m.videoPlayer.translation = [0, 120]
    
    ' Get the selected movie data
    selectedMovie = GetMovieById(m.top.selectedMovieId, m.movieData)
    if selectedMovie <> invalid
        m.videoPlayer.movieData = selectedMovie
    end if
    
    ' Set up event handlers
    m.videoPlayer.observeField("action", "onVideoPlayerAction")
    
    ' Add to content group and set focus
    m.contentGroup.appendChild(m.videoPlayer)
    m.videoPlayer.setFocus(true)
end function

' Handle movie selection from the movie list
function onMovieItemSelected()
    if m.movieList.selectedItem <> invalid
        print "Movie selected: " + m.movieList.selectedItem.title
        m.top.selectedMovieId = m.movieList.selectedItem.id
        m.top.currentView = "movieDetails"
    end if
end function

' Handle selection change for navigation
function onMovieSelected()
    print "Movie ID selected: " + Str(m.top.selectedMovieId)
end function

' Handle actions from the movie details view
function onDetailsAction()
    action = m.movieDetails.action
    print "Details action: " + action
    
    if action = "back"
        m.top.currentView = "movieList"
    else if action = "play"
        m.top.currentView = "videoPlayer"
    end if
end function

' Handle actions from the video player view
function onVideoPlayerAction()
    action = m.videoPlayer.action
    print "Video player action: " + action
    
    if action = "back"
        m.top.currentView = "movieDetails"
    end if
end function

' Handle key press events for navigation
function onKeyEvent(key as string, press as boolean) as boolean
    if press then
        print "Key pressed: " + key
        
        ' Handle back button to return to previous view
        if key = "back"
            currentView = m.top.currentView
            if currentView = "movieDetails"
                m.top.currentView = "movieList"
                return true
            else if currentView = "videoPlayer"
                m.top.currentView = "movieDetails"
                return true
            end if
        end if
    end if
    
    return false
end function
