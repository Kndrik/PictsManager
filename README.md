# PictsManager

## General

### Goal
The goal of this Epitech's project is to build a mobile application where users can take, visualize and share pictures.

Pictures are classified in albums, that have an owner and a list of people who can view it.

### Main views
- Login/Register views: On application build, a landing page will pop up and users can choose to do a login action or registration if an account creation is needed.

- Photo library (Default view): All photos of associated user available in this view. A `getPicturesList()` call is necessary to retrieve all images of user.

- Album view: Photos are classified to associated albums. A photo can belong to multiple albums.
    - `Recents` album is available and display the same content as Photo library view.
    - `Favorite` album is also available and display all images that has favorite tag.

- Search view: This screen helps users to easily navigate between photos and albums using a search bar.

- User view: Users can visualize and modify their own information in this screen. A `logout` button is available in this view.


## Technical
- Swift
- SwiftUI

### Problems
- Since this is a school project using Swift, App Store Connect is not available on free account, therefore, there's no pipeline to do an automatic nor a manual build. A build requires developers to generate `.xcarchive` and `.ipa` files or passing by TestFlight. All these 2 solutions require App Store Connect.

### Architecture
This project follows MVVM architecture. Each functionality has a View/Screen, a ViewModel and a Model.

For reusability, some components are common. For example, the Toast is generic, available and reusable on every project's components.

### Backend / HTTP Endpoint
All server side base relation is available at `Data` folder. Here, all HTTP endpoints are described in `Api` file.

To perform a request using backend, it depends on the component itself via its own method. In general, a method has this following structure: 

retrieve endpoint -> retrieve user's token -> build request (assign Bearer token, body, define HTTP method, etc.) -> handle response -> handle errors

### Philosophy
The client side should do nothing but represents the goal of PictsManager project using visual elements. All action should be performed via server side. This interface should be the middleman between the client and the server.


