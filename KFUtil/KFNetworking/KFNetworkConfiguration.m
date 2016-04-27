//
//  KFNetworkConfiguration.m
//  KFUtilDemo
//
//  Created by KittyFeng on 4/27/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "KFNetworkConfiguration.h"

@implementation KFNetworkConfiguration


+ (instancetype)sharedConfiguration{
    static KFNetworkConfiguration *_sharedConfiguration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConfiguration = [[KFNetworkConfiguration alloc]init];

    });
    return _sharedConfiguration;
}

@end
