//
//  NSDictionary+Additions.m
//  KFUtil
//
//  Created by KittyFeng on 3/18/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    
    BOOL ret = defaultValue;
    if ([[self objectForKey:key] respondsToSelector:@selector(boolValue)]) {
        ret = [[self objectForKey:key] boolValue];
    }
    return ret;
}

- (NSInteger)getIntegerValueForKey:(NSString *)key defaultValue:(NSInteger)defaultValue {
    
    NSInteger ret = defaultValue;
    if ([[self objectForKey:key] respondsToSelector:@selector(integerValue)]) {
        ret = [[self objectForKey:key] integerValue];
    }
    return ret;
}

- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue {
    
    int ret = defaultValue;
    if ([[self objectForKey:key] respondsToSelector:@selector(intValue)]) {
        ret = [[self objectForKey:key] intValue];
    }
    return ret;
}

- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
    
    long long ret = defaultValue;
    if ([[self objectForKey:key] respondsToSelector:@selector(longLongValue)]) {
        ret = [[self objectForKey:key] longLongValue];
    }
    return ret;
}

- (float)getFloatValueValueForKey:(NSString *)key defaultValue:(float)defaultValue {
    
    float ret = defaultValue;
    if ([[self objectForKey:key] respondsToSelector:@selector(floatValue)]) {
        ret = [[self objectForKey:key] floatValue];
    }
    return ret;
}

- (double)getDoubleValueValueForKey:(NSString *)key defaultValue:(double)defaultValue{
    double ret = defaultValue;
    if ([[self objectForKey:key]respondsToSelector:@selector(doubleValue)]) {
        ret = [[self objectForKey:key]doubleValue];
    }
    return ret;
}

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    
    id ret = [self objectForKey:key];
    if ([ret isKindOfClass:[NSString class]]) {
        return [self objectForKey:key];
    }else if([ret respondsToSelector:@selector(stringValue)]){
        return [ret stringValue];
    }else {
        return defaultValue;
    }
}

- (NSDictionary *)getDictionaryForKey:(NSString *)key defaultDictionary:(NSDictionary *)defaultDic
{
    id ret = [self objectForKey:key];
    if ([ret isKindOfClass:[NSDictionary class]]) {
        return [self objectForKey:key];
    } else {
        return defaultDic;
    }
}

- (NSArray *)getArrayForKey:(NSString *)key defaultArray:(NSArray *)defaultArray
{
    id ret = [self objectForKey:key];
    if ([ret isKindOfClass:[NSArray class]]) {
        return [self objectForKey:key];
    } else {
        return defaultArray;
    }
}


@end


