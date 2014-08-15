//
//  Logger.m
//  AZNews
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

+ (void) setDebugDictionary: (NSDictionary*) setParams
{
    addParams = setParams;
}

+ (void) logErrorWithTitle: (NSString*) title message:(NSString*) message debugString: (NSString*) hiddenString alert:(BOOL) isAlert
{
    
    if (isAlert) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    if (enableLog) {
        NSMutableString* logString = [NSMutableString new];
        [logString appendString:title];
        if (message)  [logString appendFormat:@", %@",message];
        if (hiddenString) [logString appendFormat:@", %@",hiddenString];
        NSLog(@"### Error:   %@", logString);
        
        NSString* errTitle = [NSString stringWithFormat:@"# Error:   %@", title];
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        if ([NSDate date]) [parameters setValue:[NSDate date] forKey:@"ts"];
        if (addParams) [parameters addEntriesFromDictionary:addParams];
        if (message) [parameters setValue:message forKey:@"message"];
        if (hiddenString) [parameters setValue:hiddenString forKey:@"hiddenString"];
        [Flurry logEvent:errTitle withParameters:parameters];
    }

}

+ (void) logSuccessWithTitle: (NSString*) title message:(NSString*) message debugString: (NSString*) hiddenString alert:(BOOL) isAlert
{
    
    if (isAlert) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    if (enableLog) {
        NSMutableString* logString = [NSMutableString new];
        [logString appendString:title];
        if (message)  [logString appendFormat:@", %@",message];
        if (hiddenString) [logString appendFormat:@", %@",hiddenString];
        NSLog(@"### Success: %@", logString);
        
        NSString* errTitle = [NSString stringWithFormat:@"### Success: %@", title];
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        if ([NSDate date]) [parameters setValue:[NSDate date] forKey:@"ts"];
        if (addParams) [parameters addEntriesFromDictionary:addParams];
        if (message) [parameters setValue:message forKey:@"message"];
        if (hiddenString) [parameters setValue:hiddenString forKey:@"hiddenString"];
        [Flurry logEvent:errTitle withParameters:parameters];
    }
    
}



@end
