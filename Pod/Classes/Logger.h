//
//  Logger.h
//  AZNews
//
//  Created by Виктор Дьячков on 08.08.14.
//  Copyright (c) 2014 Nestline. All rights reserved.
//



static BOOL enableLog = true;

@interface Logger : NSObject 
    

+ (void) setDebugDictionary: (NSDictionary*) setParams;

+ (void) logErrorWithTitle: (NSString*) title message:(NSString*) message debugString: (NSString*) hiddenString alert:(BOOL) isAlert;
+ (void) logSuccessWithTitle: (NSString*) title message:(NSString*) message debugString: (NSString*) hiddenString alert:(BOOL) isAlert;

@end
