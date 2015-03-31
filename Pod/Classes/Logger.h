//
//  Logger.h
//
//  Created by Виктор Дьячков on 08.08.14.
//  Copyright (c) 2014 Nestline. All rights reserved.
//

typedef enum {
    successEvent,
    failureEvent,
    infoEvent
} eventType;

@interface Logger : NSObject

# pragma mark - Modern methods

+ (void) initWithConsoleReporting:(BOOL)consoleReporting
               writeTimeInConsole:(BOOL)writeTimeInConsole
                  debugDictionary:(NSDictionary*)debugDictionary
                     flurryApiKey:(NSString*)flurryApiKey
                     flurryUserID:(NSString*)flurryUserID;

+ (void) log:(eventType)type title:(NSString*)title withDebugString:(NSString*)format, ...;
+ (void) log:(eventType)type title:(NSString*)title withDebugDict:(NSDictionary*)debugDict;

+ (void) log:(eventType)type withAlert:(NSString*)title message:(NSString*)message debugString:(NSString*)format, ...;
+ (void) log:(eventType)type withAlert:(NSString*)title message:(NSString*)message debugDict:(NSDictionary*)debugDict;

@end
