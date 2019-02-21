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

#pragma mark - default data
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
#endif
        _config = [[OWRuntimeDataConfig alloc] init];
        [_config setWaiting:DISPATCH_TIME_FOREVER]; //default: always waiting
    }
    return _config;
}

#pragma mark - sharedInstance
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

#pragma mark - implement functions
+ (void)config:(OWRuntimeDataConfig *)config {
    [[self sharedInstance] setConfig:config];
}

- (id)objectForKey:(NSString *)aKey {
    __block id result;
    if(aKey && aKey.length > 0) {
        OWRuntimeDataValue *value = [self valueForKey:aKey];
        BOOL forceFetch = NO;
        if([value deltaTime] != CACHE_DELTATIME_ALWAYS &&
           [value date] &&
           [value date] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSinceNow:0]) {
            forceFetch = YES;
        }
        if([value deltaTime] == CACHE_DELTATIME_DISABLE) {
            forceFetch = YES;
        }
        if(![value data] || forceFetch) {
            id<OWNetworkHandlerProtocol> handler;
            if([value networkHandler]) { //优先取当前handler
                handler = [value networkHandler];
            } else if([[self config] handler]) {
                handler = [[self config] handler];
            }
            if(handler && [handler conformsToProtocol:@protocol(OWNetworkHandlerProtocol)]) {
                //fetch放置于新的子线程去做，同时阻塞当前线程，因为数据需要保证优先获取，因此将该线程优先级调整为高
                dispatch_semaphore_t signal = dispatch_semaphore_create(0);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    id response = [handler fetch];
                    [self setObject:response forKey:aKey];
                    result = response;
                    dispatch_semaphore_signal(signal);
                });
                dispatch_semaphore_wait(signal, dispatch_time(DISPATCH_TIME_NOW, [[self config] waiting] * NSEC_PER_SEC));
            }
        }
        return [value data];
    }
    return nil;
}
+ (id)objectForKey:(NSString *)aKey {
    return [[OWRuntimeData sharedInstance] objectForKey:aKey];
}
- (void)objectForKeyAsync:(NSString *)aKey callback:(OWObjectBlock)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id result = [self objectForKey:aKey];
        //异步获取，主线程回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if(block) {
                block(result);
            }
        });
    });
}
+ (void)objectForKeyAsync:(NSString *)aKey callback:(OWObjectBlock)block {
    [[OWRuntimeData sharedInstance] objectForKeyAsync:aKey callback:block];
}

- (BOOL)setObject:(id)anObject forKey:(NSString *)aKey {
    if(anObject && aKey && aKey.length > 0 ) {
        OWRuntimeDataValue *value = [self valueForKey:aKey];
        [value setData:anObject];
        [value setDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        return YES;
    }
    return NO;
}
+ (BOOL)setObject:(id)anObject forKey:(NSString *)aKey {
    return [[OWRuntimeData sharedInstance] setObject:anObject forKey:aKey];
}

- (BOOL)registerHandler:(id<OWNetworkHandlerProtocol>)handler forKey:(NSString *)aKey {
    if(!aKey || aKey.length == 0) {
        return NO;
    }
    OWRuntimeDataValue *value = [self valueForKey:aKey];
    [value setNetworkHandler:handler];
    return YES;
}
+ (BOOL)registerHandler:(id<OWNetworkHandlerProtocol>)handler forKey:(NSString *)aKey {
    return [[OWRuntimeData sharedInstance] registFunction:function forKey:aKey];
}

#pragma mark - private
- (OWRuntimeDataValue *)valueForKey:(NSString *)aKey {
    if(aKey && aKey.length > 0) {
        if(![[[self runtimeData] allKeys] containsObject:aKey]) {
            OWRuntimeDataValue *value = [[OWRuntimeDataValue alloc] init];
            [[self runtimeData] setObject:value forKey:aKey];
        }
        OWRuntimeDataValue *object = [[self runtimeData] objectForKey:aKey];
        return object;
    }
    return nil;
}


@end
