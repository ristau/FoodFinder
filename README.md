# Project 3 - *FoodFinder*

**FoodFinder** is a Yelp search app using the Yelp API(http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: **21** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] Table rows for search results should be dynamic height according to the content height.
- [X] Custom cells should have the proper Auto Layout constraints.
- [X] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).

The following **optional** features are implemented:

- [X] Search results page
   - [X] Infinite scroll for restaurant results.
   - [X] Implement map view of restaurant results.
- [X] Implement the restaurant detail page.

The following **additional** features are implemented:

- [X] Get user's current location for search 
- [X] Tapping the Phone Number successfully calls the restaurant from detail page (only visible on device, not in simulator)
- [X] Implement Filter Page to select food category (e.g. French, Indian, Italian, Mexican, etc) 
- [X] Implemented accessory on the mapview that segues to restaurant detail page 
- [X] Extended search to filter on results so mapview displays filtered results if applicable
- [X] Added App icon and launch screen 

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Recommend to add "StackViews" to the discussion/tutorial on Autolayout 

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/FleE4Ew.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with LiceCap(http://www.cockos.com/licecap/).

Icons obtained from iconMnstr.com

## Notes

Challenges encountered: getting the filtered data to correctly display across views; properly identifying the restaurants in mapview (required an additional array that then had to be cleared out with each viewing) 

## License

    Copyright 2017 Barbara Ristau 

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
