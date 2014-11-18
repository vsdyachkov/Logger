# Logger

[![CI Status](http://img.shields.io/travis/Victor/Logger.svg?style=flat)](https://travis-ci.org/Victor/Logger)
[![Version](https://img.shields.io/cocoapods/v/Logger.svg?style=flat)](http://cocoadocs.org/docsets/Logger)
[![License](https://img.shields.io/cocoapods/l/Logger.svg?style=flat)](http://cocoadocs.org/docsets/Logger)
[![Platform](https://img.shields.io/cocoapods/p/Logger.svg?style=flat)](http://cocoadocs.org/docsets/Logger)

This library is created for simple unified logging successful and unsuccessful events.

Using any of these tools is optional, and can be adjusted

## Usage

1) Add to your proj-Prefix.pch file line:

      #import "Logger.h"

2) Initialize module (ex. in AppDelegate) with:

    initWithConsoleReporting: (BOOL) consoleReporting
             debugDictionary: (NSDictionary*) debugDictionary
                flurryApiKey: (NSString*) flurryApiKey
                flurryUserID: (NSString*) flurryUserID

+ If you don't want any logs in console and flurry, use initWithConsoleReporting: NO
+ If you need logging some key/values at each time, use debugDictionary: your_dictionary
+ If you don't need flurry at all, use flurryApiKey: nil
+ If you don't need flurry user identification use flurryUserID: nil

3) For logging event use one of these functions with (optional) debug information in NSString or NSDictionary

                         log: (eventType)type 
                   withTitle: (NSString*)title 
                     message: (NSString*)message 
                       alert: (BOOL)isAlert 
                 debugString: (NSString*)format, ...;
      
                         log: (eventType)type 
                   withTitle: (NSString*)title 
                     message: (NSString*)message 
                       alert: (BOOL)isAlert 
                   debugDict: (NSDictionary*)debugDict;

<To run the example project, clone the repo, and run `pod install` from the Example directory first.>

## Requirements

iOS 4+ with ARC (including support iOS 8.1)

## Installation

Logger is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "Logger"

## Author

Victor, vsdyachkov@rambler.ru

## License

Logger is available under the MIT license. See the LICENSE file for more info.
