# SwiftUISampleApp

## Overview
This is an example app showcasing a basic MVVM architecture of a SwiftUI app. The app demonstrates a simple user registration flow with the following screens:

- `RegisterView`: Lets you add a new User by filling out a form, validating inputs, showing potiential erros and storing the created User object.
- `WelcomeView`: Confirms the successful User creation by displaying a welcome msg and loading and showing the stored User information.

## Requirements
- iOS 16.0

## Details
Here you find details about specific part of the app's implementations.

### Navigation

### Strings / Localization

### Accessiblity

### Input validation
To validate the email adress format a Swift `Regex` pattern is used in combination with some further checks for edge cases.

### Models & Data Flow

### Unit & Integration Tests
Several unit and integration tests can be found in the test folder `SwiftUISampleTest/`

### Package dependencies
This project uses only one external package via SPM, which is the official [lottie-ios](https://github.com/airbnb/lottie-ios/) package. It is used for displaying a JSON Lottie anmation in the welcome page.
