# FlickrFeed

This sample demonstrates a multi-stage approach to loading and displaying a Public Feed from Flickr. It displays the recent feeds using Flickr Public api and also allows the user to search for feeds by providing Tags

It begins by loading the Public Feeds from the RSS feed so the table can load as quickly as possible, then downloads the Feed images for each row asynchronously so the user interface is more responsive.
On tapping a row, the app will take you to Feed Detail Screen where more information about that feed is stored.

## Build Requirements
+ Xcode 7 or later
+ iOS 8.0 SDK or later

## Runtime Requirements
+ iOS 7.0 or later

