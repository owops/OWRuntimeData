//
//  OWRuntimeData.h
//  OWRuntimeData
//
//  Created by Rango on 2019/2/18.
//  Copyright © 2019 Rango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "OWRuntimeDataConfig.h"

//! Project version number for OWRuntimeData.
FOUNDATION_EXPORT double OWRuntimeDataVersionNumber;

//! Project version string for OWRuntimeData.
FOUNDATION_EXPORT const unsigned char OWRuntimeDataVersionString[];

typedef void(^OWObjectBlock)(id data);

@interface OWRuntimeData : NSObject

/**
 sharedInstance

 @return OWRuntimeData *
 */
+ (OWRuntimeData *)sharedInstance;

/**
 configs

 @param config OWRuntimeDataConfig
 */
+ (void)config:(OWRuntimeDataConfig *)config;

/**
 getObjectForKey in RuntimeData

 @param aKey key
 @return object
 */
+ (id)objectForKey:(NSString *)aKey; //sync method (maybe block mainThread)
- (id)objectForKey:(NSString *)aKey; //sync method (maybe block mainThread)
+ (void)objectForKeyAsync:(NSString *)aKey callback:(OWObjectBlock)block; //async method
- (void)objectForKeyAsync:(NSString *)aKey callback:(OWObjectBlock)block; //async method

/**
 setObject with key

 @param anObject object
 @param aKey key
 @param forceUpdate if need force update data
 @return success
 */
- (BOOL)setObject:(id)anObject forKey:(NSString *)aKey forceUpdate:(BOOL)forceUpdate;
//default forceUpdate: true
+ (BOOL)setObject:(id)anObject forKey:(NSString *)aKey;
//default forceUpdate: true
- (BOOL)setObject:(id)anObject forKey:(NSString *)aKey;

/**
 how to load data if data is not exist

 @param function id(^OWDataFunction)(id request);
 @param aKey key
 @return success
 */
+ (BOOL)registFunction:(OWDataFunction)function forKey:(NSString *)aKey;
- (BOOL)registFunction:(OWDataFunction)function forKey:(NSString *)aKey;

@end
