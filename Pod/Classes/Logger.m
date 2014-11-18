//
//  Logger.m
//
//  Created by Виктор Дьячков on 08.08.14.
//  Copyright (c) 2014 Nestline. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Logger.h"
#import "Flurry.h"

#define errInit         @"Please configure this module, call 'initWithEnableLoging...' before use logging"
#define errDeprecated   @"This method is deprecated, use:"

#define init_0_1_3      @"initWithConsoleReporting:debugDictionary:flurryApiKey:flurryUserID:"
#define logString_0_1_3 @"log:withTitle:message:alert:debugString:"
#define logDict_0_1_3   @"log:withTitle:message:alert:debugDict:"

@implementation Logger

static NSDictionary* addParams = nil;

static BOOL enableLog = false;
static BOOL isInitialized = false;

# pragma mark - Deprecated methods

+ (void) initWithEnableLoging: (BOOL) enableFlag globalDebugDict: (NSDictionary*) debugDictionary flurrySession: (NSString*) sessionSting flurryUserID: (NSString*) userString
{
    addParams = debugDictionary;
    enableLog = (enableFlag) ? enableFlag : false;
    [Flurry setLogLevel:enableLog];
    [Flurry setCrashReportingEnabled:YES];
    if (sessionSting) [Flurry startSession:sessionSting];
    if (userString) [Flurry setUserID:userString];
    isInitialized = true;
}

+ (void) logSuccessWithTitle: (NSString*) title message:(NSString*) message debugString: (NSString*) debugString alert:(BOOL) isAlert
{
    NSAssert(isInitialized, errInit);
    if (isAlert) [self alertWithTitle:title message:message];
    [self setTitle:title message:message debugString:debugString debugDict:nil isSuccess:YES];
}

+ (void) logSuccessWithTitle: (NSString*) title message:(NSString*) message debugDict: (NSDictionary*) debugDict alert:(BOOL) isAlert
{
    NSAssert(isInitialized, errInit);
    if (isAlert) [self alertWithTitle:title message:message];
    [self setTitle:title message:message debugString:nil debugDict:debugDict isSuccess:YES];
}


+ (void) logErrorWithTitle: (NSString*) title message:(NSString*) message debugString: (NSString*) debugString alert:(BOOL) isAlert
{
    NSAssert(isInitialized, errInit);
    if (isAlert) [self alertWithTitle:title message:message];
    [self setTitle:title message:message debugString:debugString debugDict:nil isSuccess:NO];
}

+ (void) logErrorWithTitle: (NSString*) title message:(NSString*) message debugDict: (NSDictionary*) debugDict alert:(BOOL) isAlert
{
    NSAssert(isInitialized, errInit);
    if (isAlert) [self alertWithTitle:title message:message];
    [self setTitle:title message:message debugString:nil debugDict:debugDict isSuccess:NO];
}

+ (void) setTitle: (NSString*) title
          message: (NSString*) message
      debugString: (NSString*) debugString
        debugDict: (NSDictionary*) debugDict
        isSuccess: (BOOL) success
{
    if (!enableLog) return;
    
    NSString* resultSting = (success) ? @"### Success: " : @"### Error:   ";
    
    NSMutableString* logString = [NSMutableString new];
    if (title) [logString appendString:title];
    if (message)  [logString appendFormat:@", %@",message];
    
    NSString* infoTitle = [NSString stringWithFormat:@"%@%@", resultSting, title];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if ([NSDate date]) [parameters setValue:[NSDate date] forKey:@"ts"];
    if (addParams) [parameters addEntriesFromDictionary:addParams];
    if (message) [parameters setValue:message forKey:@"message"];
    
    if (debugString) {
        [logString appendFormat:@", %@",debugString];
        [parameters setValue:debugString forKey:@"hiddenString"];
    }
    
    if (debugDict) {
        [logString appendFormat:@", %@",debugDict];
        [parameters addEntriesFromDictionary:debugDict];
    }
    
    NSLog(@"%@%@", resultSting, logString);
    [Flurry logEvent:infoTitle withParameters:parameters];
}

# pragma mark - Modern methods

+ (void) initWithConsoleReporting:(BOOL) consoleReporting
                  debugDictionary: (NSDictionary*) debugDictionary
                     flurryApiKey: (NSString*) flurryApiKey
                     flurryUserID: (NSString*) flurryUserID
{
    addParams = debugDictionary;
    enableLog = (consoleReporting) ? consoleReporting : false;
    [Flurry setLogLevel:enableLog];
    [Flurry setCrashReportingEnabled:YES];
    if (flurryApiKey) [Flurry startSession:flurryApiKey];
    if (flurryUserID) [Flurry setUserID:flurryUserID];
    isInitialized = true;
}

+ (void) log:(eventType)type withTitle:(NSString*)title message:(NSString*)message alert:(BOOL)isAlert debugString:(NSString*)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    if (isAlert) [self alertWithTitle:title message:message];
    if (enableLog) [self logConsoleWithType:type title:title message:message debugString:msg debugDict:nil];
    if (enableLog) [self logFlurryWithType:type title:title message:message debugString:msg debugDict:nil];
    
    if (isAlert) [self alertWithTitle:title message:message];
    if (enableLog) [self logConsole:type title:title message:message debugString:formattedString debugDict:nil];
    if (enableLog) [self logFlurry:type title:title message:message debugString:formattedString debugDict:nil];
}

+ (void) log:(eventType)type withTitle:(NSString*)title message:(NSString*)message alert:(BOOL)isAlert debugDict:(NSDictionary*)debugDict
{
    if (isAlert) [self alertWithTitle:title message:message];
    if (enableLog) [self logConsole:type title:title message:message debugString:nil debugDict:debugDict];
    if (enableLog) [self logFlurry:type title:title message:message debugString:nil debugDict:debugDict];
}

+ (NSString*) prefixWithEventType:(eventType)type
{
    switch (type) {
        case successEvent:  return @"[√]"; break;
        case failureEvent:  return @"[X]"; break;
        case infoEvent:     return @"[i]"; break;
    }
}

+ (void) alertWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

+ (void) logConsole:(eventType)type title:(NSString*)title message:(NSString*)message debugString:(NSString*)debugString debugDict:(NSDictionary*)debugDict
{
    NSMutableString* logString = [NSString stringWithFormat:@"%@ %@, %@", [self prefixWithEventType:type], title, message].mutableCopy;
    (debugDict) ? [logString appendFormat:@"%@", debugDict] : [logString appendFormat:@"%@", debugString];
    if (enableLog) NSLog(@"%@", logString);
}

+ (void) logFlurry:(eventType)type title:(NSString*)title message:(NSString*)message debugString:(NSString*)debugString debugDict:(NSDictionary*)debugDict
{
    NSMutableDictionary* flurryParameters = [NSMutableDictionary dictionary];
    if ([NSDate date]) [flurryParameters setValue:[NSDate date] forKey:@"ts"];
    if (addParams) [flurryParameters addEntriesFromDictionary:addParams];
    if (message) [flurryParameters setValue:message forKey:@"message"];
    if (debugString) [flurryParameters setValue:debugString forKey:@"debugString"];
    if (debugDict) [flurryParameters addEntriesFromDictionary:debugDict];
    
    NSString* flurryTitle = [NSString stringWithFormat:@"%@%@", [self prefixWithEventType:type], title];
    if (enableLog) [Flurry logEvent:flurryTitle withParameters:flurryParameters];
}


@end
