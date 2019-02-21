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
#import "OWNetworkProtocol.h"

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
 */
+ (void)setObject:(id)anObject forKey:(NSString *)aKey;
- (void)setObject:(id)anObject forKey:(NSString *)aKey;

/**
 delete object with key

 @param aKey key
 @return deletedObject
 */
+ (id)deleteObjectForKey:(NSString *)aKey;
- (id)deleteObjectForKey:(NSString *)aKey;

/**
 how to load data if data is not exist

 @param handler network handler
 @param deltaTime cache deltaTime(seconds)
 @param aKey key
 @return success
 */
+ (BOOL)registerHandler:(id<OWNetworkHandlerProtocol>)handler cache:(NSInteger)deltaTime forKey:(NSString *)aKey;
- (BOOL)registerHandler:(id<OWNetworkHandlerProtocol>)handler cache:(NSInteger)deltaTime forKey:(NSString *)aKey;
//default deltaTime : always
+ (BOOL)registerHandler:(id<OWNetworkHandlerProtocol>)handler forKey:(NSString *)aKey;
- (BOOL)registerHandler:(id<OWNetworkHandlerProtocol>)handler forKey:(NSString *)aKey;

@end
