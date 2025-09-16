' MovieList.brs - Movie list component logic
' Handles displaying and navigating through the list of movies

function init()
    print "=== MovieList Initializing ==="
    
    ' Get references to UI elements
    m.movieRowList = m.top.findNode("movieRowList")
    m.focusRectangle = m.top.findNode("focusRectangle")
    
    ' Set up observers for data changes and user interactions
    m.top.observeField("content", "onContentChange")
    m.movieRowList.observeField("rowItemSelected", "onItemSelected")
    m.movieRowList.observeField("rowItemFocused", "onItemFocused")
    
    ' Set initial focus
    m.top.setFocus(true)
end function

' Handle content data changes
function onContentChange()
    print "MovieList content changed"
    
    if m.top.content <> invalid
        ' Create a row content node to hold all movie items
        rowContent = CreateObject("roSGNode", "ContentNode")
        rowContent.addFields({"HandlerConfigRowList": CreateMovieRowListContent()})
        
        ' Add all movies as children to the row
        for i = 0 to m.top.content.getChildCount() - 1
            movieNode = m.top.content.getChild(i)
            rowContent.appendChild(movieNode)
        end for
        
        ' Set the content for the row list
        listContent = CreateObject("roSGNode", "ContentNode")
        listContent.appendChild(rowContent)
        m.movieRowList.content = listContent
        
        print "MovieList loaded " + Str(rowContent.getChildCount()) + " movies"
    end if
end function

' Handle item selection (when user presses OK)
function onItemSelected()
    selection = m.movieRowList.rowItemSelected
    print "Movie item selected - Row: " + Str(selection[0]) + ", Item: " + Str(selection[1])
    
    if selection.Count() = 2
        rowIndex = selection[0]
        itemIndex = selection[1]
        
        ' Get the selected movie content node
        rowContent = m.movieRowList.content.getChild(rowIndex)
        if rowContent <> invalid and itemIndex < rowContent.getChildCount()
            selectedMovie = rowContent.getChild(itemIndex)
            m.top.selectedItem = selectedMovie
            print "Selected movie: " + selectedMovie.title
        end if
    end if
end function

' Handle item focus changes (for visual feedback)
function onItemFocused()
    focus = m.movieRowList.rowItemFocused
    
    if focus.Count() = 2
        rowIndex = focus[0]
        itemIndex = focus[1]
        
        ' Update focus indicator position
        xPos = 55 + (itemIndex * 330)  ' 300 width + 30 spacing
        yPos = 125 + (rowIndex * 360)  ' Row height
        
        m.focusRectangle.translation = [xPos, yPos]
        m.focusRectangle.visible = true
        
        ' Get focused item for potential use
        rowContent = m.movieRowList.content.getChild(rowIndex)
        if rowContent <> invalid and itemIndex < rowContent.getChildCount()
            focusedMovie = rowContent.getChild(itemIndex)
            m.top.itemFocused = focusedMovie
        end if
    end if
end function

' Create content configuration for the row list
function CreateMovieRowListContent() as Object
    return {
        "name": "HandlerConfigRowList"
        "fields": {
            "posterShape": "16x9"
        }
    }
end function

' Handle key events for custom navigation
function onKeyEvent(key as string, press as boolean) as boolean
    if press then
        print "MovieList key pressed: " + key
        
        ' Pass navigation keys to the row list
        if key = "up" or key = "down" or key = "left" or key = "right"
            return false  ' Let the row list handle these
        end if
        
        ' Handle OK button press
        if key = "OK"
            ' Get currently focused item
            focus = m.movieRowList.rowItemFocused
            if focus.Count() = 2
                m.movieRowList.rowItemSelected = focus
                return true
            end if
        end if
    end if
    
    return false
end function
