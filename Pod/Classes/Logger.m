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
#include <execinfo.h>

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

+ (void) log:(eventType)type withDebugString:(NSString*)format, ...
{
    NSString *msg;
    if (format) {
        va_list args;
        va_start(args, format);
        msg = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
    }
    
    NSString* title = [self senderClassMethod];
    if (enableLog) [self logConsoleWithType:type title:title message:nil debugString:msg debugDict:nil];
    if (enableLog) [self logFlurryWithType:type title:title message:nil debugString:msg debugDict:nil];
}

+ (void) log:(eventType)type withDebugDict:(NSDictionary*)debugDict
{
    NSString* title = [self senderClassMethod];
    if (enableLog) [self logConsoleWithType:type title:title message:nil debugString:nil debugDict:debugDict];
    if (enableLog) [self logFlurryWithType:type title:title message:nil debugString:nil debugDict:debugDict];
}

# pragma mark - Support methods

+ (NSString*) senderClassMethod
{
    __block NSString* senderClassMethod = @"Unknown sender";
    NSString* selfClassName = NSStringFromClass([self class]);
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
    [[NSThread callStackSymbols] enumerateObjectsUsingBlock:^(NSString* sourceString, NSUInteger idx, BOOL *stop)
     {
         NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString componentsSeparatedByCharactersInSet:separatorSet]];
         NSArray* classMethodArray;
         if (array.count > 0) classMethodArray = [array[1] componentsSeparatedByString: @" "];
         if (classMethodArray.count > 0)
         {
             NSString* classCaller = classMethodArray[0];
             NSString* methodCaller = classMethodArray[1];
             BOOL isCallerClass = ![classCaller isEqualToString:selfClassName];
             if (isCallerClass) {
                 senderClassMethod = [NSString stringWithFormat:@"[%@ %@]", classCaller, methodCaller];
                 *stop = YES;
             }
         }
     }];
    return senderClassMethod;
}

+ (NSString*) iconWithType:(eventType)type
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
    NSMutableString* logString = [NSMutableString stringWithFormat:@"%@",[self iconWithType:type]];
    if (title)      [logString appendFormat:@" %@",title];
    if (message)    [logString appendFormat:@", %@", message];
    if (debugDict)
    {
        NSMutableArray* arrayList = [NSMutableArray new];
        [debugDict.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             NSString* key = debugDict.allKeys[idx];
             NSString* value;
             
             if ([debugDict.allValues[idx] isKindOfClass:[NSArray class]])
             {
                 NSArray* array = debugDict.allValues[idx];
                 value = [array componentsJoinedByString:@", "];
             }
             else if  ([debugDict.allValues[idx] isKindOfClass:[NSMutableArray class]])
             {
                 NSMutableArray* array = debugDict.allValues[idx];
                 value = [array componentsJoinedByString:@", "];
             }
             else
             {
                 value = [NSString stringWithFormat:@"%@", debugDict.allValues[idx]];
             }
             key = (key.length > 0) ? [NSString stringWithFormat:@" └> %@", key] : @" └> nil";
             value = (value.length > 0) ? value : @"nil";
             [arrayList addObject:[NSString stringWithFormat:@"%@: %@", key, value]];
         }];
        [logString appendFormat:@"\n%@", [arrayList componentsJoinedByString:@"\n"]];
    }
    if (debugString)[logString appendFormat:@"\n └> %@", debugString];
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
    NSString* method = [self senderClassMethod];
    
    NSMutableDictionary* flurryParameters = [NSMutableDictionary dictionary];
    if (method) [flurryParameters setValue:method forKey:@"method"];
    if ([NSDate date]) [flurryParameters setValue:[NSString stringWithFormat:@"%@",[NSDate date]] forKey:@"date"];
    if (addParams) [flurryParameters addEntriesFromDictionary:addParams];
    if (message) [flurryParameters setValue:message forKey:@"message"];
    if (debugString) [flurryParameters setValue:debugString forKey:@"debugString"];
    if (debugDict) [flurryParameters addEntriesFromDictionary:debugDict];
    
    NSString* flurryTitle = [NSString stringWithFormat:@"%@ %@", [self iconWithType:type], title];
    if (enableLog) [Flurry logEvent:flurryTitle withParameters:flurryParameters];
}


@end
