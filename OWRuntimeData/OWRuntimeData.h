//
//  OWRuntimeData.h
//  OWRuntimeData
//
//  Created by Rango on 2019/2/18.
//  Copyright © 2019 Rango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "model/OWRuntimeDataConfig.h"

@interface OWRuntimeData : NSObject

+ (OWRuntimeData *)sharedInstance;

+ (void)config:(OWRuntimeDataConfig *)config;

- (id)objectForKey:(id)aKey;

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end
