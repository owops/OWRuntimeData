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

typedef id(^OWDataFunction)(id response);

@interface OWRuntimeDataValue : NSObject

@property (nonatomic, strong) id data;

@property (nonatomic, copy) OWDataFunction function;

@end

NS_ASSUME_NONNULL_END
