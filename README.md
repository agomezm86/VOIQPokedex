# VOIQPokedex
VOIQ technical test, create Pokedex using public API's

## Download

The project can be downloaded throught the **Clone or dowload** button for download the ZIP file, or via git using the next command:

```
git clone https://github.com/agomezm86/VOIQPokedex.git
```
## Technical specifications

These are the most relevant specifications of the project:

- Built in Objective-C
- Supports iOS 8.0 or higher version
- Built for iPhone devices
- Supports portrait and both landscape orientations
- Unit tests and UI Tests included
- Application test in the next simulators using iOS 8.2 and iOS 9.2: iPhone 4S, iPhone 5, iPhone 5S, iPhone 6, iPhone 6 Plus, iPhone 6S, iPhone 6S Plus

## Design and Implementacion

The implementation process consists of the next steps:

- Implementation design: architecture and design patterns definition
- Layers: the application is implemented using the layers of presentation, controllers, data access, modelling and services
- Data persistence model using Core Data
- The services layer is implemented using NSURLSession
- The views are implemented using storyboards
- The pagination for the home view is an infinite scroll
- The implementation passed through a refactor process in order to optimized the code
- The code is fully documented

## Libraries and Classes

The most relevant libraries and classes used in this project were:

- CoreData: Used to persistence the data obtained from web services, the main goal is have information to present to the user even if the application is offline
- UITableView: Used to present the list of Pokemons in the home view
- NSFetchedResultsController: Used as the controller between the core data access and the home view controller to handle the views updates
- NSURLSessionTask: Used in the service class to handle all the web services requests
- UIScrollView+InfiniteScroll: The only third party class used in the project, used to handle the infinite scroll move. The class was added to the project instead of using CocoaPods in order to avoid the download and configuration of the person who downloads the project. More info about this class in https://github.com/pronebird/UIScrollView-InfiniteScroll
- XCTestCase: Used in the implementation of Unit Tests and UI Tests

## Unit Tests

The project has two classes where the unit tests were implemented using XCTestCase:

- PokemonDataAccessTests
- ServicesManagerTests

The last code coverage reported by Xcode was 59%

## UITests

The project has one class for UITests:

- VOIQPokedexUITests

Currently the class has two UITests fully test

## Application Screenshots
