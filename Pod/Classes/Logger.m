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


@implementation Logger

static NSDictionary* addParams = nil;

static BOOL enableLog = false;
static BOOL isInitialized = false;
static NSString* initErrMsg = @"Please configure this module, call 'initWithEnableLoging...' before use logging";


+ (void) initWithConsoleReporting: (BOOL) consoleReporting
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


+ (void) logSuccessWithTitle: (NSString*) title message:(NSString*) message debugString: (NSString*) debugString alert:(BOOL) isAlert
{
    NSAssert(isInitialized, initErrMsg);
    if (isAlert) [self alertWithTitle:title message:message];
    [self setTitle:title message:message debugString:debugString debugDict:nil isSuccess:YES];
}

+ (void) logSuccessWithTitle: (NSString*) title message:(NSString*) message debugDict: (NSDictionary*) debugDict alert:(BOOL) isAlert
{
    NSAssert(isInitialized, initErrMsg);
    if (isAlert) [self alertWithTitle:title message:message];
    [self setTitle:title message:message debugString:nil debugDict:debugDict isSuccess:YES];
}


+ (void) logErrorWithTitle: (NSString*) title message:(NSString*) message debugString: (NSString*) debugString alert:(BOOL) isAlert
{
    NSAssert(isInitialized, initErrMsg);
    if (isAlert) [self alertWithTitle:title message:message];
    [self setTitle:title message:message debugString:debugString debugDict:nil isSuccess:NO];
}

+ (void) logErrorWithTitle: (NSString*) title message:(NSString*) message debugDict: (NSDictionary*) debugDict alert:(BOOL) isAlert
{
    NSAssert(isInitialized, initErrMsg);
    if (isAlert) [self alertWithTitle:title message:message];
    [self setTitle:title message:message debugString:nil debugDict:debugDict isSuccess:NO];
}


+ (void) alertWithTitle: (NSString*) title message: (NSString*) message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
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


@end
