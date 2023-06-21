# 🏇🏼 Next To Go
An app made with ❤️ to demonstrate some examples of **clean architecture**, **code organisation**, **loose coupling**, **unit testing**, **accessibility** and some of the best practices used in modern iOS programming using `Swift` & `SwiftUI`

## 📱 App Goal
Create an iOS app that displays `Next to Go` top 5 races using Neds free public API.
A user should always see top 5 races, and they should be sorted by time ascending. Race should disappear from the list after 1 min past the start time. Take some inspirations from popular betting apps like Neds, Ladbrokes, Sportsbet etc.

### 💼 Requirements
1.	As a user, I should be able to see a time ordered list of races ordered by advertised start ascending
2.	As a user, I should not see races that are one minute past the advertised start 
3.	As a user, I should be able to filter my list of races by the following categories: Horse, Harness & Greyhound racing
4.	As a user, I can deselect all filters to show the next 5 from of all racing categories
5.	As a user I should see the meeting name, race number and advertised start as a countdown for each race.
6.	As a user, I should always see 5 races and data should automatically refresh 

## 👨🏽‍💻  Solution Approach
 - App is broken down into 4 logical layers (via Swift Packages)
   1.  `DataLayer` (Network fetching of raw data and JSON decoding via URL, error code mapping etc.)
   2.  `DomainLayer` (Business logic of polling and combining data based on filters, sorting of top 5 based on timing etc.)
   3.  `PresentationLayer` (Domain data to SwiftUI binding logic, all UI code etc.)
   4.  `SharedUtils` (Common utility helpers and extensions)
- A mix of **`MVVM`** and **`VIPER`** design pattern is used to acheive loose coupling and unit testing via **`Dependency Injection`** patterns and mocks
- Currently use Apple's `Combine` based `Reactive Binding`
- ✋🏽`TODO`: Migrate from `Combine` driven Publishers into `Swift`'s `Moden Concurrency Async Await` paradigm (layer by layer where feasible)
- `Unit Testing` (about 70%) has been added on each layer. (A bit more coverage can still be added in presentation layer code, all view models are tested for now)
- Some TODO notes left in the code deliberartely for potential improvements and SwfiftLint warns us about those to trace them.

The package depdencies (import logic from one to another) are shown below:

```mermaid
  graph TD;
      A[Presentation Layer] --> B[Domain Layer];
      B-->C[Data Layer];
      A-.->C;
      A-->D[Shared Utils];
      B-->D;
      C-->D;
```
 
Please refer from the project navigator in Xcode to see the layering.

| Project  | Targets | Tests |
| ------ | -------- | ---- |
| <img src="Screenshots/project-structure.png" width="300" alt="">  |  <img src="Screenshots/targets.png" width="300" alt="">   |   <img src="Screenshots/tests.png" width="300" alt="">  |


```mermaid
graph TB
    subgraph DataLayer;
    a2[URLSession]-. RaceSummary Data Model .->a1[NetworkService];
    end;
    subgraph DomainLayer;
    a1-. applies some business logic  .->b1[Interactor];
    end;
    subgraph PresentationLayer;
    c1[NextToGoViewModel]-. list of RaceItemViewModel reactively .->c2[Races List UI];
    c2-. RaceItemViewModel .->c3[Races Cell Item UI];
    c1-. list of FilterModels .->c4[FilterViewModel];
    c4-. applies to .->c1;
    end;
    b1-. list of Race Domain Model reactively .->c1;
    c1-. Category filters .->b1;
```

## 💻 Installation
 - Xcode 14 or later (required)
 - Clean build /DerivedData folder if any
 - Let the Swift package Manager load and sync
 - Build the project and let the Swift Package Manager pulls the remote **`SwiftLint`** pluggin
 - **iOS 15** minimum support (SwiftUI v4 used)
 - If you're testing on a device, select `automatically manage signing` options
 - 💗 Please 🙏🏽 test on a real iPhone to play with the **Haptics** feedbacks added :) 💗

## ♿️ Accessibility
- Each elements on the app are fully `VoiceOver` compatible (Test on a device to hear the sounds)
- Some Text elements have been combined to give overall accessbility label (icons are excluded)
- Custom accessibility hints are also applied to buttons (eg. Fiters)
- Filters do annouce the VoiceOver labels for visually impaired users, and updates their traits between `button` and `selected`
- All texts on UI can grow with system level font scaling and auto reposition themselves when needed to fit better within the container
- UI also adapts to layout chnages - landscape / potrait modes (including iPad support)

## 🚀 Extra Features
- A settings more menu has been made to show extra info and author attribution and demonstrate how easy & fast SwiftUI is to build such layouts
- Some custom SwiftUI animations are applied to many icons (all `SFSymbol`s and some custom made SF symbol such horse, harness etc.)
- Dark mode toggle can be applied from Settings (there is a minor 🐞 bug there now, after applying this, shimmers go funny and does not update, app kill and restart needed)
- Loading shimmers are added when refreshing races & changing between race category filters

## ⛈️ Error Handling UX
- Custom error UI is shown when loading error occurs
- `NetworkFailure` (i.e. internet disconnected) shows its custom message and animated icon
- All other server errors have a generic message and animated icon
- If no races are found from API for some odd reason, then empty state also shows with some messaging

## Screenshots

| Filtering Races | Settings |
| ------ | ---- |
|  <img src="Screenshots/filtering-logic.gif" width="300" alt=""> | <img src="Screenshots/settings-menu.gif" width="300" alt="">  |

#### Errors (Test steps included)

| Empty State  | Generic Sever Error | Internet Lost Error |
| ------ | ---- | --- |
|  Update code in `NextRacesInteractor.swift` to return `[]` by commenting out `results.append(..)` statement around line 65 | Update the API endpoint in `ApiConstants` to something incorrect URL | Disconnect WiFi & conect back and test |
|   <img src="Screenshots/races-empty-list.gif" width="300" alt=""> |   <img src="Screenshots/server-error.gif" width="300" alt=""> |   <img src="Screenshots/network-error.gif" width="300" alt=""> |

| Dark modes |  |
| ------ | ---- |
|   <img src="Screenshots/dark-mode-1.png" width="300" alt=""> |   <img src="Screenshots/dark-mode-2.png" width="300" alt=""> | 


# Acessibility

| Font Scaling  |
| ------ | 
| <img src="Screenshots/a11y-font-scaling.gif" width="300" alt=""> |

| VoiceOver Labels and Traits  |
| ---------- | 
| <img src="Screenshots/a11y-voice-over.gif" height="450" alt=""> |

| Potrait Large | Landscape Large  |
| ------ | ---- |
| <img src="Screenshots/potrait-mode-large.png" width="300" alt=""> | <img src="Screenshots/landscape-mode-large.png" height="300" alt=""> | 
