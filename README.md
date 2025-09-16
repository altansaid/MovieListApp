# MovieListApp

A small Roku channel I built while exploring TV app development. It shows a simple movie list, details, and basic video playback.

## Why I built this

I wanted to understand the basics of how streaming apps on TVs work, so I experimented with BrightScript and SceneGraph. This project helped me get a feel for:

- Navigation with the Roku remote
- Building UIs with SceneGraph components
- Basic video playback
- Writing simple BrightScript code

## What I learned

- TV apps follow different UX patterns than web or mobile
- Focus management is key for remote control navigation
- SceneGraph’s component approach works well for UI structure
- BrightScript has its quirks, but it was good practice to try it out

## Features

- Browse a list of sample movies
- View movie details (poster, description)
- Play a sample video with basic controls
- Navigate using the Roku remote (up/down/OK/back)

## Project structure

```
components/ # UI components (XML + BrightScript)
MainScene.* # Main navigation scene
MovieList.* # Movie catalog screen
MovieListItem.* # Single movie item in the list
MovieDetails.* # Movie details screen
VideoPlayer.* # Basic video playback

data/ # Sample movie data
movies.json

images/ # Icons, splash screens, focus assets
splash_hd.jpg
splash_fhd.jpg
focus_ring.png
mm_icon_focus_hd.png

source/ # Main app logic
Main.brs
MovieData.brs

manifest # Roku app manifest
README.md # Project documentation
```

## Main parts

- `MainScene` → switches between screens
- `MovieList` → shows the catalog
- `MovieDetails` → shows movie info with play/back buttons
- `VideoPlayer` → basic video playback


