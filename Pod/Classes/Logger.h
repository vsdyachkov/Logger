//
//  Logger.h
//
//  Created by Виктор Дьячков on 08.08.14.
//  Copyright (c) 2014 Nestline. All rights reserved.
//

typedef enum {
    successEvent,
    errorEvent,
    infoEvent
} eventType;


@interface Logger : NSObject

# pragma mark - Deprecated methods

+ (void) initWithEnableLoging: (BOOL) enableFlag globalDebugDict: (NSDictionary*) debugDictionary flurrySession: (NSString*) sessionSting flurryUserID: (NSString*) userString __attribute__((deprecated("Use: initWithConsoleReporting:debugDictionary:flurryApiKey:flurryUserID:")));
+ (void) logSuccessWithTitle: (NSString*) title message:(NSString*) message debugString: (NSString*) hiddenString alert:(BOOL) isAlert
__attribute__((deprecated("Use: log:withTitle:message:alert:debugString:")));
+ (void) logSuccessWithTitle: (NSString*) title message:(NSString*) message debugDict: (NSDictionary*) debugDict alert:(BOOL) isAlert
__attribute__((deprecated("Use: log:withTitle:message:alert:debugDict:")));
+ (void) logErrorWithTitle: (NSString*) title message:(NSString*) message debugString: (NSString*) hiddenString alert:(BOOL) isAlert
__attribute__((deprecated("Use: log:withTitle:message:alert:debugString:")));
+ (void) logErrorWithTitle: (NSString*) title message:(NSString*) message debugDict: (NSDictionary*) debugDict alert:(BOOL) isAlert
__attribute__((deprecated("Use: log:withTitle:message:alert:debugDict:")));


# pragma mark - Modern methods

+ (void) initWithConsoleReporting:(BOOL) consoleReporting
                  debugDictionary: (NSDictionary*) debugDictionary
                     flurryApiKey: (NSString*) flurryApiKey
                     flurryUserID: (NSString*) flurryUserID;

+ (void) log:(eventType)type withTitle:(NSString*)title message:(NSString*)message alert:(BOOL)isAlert debugString:(NSString*)format, ...;
+ (void) log:(eventType)type withTitle:(NSString*)title message:(NSString*)message alert:(BOOL)isAlert debugDict:(NSDictionary*)debugDict;

@end
