//
//  KFHTTPSessionManager.m
//  KFUtilDemo
//
//  Created by KittyFeng on 4/26/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "KFHTTPSessionManager.h"
#import "KFNetworkConfiguration.h"


@interface KFHTTPSessionMannager : AFHTTPSessionManager



@end

@implementation KFHTTPSessionManager


+ (instancetype )sharedManager{
    static KFHTTPSessionManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[KFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:[KFNetworkConfiguration sharedConfiguration].baseUrl]];
    });
    return _sharedManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url{
    return [self initWithBaseURL:url sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration{
    self = [super initWithBaseURL:url sessionConfiguration:sessionConfiguration];
    
    if (self){
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    }
    return self;
}


//- (void)configureBaseUrl:(NSString *)baseUrl{
//    self.baseURL = baseUrl;
//}


@end
