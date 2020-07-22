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

1. **RxSwift** : Used to bind the flow between layers
2. **SDWebImage** : Used for networking.
3. **NVActivityIndicatorView** : Used to show loading states.
3. **SwiftLint** : A tool to enforce Swift style and conventions, loosely based on
[GitHub's Swift Style Guide](https://github.com/github/swift-style-guide).

## Flickr API Documentation

Images are retrieved by hitting the [Flickr API](https://www.flickr.com/services/api/flickr.photos.search.html).

- **Search Path:**

```
https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=YOUR_FLICKR_API_KEY&format=json&nojsoncallback=1&safe_search=1&text=KEYWORD
```

- Response includes an array of photo objects, each represented as:

``` swift
{
    "id": "23451156376",
    "owner": "28017113@N08",
    "secret": "8983a8ebc7",
    "server": "578",
    "farm": 1,
    "title": "Merry Christmas!",
    "ispublic": 1,
    "isfriend": 0,
    "isfamily": 0
}
```

### To load the photo, you can build the full URL following this pattern:
```
http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg
```
### Thus, using our Flickr photo model example above, the full URL would be:
```
http://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg
```
