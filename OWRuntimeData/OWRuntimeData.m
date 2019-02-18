//
//  OWRuntimeData.m
//  OWRuntimeData
//
//  Created by Rango on 2019/2/18.
//  Copyright © 2019 Rango. All rights reserved.
//

#import "OWRuntimeData.h"

static OWRuntimeData *_sharedManager = nil;

@interface OWRuntimeData()

@property (nonatomic, strong) OWRuntimeDataConfig *config;

//数据字典
@property (nonatomic, strong) NSMutableDictionary *dic;

@end

@implementation OWRuntimeData

- (NSMutableDictionary *)dic {
    if(!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

- (OWRuntimeDataConfig *)config {
    if(!_config) {
        _config = [[OWRuntimeDataConfig alloc] init];
        [_config setDeltaTime:CACHE_DELTATIME_ALWAYS];
    }
    return _config;
}

#pragma mark - 数据单例
+ (OWRuntimeData *)sharedInstance {
    @synchronized (self) {
        if(!_sharedManager) {
            _sharedManager = [[self alloc] init];
        }
    }
    return _sharedManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized (self) {
        if(!_sharedManager) {
            _sharedManager = [super allocWithZone:zone];
            return _sharedManager;
        }
    }
    return _sharedManager;
}

#pragma mark - functions
+ (void)config:(OWRuntimeDataConfig *)config {
    [[self sharedInstance] setConfig:config];
}

- (id)objectForKey:(id)aKey {
    return nil;
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
}

@end
