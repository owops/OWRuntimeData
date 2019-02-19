//
//  OWRuntimeDataValue.h
//  OWRuntimeData
//
//  Created by Rango on 2019/2/18.
//  Copyright © 2019 Rango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OWNetworkProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef id(^OWDataFunction)(id __nullable request);

typedef NS_ENUM(NSInteger, CACHE_DELTATIME) {
    CACHE_DELTATIME_ALWAYS = 0,
    CACHE_DELTATIME_DISABLE = -1,
};

@interface OWRuntimeDataValue : NSObject

//具体内容数据
@property (nonatomic, strong) id data;

//数据获取方法
@property (nonatomic, copy) OWDataFunction function;

//数据超时时间
@property (nonatomic, assign) NSInteger deltaTime;

//数据缓存时间
@property (nonatomic, strong) NSDate *date;

@end

NS_ASSUME_NONNULL_END
