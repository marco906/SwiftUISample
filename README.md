# SwiftUISampleApp

## Overview
This is an example app showcasing a basic MVVM architecture of a SwiftUI app. The app demonstrates a simple user registration flow with the following screens:

- `RegisterView`: Lets you add a new User by filling out a form, validating inputs, showing potential error and storing the created User object.
- `WelcomeView`: Confirms the successful User creation by displaying a welcome msg and loading and showing the stored User information.

## Requirements
- iOS 16.0, Swift 5.7

## Details
Here you find details about specific part of the app's implementations.

### Navigation
The app uses `NavigationStack` to handle navigation between screens wich is defined in `MainView`.
The ’Navigator’ class serves as data source to control the stack. It is passed as EnvironmentObject to the pushed views, to be able to navigate programatically from inside the view.

The app defines navigation routes in a central place ’Routes.swift’ which makes it easy to maintain. View arguments are passed in as parameters to the ’RouteDestination’ enum.

In this example only push navigation is implemented, but this logic could easily extended to also handle sheets, popovers, alerts etc. using similar logic.

### Strings / Localization
The app uses a Xcode String Catalog for managing Strings / Translations. Currently only `de` is localised, but you could easily add more languages just by adding it to the catalog.

To prevent hardcoded strings for localised string keys, those are defined as static properties in `Strings.swift’.  For Strings containing parameters like ‘%@’ static methods which the parameters as arguments are defined. 

The generation of the `Strings.swift` file is automated using the python script located in `SwiftUISample/Scripts`. Simply run `make strings` to update the string definitions.

### Appearance & Accessibility
The app supports the following appearance & accessibility features (there might be more): 
- Dynamic Type size
- Voiceover: Accessibility labels and values have been added.
- Contrast and color filter settings
- Darkmode / Lightmode

### Input validation
To validate the email address format a Swift `Regex` pattern is used in combination with some further checks for edge cases.

### Models & Data Flow
This example project follows the following principles.
- Model - View code separation by every screen having its own view model.
- Use StateObjects to define view models so they don’t get reinitialised in every view redraw
- View models should be initialised without arguments and setup / started in the .task modifier of the view
- View models use callbacks to call action on the view side
- Views show different data depending on the current state of the model, for example loading, normal, error, etc.

### Unit & Integration Tests
Several unit and integration tests can be found in the test folder `SwiftUISampleTest/`.

### Package dependencies
This project uses only one external package via SPM, which is the official [lottie-ios](https://github.com/airbnb/lottie-ios/) package. It is used for displaying a JSON Lottie animation in the welcome page. This is just a nice to have, not relevant for functionality.

### Makefile
A Makefile is provided to have shortcuts to the following actions: 
- `make strings` regenerates the string key definitions in ‘Strings.swift` as defined in the string catalog
- `make test` runs unit tests in the terminal
