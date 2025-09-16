' MovieData.brs - Handles loading and parsing movie data from JSON
' This file contains utility functions for working with movie data

' Function to load movie data from the local JSON file
function LoadMovieData() as Object
    print "Loading movie data from JSON file..."
    
    ' Read the JSON file from the package
    jsonString = ReadAsciiFile("pkg:/data/movies.json")
    
    if jsonString = "" then
        print "Error: Could not read movies.json file"
        return invalid
    end if
    
    ' Parse the JSON string into an object
    json = ParseJson(jsonString)
    
    if json = invalid then
        print "Error: Could not parse movies.json"
        return invalid
    end if
    
    print "Successfully loaded " + Str(json.movies.Count()).Trim() + " movies"
    return json
end function

' Function to get a specific movie by ID
function GetMovieById(movieId as Integer, movieData as Object) as Object
    if movieData = invalid or movieData.movies = invalid then
        return invalid
    end if
    
    for each movie in movieData.movies
        if movie.id = movieId then
            return movie
        end if
    end for
    
    return invalid
end function

' Function to create content nodes for the movie list
function CreateMovieContentNodes(movieData as Object) as Object
    if movieData = invalid or movieData.movies = invalid then
        return invalid
    end if
    
    ' Create a content node to hold all movie items
    content = CreateObject("roSGNode", "ContentNode")
    
    for each movie in movieData.movies
        ' Create a content node for each movie
        movieNode = CreateObject("roSGNode", "ContentNode")
        movieNode.title = movie.title
        movieNode.description = movie.description
        movieNode.hdposterurl = movie.posterUrl
        movieNode.id = movie.id
        
        ' Add custom fields for additional movie data
        movieNode.addFields({
            "genre": movie.genre,
            "year": movie.year,
            "duration": movie.duration,
            "videoUrl": movie.videoUrl
        })
        
        ' Add this movie to the main content node
        content.appendChild(movieNode)
    end for
    
    return content
end function
