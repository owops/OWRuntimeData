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
        if([[self config] handler]) {
            dispatch_semaphore_t signal = dispatch_semaphore_create(0);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                id response = [self config].handler([[[self runtimeData] objectForKey:aKey] function]);
                [[[self runtimeData] objectForKey:aKey] setData:response];
                result = response;
                dispatch_semaphore_signal(signal);
            });
            dispatch_semaphore_wait(signal, dispatch_time(DISPATCH_TIME_NOW, [[self config] waiting] * NSEC_PER_SEC));
        }
    }
    return result;
}
+ (id)objectForKey:(NSString *)aKey {
    return [[OWRuntimeData sharedInstance] objectForKey:aKey];
}
- (void)objectForKeyAsync:(NSString *)aKey callback:(OWObjectBlock)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id result = [self objectForKey:aKey];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if(block) {
                block(result);
            }
        });
    });
}
+ (void)objectForKeyAsync:(NSString *)aKey callback:(OWObjectBlock)block {
    [[OWRuntimeData sharedInstance] objectForKeyAsync:aKey callback:block];
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
- (BOOL)setObject:(id)anObject forKey:(NSString *)aKey {
    return [self setObject:anObject forKey:aKey forceUpdate:YES];
}
+ (BOOL)setObject:(id)anObject forKey:(NSString *)aKey {
    return [[OWRuntimeData sharedInstance] setObject:anObject forKey:aKey];
}

- (BOOL)registFunction:(OWDataFunction)function forKey:(NSString *)aKey {
    if(!aKey || aKey.length == 0) {
        return NO;
    }
    OWRuntimeDataValue *dataValue;
    if([[[self runtimeData] allKeys] containsObject:aKey]) {
        dataValue = [[self runtimeData] objectForKey:aKey];
    } else {
        dataValue = [[OWRuntimeDataValue alloc] init];
        [[self runtimeData] setObject:dataValue forKey:aKey];
    }
    [dataValue setFunction:function];
    return YES;
}
+ (BOOL)registFunction:(OWDataFunction)function forKey:(NSString *)aKey {
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
