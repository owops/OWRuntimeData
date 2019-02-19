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
@interface OWRuntimeData : NSObject

+ (OWRuntimeData *)sharedInstance;

+ (void)config:(OWRuntimeDataConfig *)config;

+ (id)objectForKey:(NSString *)aKey;

+ (BOOL)setObject:(id)anObject forKey:(NSString *)aKey;

- (id)objectForKey:(NSString *)aKey;

// default forceUpdate: true
- (BOOL)setObject:(id)anObject forKey:(NSString *)aKey;

- (BOOL)setObject:(id)anObject forKey:(NSString *)aKey forceUpdate:(BOOL)forceUpdate;

@end
