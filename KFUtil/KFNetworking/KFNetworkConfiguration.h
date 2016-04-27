//
//  KFNetworkConfiguration.h
//  KFUtilDemo
//
//  Created by KittyFeng on 4/27/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFNetworkConfiguration : NSObject

+ (instancetype)sharedConfiguration;

@property (nonatomic,copy) NSString *baseUrl;


@end
