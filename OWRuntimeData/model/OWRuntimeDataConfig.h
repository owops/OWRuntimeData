//
//  OWRuntimeDataConfig.h
//  OWRuntimeData
//
//  Created by Rango on 2019/2/18.
//  Copyright © 2019 Rango. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CACHE_DELTATIME) {
    CACHE_DELTATIME_DISABLE = 0,
    CACHE_DELTATIME_ALWAYS = -1,
};

@interface OWRuntimeDataConfig : NSObject

@property (nonatomic, assign) NSInteger deltaTime;

@end

NS_ASSUME_NONNULL_END
