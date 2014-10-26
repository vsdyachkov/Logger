//
//  Logger.h
//
//  Created by Виктор Дьячков on 08.08.14.
//  Copyright (c) 2014 Nestline. All rights reserved.
//


@interface Logger : NSObject 


+ (void) initWithConsoleReporting:(BOOL) consoleReporting
                  debugDictionary: (NSDictionary*) debugDictionary
                     flurryApiKey: (NSString*) flurryApiKey
                     flurryUserID: (NSString*) flurryUserID;


+ (void) logSuccessWithTitle: (NSString*) title message:(NSString*) message debugString: (NSString*) hiddenString alert:(BOOL) isAlert;
+ (void) logSuccessWithTitle: (NSString*) title message:(NSString*) message debugDict: (NSDictionary*) debugDict alert:(BOOL) isAlert;

+ (void) logErrorWithTitle: (NSString*) title message:(NSString*) message debugString: (NSString*) hiddenString alert:(BOOL) isAlert;
+ (void) logErrorWithTitle: (NSString*) title message:(NSString*) message debugDict: (NSDictionary*) debugDict alert:(BOOL) isAlert;


@end
