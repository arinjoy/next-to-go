# Next To Go
An app made with ❤️ to demonstrate some examples of **clean architecture**, **code organisation**, **loose coupling**, **unit testing** and some of the best practices used in modern iOS programming using `Swift` & `SwiftUI`

## App Goal
Create an iOS app that displays ‘Next to Go’ races using our API.
A user should always see 5 races, and they should be sorted by time ascending. Race should disappear from the list after 1 min past the start time, if you are looking for inspiration look at https://www.neds.com.au/next-to-go 

### Requirements
1.	As a user, I should be able to see a time ordered list of races ordered by advertised start ascending
2.	As a user, I should not see races that are one minute past the advertised start 
3.	As a user, I should be able to filter my list of races by the following categories: Horse, Harness & Greyhound racing
4.	As a user, I can deselect all filters to show the next 5 from of all racing categories
5.	As a user I should see the meeting name, race number and advertised start as a countdown for each race.
6.	As a user, I should always see 5 races and data should automatically refresh 

## Solution Approach
 - App is broken down into 4 logical layers
   1.  DataLayer
   2.  DomainLayer
   3.  PresentationLayer
   4.  SharedUtils
- Each of these are Swift packages and they rely to each other as per dependency
- `PresentationLayer` -> `DomainLayer` -> `DataLayer`
- `SharedUtils` has some helpers and shared betwen all

Please refer from the project navigator in Xcode to see the layering

### Installation
 - Xcode 14 or later (required)
 - Clean /DerivedData folder if any
 - Let the Swift package Manager load and sync
 - Build the project and let the Swift Package Manager pulls two remote `SwiftLint` pluggin
 - iOS 15 minimum support (SwiftUI v4 used)
 - If you're testing on a device, select `automatically manage signing` options
 - 💗 **Please** test on a real iPhone to play with the **Haptics** feedbacks added :) 💗

## Accessibility
- Each elements on the app are fully `VoiceOver` compatible (Test on a device to hear the sounds)
- Some Text elements have been combined to give overall accessbility label, icons are excluded
- Custom accessibility hints are also applied to buttons (eg. Fiters)
- Filters do annouce the VoiceOver labels for visually imparied users, and updates their traits between `button` and `selected`
- All UI texts can grow with system font scaling and auto flips their possition when needed to fit better
- UI also adapts to layout updates, landscape / potrait modes (including iPad support)

### Extra Features
- A settings more menu hgas been made to show some details and author attribution and demonstarte how easy & fast SwiftUI is to build such layouts
- Some custom SwiftUI animations are applied to many icons
- Dark mode toggle can be applied from Settings
- Loading shimmers are added when refreshing races & changing between race category filters

### Error Handling UX
- Custom error screen are shown when loading error occurs
- `NetworkFailure` (i.e. internet disconnected) shows its special message and animated icon
- All other server errors have a generic message and icon
- If no races are found from API for some odd reason, then emopty state also shows with some messaging
