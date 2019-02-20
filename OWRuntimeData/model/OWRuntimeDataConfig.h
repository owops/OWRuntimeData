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

typedef id(^OWNetworkHandler)(OWDataFunction function);

@interface OWRuntimeDataConfig : NSObject

//网络执行Handler 默认的获取方式
@property (nonatomic, strong) id<OWNetworkHandlerProtocol> handler;

//等待时间
@property (nonatomic, assign) NSInteger waiting;

@end

NS_ASSUME_NONNULL_END
