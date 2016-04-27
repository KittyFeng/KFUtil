//
//  FYRequestManager.h
//  KFUtil
//
//  Created by KittyFeng on 3/18/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "KFHTTPSessionManager.h"

@interface KFRequestManager : NSObject

//KFRequestManager对象所持有的session manager，默认为KFHTTPSessionManager单例
@property (nonatomic,strong) KFHTTPSessionManager *httpSessionManager;

///返回一个KFRequestManager对象
+ (instancetype )manager;

- (void)GET:(NSString *)URLString
  requestID:(NSString *)requestID
 parameters:(NSDictionary *)parameters
    success:(void (^)(id result))success
    failure:(void (^)(NSString *errorDesc))failure;

- (void)POST:(NSString *)URLString
   requestID:(NSString *)requestID
  parameters:(NSDictionary *)parameters
     success:(void (^)(id result))success
     failure:(void (^)(NSString *errorDesc))failure;

- (void)UPLOAD:(NSString *)URLString
     requestID:(NSString *)requestID
    parameters:(NSDictionary *)parameters
constructingBody:(void (^)(id formData))constructingBody
      progress:(void (^)(double fractionCompleted))progress
       success:(void (^)(id result))success
       failure:(void (^)(NSString *errorDesc))failure;

- (void)DOWNLOAD:(NSString *)URLString
       requestID:(NSString *)requestID
          method:(NSString *)method
      parameters:(NSDictionary *)parameters
 destinationPath:(NSString *)destinationPath
        progress:(void (^)(double fractionCompleted))progress
         success:(void (^)(id result))success
         failure:(void (^)(NSString *errorDesc))failure;


- (void)cancelRequest:(NSString *)requestID;

- (void)cancelAll;

- (void)cancelRequestExceptFor:(NSArray *)requestIDs;

@end
