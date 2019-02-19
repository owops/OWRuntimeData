//
//  OWRuntimeDataConfig.h
//  OWRuntimeData
//
//  Created by Rango on 2019/2/18.
//  Copyright © 2019 Rango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OWRuntimeDataValue.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CACHE_DELTATIME) {
    CACHE_DELTATIME_DISABLE = 0,
    CACHE_DELTATIME_ALWAYS = -1,
};

typedef id(^OWNetworkHandler)(OWDataFunction function);

@interface OWRuntimeDataConfig : NSObject

//数据缓存时间
@property (nonatomic, assign) NSInteger deltaTime;

//网络执行Handler
@property (nonatomic, copy) OWNetworkHandler handler;

//等待时间
@property (nonatomic, assign) NSInteger waiting;

@end

NS_ASSUME_NONNULL_END
