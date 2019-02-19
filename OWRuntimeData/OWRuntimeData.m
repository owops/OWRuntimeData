//
//  OWRuntimeData.m
//  OWRuntimeData
//
//  Created by Rango on 2019/2/18.
//  Copyright © 2019 Rango. All rights reserved.
//

#import "OWRuntimeData.h"
#import "OWRuntimeDataValue.h"

static OWRuntimeData *_sharedManager = nil;

@interface OWRuntimeData()

@property (nonatomic, strong) OWRuntimeDataConfig *config;

//数据字典
@property (nonatomic, strong) NSMutableDictionary<NSString *, OWRuntimeDataValue *> *runtimeData;

@end

@implementation OWRuntimeData

- (NSMutableDictionary<NSString *, OWRuntimeDataValue *> *)runtimeData {
    if(!_runtimeData) {
        _runtimeData = [NSMutableDictionary dictionary];
    }
    return _runtimeData;
}

- (OWRuntimeDataConfig *)config {
    if(!_config) {
#ifdef DEBUG
        NSLog(@"------Warning------\n%@\n-------end-------", @"未配置相关的NetworkHandler，可能导致数据不完整");
        _config = [[OWRuntimeDataConfig alloc] init];
        [_config setWaiting:DISPATCH_TIME_FOREVER];
        [_config setDeltaTime:CACHE_DELTATIME_ALWAYS];
#endif
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

- (id)objectForKey:(NSString *)aKey {
    if(aKey && aKey.length > 0) {
        if([[self config] handler]) {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                id response = [self config].handler([[[self runtimeData] objectForKey:aKey] function]);
                [[[self runtimeData] objectForKey:aKey] setData:response];
                dispatch_semaphore_wait(sema, [[self config] waiting]);
            });
        }
        return [[self runtimeData] objectForKey:aKey];
    }
    return nil;
}

- (BOOL)setObject:(id)anObject forKey:(NSString *)aKey {
    return [self setObject:anObject forKey:aKey forceUpdate:YES];
}

+ (id)objectForKey:(NSString *)aKey {
    if(aKey && aKey.length > 0) {
        if([[[OWRuntimeData sharedInstance] config] handler]) {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                id response = [[OWRuntimeData sharedInstance] config].handler([[[[OWRuntimeData sharedInstance] runtimeData] objectForKey:aKey] function]);
                [[[[OWRuntimeData sharedInstance] runtimeData] objectForKey:aKey] setData:response];
                dispatch_semaphore_wait(sema, [[[OWRuntimeData sharedInstance] config] waiting]);
            });
        }
        return [[[OWRuntimeData sharedInstance] runtimeData] objectForKey:aKey];
    }
    return nil;
}

+ (BOOL)setObject:(id)anObject forKey:(NSString *)aKey {
    return [[OWRuntimeData sharedInstance] setObject:anObject forKey:aKey forceUpdate:YES];
}

- (BOOL)setObject:(id)anObject forKey:(NSString *)aKey forceUpdate:(BOOL)forceUpdate {
    if(anObject && aKey && aKey.length > 0 ) {
        
        if(!forceUpdate && [self objectForKey:aKey]) {
            return NO;
        }
        [[self runtimeData] setObject:anObject forKey:aKey];
        return YES;
    }
    return NO;
}


@end
