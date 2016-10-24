# Project 2 - *Kraken Yelp*

**Kraken Yelp** is a Yelp search app using the [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: **∞** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] Search results page
   - [x] Table rows should be dynamic height according to the content height.
   - [x] Custom cells should have the proper Auto Layout constraints.
   - [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [x] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [x] The filters you should actually have are: category, sort (best match, distance, highest rated), distance, deals (on/off).
   - [x] The filters table should be organized into sections as in the mock.
   - [x] You can use the default UISwitch for on/off states.
   - [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   - [x] Display some of the available Yelp categories (choose any 3-4 that you want).

The following **optional** features are implemented:

- [x] Search results page
   - [x] Infinite scroll for restaurant results.
   - [x] Implement map view of restaurant results.
- [x] Filter page
   - [x] Implement a custom switch instead of the default UISwitch.
   - [ ] Distance filter should expand as in the real Yelp app
   - [ ] Categories should show a subset of the full list with a "See All" row to expand. Category list is [here](http://www.yelp.com/developers/documentation/category_list).
- [x] Implement the restaurant detail page.

The following **additional** features are implemented:

- [x] Using Custom Fonts - OpenSans.
- [x] Added Navigate using Maps from Restaurant Detail view.
- [x] When image fails, loads the Kraken Failed placeholder image.
- [x] Added MBProgressHUD for API calls.
- [x] Added Infinity Scroll.
- [x] Used [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet) - for showing empty datasets whenever the view has no content to display.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Filters view and expanding sections.
2. Location Services - when to call, best practises for avoiding battery drain while maintaining good location coordinates.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://github.com/semerda/CodePath-Yelp/blob/master/yelp-anim-v1.gif' title='Kraken Yelp Video Walkthrough' width='' alt='Kraken Yelp Video Walkthrough' loop=infinite />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Open-source libraries used

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - a delightful networking framework for iOS, OS X, watchOS, and tvOS.
- [MBProgressHUD](https://github.com/jdg/MBProgressHUD) - an iOS drop-in class that displays a translucent HUD with an indicator and/or labels while work is being done in a background thread.
- [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet) - for showing empty datasets whenever the view has no content to display.
- [SevenSwitch](https://github.com/bvogelzang/SevenSwitch) - drop in replacement for UISwitch (upgraded to Swift3)
- [INTULocationManager](https://github.com/intuit/LocationManager) - easily get the device's current location on iOS.

## License

Visit [www.ernestsemerda.com](http://www.ernestsemerda.com/)

    Copyright 2016 Ernest Semerda (http://www.ernestsemerda.com/)

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.