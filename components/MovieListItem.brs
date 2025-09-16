' MovieListItem.brs - Individual movie list item logic
' Handles displaying a single movie item with proper focus effects

function init()
    print "=== MovieListItem Initializing ==="
    
    ' Get references to UI elements
    m.itemBackground = m.top.findNode("itemBackground")
    m.moviePoster = m.top.findNode("moviePoster")
    m.movieTitle = m.top.findNode("movieTitle")
    m.movieMeta = m.top.findNode("movieMeta")
    m.focusOverlay = m.top.findNode("focusOverlay")
    m.selectionBorder = m.top.findNode("selectionBorder")
    
    ' Set up observers
    m.top.observeField("itemContent", "onContentChange")
    m.top.observeField("focusPercent", "onFocusPercentChange")
end function

' Handle content data changes
function onContentChange()
    itemContent = m.top.itemContent
    
    if itemContent <> invalid
        print "MovieListItem loading: " + itemContent.title
        
        ' Set movie poster
        if itemContent.hdposterurl <> invalid and itemContent.hdposterurl <> ""
            m.moviePoster.uri = itemContent.hdposterurl
        else
            ' Use a placeholder or default poster
            m.moviePoster.uri = ""
        end if
        
        ' Set movie title
        if itemContent.title <> invalid
            m.movieTitle.text = itemContent.title
        end if
        
        ' Set movie metadata (genre and year)
        metaText = ""
        if itemContent.genre <> invalid and itemContent.genre <> ""
            metaText = itemContent.genre
        end if
        
        if itemContent.year <> invalid and itemContent.year <> 0
            if metaText <> ""
                metaText = metaText + " • " + Str(itemContent.year)
            else
                metaText = Str(itemContent.year)
            end if
        end if
        
        m.movieMeta.text = metaText
        
        print "MovieListItem content loaded successfully"
    end if
end function

' Handle focus percentage changes for smooth focus animations
function onFocusPercentChange()
    focusPercent = m.top.focusPercent
    
    if focusPercent <> invalid
        ' Show/hide focus effects based on focus percentage
        if focusPercent > 0.5
            ' Item is focused
            m.focusOverlay.visible = true
            m.selectionBorder.visible = true
            m.selectionBorder.color = "0x007ACC"
            
            ' Scale effect for focused item
            scaleValue = 1.0 + (focusPercent * 0.05)  ' Subtle scale increase
            m.top.scale = [scaleValue, scaleValue]
            
        else
            ' Item is not focused
            m.focusOverlay.visible = false
            m.selectionBorder.visible = false
            m.top.scale = [1.0, 1.0]
        end if
    end if
end function
