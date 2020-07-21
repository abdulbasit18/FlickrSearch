# FlickrSearch
<p align="center"><img src="https://phandroid.com/wp-content/uploads/2013/05/Flickr-for-Android-banner.png" ></a></p>

## Prereqs

- Xcode 11.5
- iOS 13+

## Features

App is consist of two screen and has below featues

1. **Searching** : Search images through tags.
2. **Infite Srolling** : Get the new search results by scrolling.
2. **Caching** : You can search images from local database in case of internet unavailibilty.
2. **Full Screen View** : You can tap on image to view the image in big size

## Overall Architecture 

App is based on **MVVM-C** architecture. Structure is broken down by the general purpose of contained source files. Below are the dependencies used in the project

1. **RxSwift** : used to bind the flow between layers
2. **SDWebImage** : used for networking.
3. **NVActivityIndicatorView** : used to show loading states.
