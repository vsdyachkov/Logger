# Logger

[![CI Status](http://img.shields.io/travis/Victor/Logger.svg?style=flat)](https://travis-ci.org/Victor/Logger)
[![Version](https://img.shields.io/cocoapods/v/Logger.svg?style=flat)](http://cocoadocs.org/docsets/Logger)
[![License](https://img.shields.io/cocoapods/l/Logger.svg?style=flat)](http://cocoadocs.org/docsets/Logger)
[![Platform](https://img.shields.io/cocoapods/p/Logger.svg?style=flat)](http://cocoadocs.org/docsets/Logger)

This library is created for improvement of your code for work with information on successful and unsuccessful events, and also creation of uniform style of all information messages.

It will allow you to work at the same time with three tools: UIAlertView, console and flurry, using only one function. 
All actions can be optional and are simply adjusted.

## Usage

1) Add to your <proj>-Prefix.pch file line:

      #import "Logger.h"

2) Initialize module (ex. in AppDelegate) with:

      initWithEnableLoging: (BOOL) enableFlag
           globalDebugDict: (NSDictionary*) debugDictionary
             flurrySession: (NSString*) sessionSting
              flurryUserID: (NSString*) userString;


+ If you don't want any logs in console and flurry, use initWithEnableLoging: NO
+ If you only don't want to use flurry, use flurrySession: nil
+ If you don't use flurry user identification use flurryUserID: nil
+ If you need logging some key/values at each time, use globalDebugDict: your_dictionary


3) At each important event use one of function with (optional) debug information in NSString or NSDictionary:

       logSuccessWithTitle: (NSString*) title 
                   message: (NSString*) message 
               debugString: (NSString*) hiddenString 
                     alert: (BOOL) isAlert

       logSuccessWithTitle: (NSString*) title 
                   message: (NSString*) message 
                 debugDict: (NSDictionary*) debugDict 
                     alert: (BOOL) isAlert


         logErrorWithTitle: (NSString*) title 
                   message: (NSString*) message 
               debugString: (NSString*) hiddenString 
                     alert: (BOOL) isAlert

         logErrorWithTitle: (NSString*) title 
                   message: (NSString*) message 
                 debugDict: (NSDictionary*) debugDict 
                     alert: (BOOL) isAlert


<To run the example project, clone the repo, and run `pod install` from the Example directory first.>

## Requirements

iOS 4+ with ARC

## Installation

Logger is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "Logger"

## Author

Victor, vsdyachkov@rambler.ru

## License

Logger is available under the MIT license. See the LICENSE file for more info.
