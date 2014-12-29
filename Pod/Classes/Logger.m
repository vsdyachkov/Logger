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

#define errInit @"Please configure this module, call 'initWithConsoleReporting...' before use logging"

@implementation Logger

static NSDictionary* addParams = nil;

static BOOL enableLog = false;
static BOOL isInitialized = false;
static BOOL logTime = false;

# pragma mark - Modern methods

+ (void) initWithConsoleReporting:(BOOL)consoleReporting
               writeTimeInConsole:(BOOL)writeTimeInConsole
                  debugDictionary:(NSDictionary*)debugDictionary
                     flurryApiKey:(NSString*)flurryApiKey
                     flurryUserID:(NSString*)flurryUserID
{
    addParams = debugDictionary;
    enableLog = (consoleReporting) ? consoleReporting : false;
    logTime = (writeTimeInConsole) ? writeTimeInConsole : false;
    [Flurry setLogLevel:enableLog];
    [Flurry setCrashReportingEnabled:YES];
    if (flurryApiKey) [Flurry startSession:flurryApiKey];
    if (flurryUserID) [Flurry setUserID:flurryUserID];
    isInitialized = true;
}

+ (void) log:(eventType)type withTitle:(NSString*)title message:(NSString*)message alert:(BOOL)isAlert debugString:(NSString*)format, ...
{
    NSString *msg;
    if (format) {
        va_list args;
        va_start(args, format);
        msg = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
    }
    
    if (isAlert) [self alertWithTitle:title message:message];
    if (enableLog) [self logConsoleWithType:type title:title message:message debugString:msg debugDict:nil];
    if (enableLog) [self logFlurryWithType:type title:title message:message debugString:msg debugDict:nil];
}

+ (void) log:(eventType)type withTitle:(NSString*)title message:(NSString*)message alert:(BOOL)isAlert debugDict:(NSDictionary*)debugDict
{
    if (isAlert) [self alertWithTitle:title message:message];
    if (enableLog) [self logConsoleWithType:type title:title message:message debugString:nil debugDict:debugDict];
    if (enableLog) [self logFlurryWithType:type title:title message:message debugString:nil debugDict:debugDict];
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

+ (void) logConsoleWithType:(eventType)type title:(NSString*)title message:(NSString*)message debugString:(NSString*)debugString debugDict:(NSDictionary*)debugDict
{
    NSMutableString* logString = [NSMutableString stringWithFormat:@"%@",[self prefixWithEventType:type]];
    if (title)      [logString appendFormat:@" %@",title];
    if (message)    [logString appendFormat:@", %@", message];
    if (debugDict)
    {
        NSMutableArray* arrayList = [NSMutableArray new];
        [debugDict.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             NSString* key = debugDict.allKeys[idx];
             NSString* value = [NSString stringWithFormat:@"%@", debugDict.allValues[idx]];
             key = (key.length > 0) ? [NSString stringWithFormat:@"    %@", key] : @"    nil";
             value = (value.length > 0) ? value : @"nil";
             [arrayList addObject:[NSString stringWithFormat:@"%@: %@", key, value]];
         }];
        [logString appendFormat:@"\n%@", [arrayList componentsJoinedByString:@"\n"]];
    }
    if (debugString)[logString appendFormat:@"\n%@", debugString];
    if (enableLog)
    {
        if (logTime)
        {
            NSLog(@"%@", logString);
        }
        else
        {
            printf("%s\n",[logString UTF8String]);
        }
    }
    
}

+ (void) logFlurryWithType:(eventType)type title:(NSString*)title message:(NSString*)message debugString:(NSString*)debugString debugDict:(NSDictionary*)debugDict
{
    NSMutableDictionary* flurryParameters = [NSMutableDictionary dictionary];
    if ([NSDate date]) [flurryParameters setValue:[NSDate date] forKey:@"ts"];
    if (addParams) [flurryParameters addEntriesFromDictionary:addParams];
    if (message) [flurryParameters setValue:message forKey:@"message"];
    if (debugString) [flurryParameters setValue:debugString forKey:@"debugString"];
    if (debugDict) [flurryParameters addEntriesFromDictionary:debugDict];
    
    NSString* flurryTitle = [NSString stringWithFormat:@"%@ %@", [self prefixWithEventType:type], title];
    if (enableLog) [Flurry logEvent:flurryTitle withParameters:flurryParameters];
}


@end
