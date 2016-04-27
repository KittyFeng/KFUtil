//
//  KFRequestManager.m
//  KFUtil
//
//  Created by KittyFeng on 3/18/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "KFRequestManager.h"
#import "NSDictionary+Additions.h"


#define kBaseURLString @""

#warning you can change the name here
#define kBundle @"com.orgnization.name"

#warning you can change the tempatery cache folder here
#define kDefaultCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

static NSUInteger globalRequestId = 0;

typedef NS_ENUM(NSUInteger,KFRequestMethod) {
    KFRequestMethodGet = 1,
    KFRequestMethodPost = 2,
    KFRequestMethodUpload = 3,
    KFRequestMethodDownload = 4,
};

typedef NS_ENUM(int, JYRequestErrors) {
    kKFRequestErrorTokenInvalid = 10,
    kKFRequestErrorCancelled = -999,
};


#pragma mark -
#pragma mark -

//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////

@interface KFRequestInfo : NSObject

@property (nonatomic,copy) NSString *urlString;
@property (nonatomic,assign) KFRequestMethod requestMethod;
@property (nonatomic,strong) NSDictionary *params;
@property (nonatomic,copy) void (^success)(id result);
@property (nonatomic,copy) void (^failure)(id errorDesc);
@property (nonatomic,copy) void (^progress)(double fractionCompleted);
@property (nonatomic,copy) NSString *downloadMethod;
@property (nonatomic,copy) NSString *downloadDestinationPath;
@property (nonatomic,copy) void (^constructingBody)(id formData);

- (instancetype)initWithURLString:(NSString *)URLString
                    requestMethod:(KFRequestMethod)requestMethod
                           params:(NSDictionary *)params
                          success:(void(^)(id result))success
                          failure:(void(^)(NSString *errorDesc))failure
          downloadDestinationPath:(NSString *)downloadDestinationPath
                         progress:(void (^)(double fractionCompleted))progress
                   downloadMethod:(NSString *)downloadMethod
                 constructingBody:(void (^)(id formData))constructingBody;
@end



@implementation KFRequestInfo

- (instancetype)initWithURLString:(NSString *)URLString
                    requestMethod:(KFRequestMethod)requestMethod
                           params:(NSDictionary *)params
                          success:(void(^)(id result))success
                          failure:(void(^)(NSString *errorDesc))failure
          downloadDestinationPath:(NSString *)downloadDestinationPath
                         progress:(void (^)(double fractionCompleted))progress
                   downloadMethod:(NSString *)downloadMethod
                 constructingBody:(void (^)(id formData))constructingBody{
    self = [super init];
    if (self) {
        _urlString = URLString;
        _params = params;
        _success = success;
        _failure = failure;
        _requestMethod = requestMethod;
        _progress = progress;
        _downloadMethod = downloadMethod;
        _downloadDestinationPath = downloadDestinationPath;
        _constructingBody = constructingBody;
    }
    return self;
}

@end



//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark -

@interface KFRequestManager()

@property (nonatomic) NSMutableDictionary *requestInfoDic;              //requestID - KFRequestInfo pairs
@property (nonatomic) NSMutableDictionary *sessionTaskDic;              //requestID - session task pairs

@end

@implementation KFRequestManager


#pragma mark - init


- (instancetype)init
{
    self = [super init];
    if (self) {
        _httpSessionManager = [KFHTTPSessionManager sharedManager];
        _requestInfoDic = [NSMutableDictionary dictionary];
        _sessionTaskDic = [NSMutableDictionary dictionary];
    }
    return self;
}


#pragma mark - public methods


+ (instancetype) manager{
    return [[self alloc]init];
}


- (void)GET:(NSString *)URLString
  requestID:(NSString *)requestID
 parameters:(NSDictionary *)parameters
    success:(void (^)(id result))success
    failure:(void (^)(NSString *errorDesc))failure{
    if (!requestID) {
        requestID = [self autoRequestID];
    }
    
    BOOL addInfo = [self addRequestInfoWithRequestID:requestID URLString:URLString parameters:parameters success:success failure:failure requestMethod:KFRequestMethodGet downloadDestinationPath:nil progress:nil downloadMethod:nil constructingBody:nil];
    if (!addInfo) {
        return;
    }
    
    [self httpRequestWithMethod:KFRequestMethodGet URLString:URLString requestID:requestID parameters:parameters success:success failure:failure];
    
}

- (void)POST:(NSString *)URLString
   requestID:(NSString *)requestID
  parameters:(NSDictionary *)parameters
     success:(void (^)(id result))success
     failure:(void (^)(NSString *errorDesc))failure{
    if (!requestID) {
        requestID = [self autoRequestID];
    }
    
    BOOL addInfo = [self addRequestInfoWithRequestID:requestID URLString:URLString parameters:parameters success:success failure:failure requestMethod:KFRequestMethodPost downloadDestinationPath:nil progress:nil downloadMethod:nil constructingBody:nil];
    if (!addInfo) {
        return;
    }
    
    [self httpRequestWithMethod:KFRequestMethodPost URLString:URLString requestID:requestID parameters:parameters success:success failure:failure];
}

//+ (void)appendPartForFormData:(id)formData
//                     filePath:(NSString *)filePath
//                         name:(NSString *)name
//                     fileName:(NSString *)fileName
//                     mimeType:(NSString *)mimeType
//{
//    NSString *uploadName = name ? name : @"stream";
//    NSString *uploadFileName = fileName ? fileName : [filePath lastPathComponent];
//    NSString *uploadMIMEType = mimeType ? mimeType : @"application/octet-stream";
//    
//    [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:uploadName fileName:uploadFileName mimeType:uploadMIMEType error:nil];
//}
//
//+ (void)appendPartForFormData:(id)formData
//                     fileData:(NSData *)data
//                         name:(NSString *)name
//                     fileName:(NSString *)fileName
//                     mimeType:(NSString *)mimeType  //content-type
//{
//    NSString *uploadName = name ? name : @"stream";
//    NSString *uploadMIMEType = mimeType ? mimeType : @"application/octet-stream";
//    
//    [formData appendPartWithFileData:data name:uploadName fileName:fileName mimeType:uploadMIMEType];
//}

- (void)UPLOAD:(NSString *)URLString
     requestID:(NSString *)requestID
    parameters:(NSDictionary *)parameters
constructingBody:(void (^)(id formData))constructingBody
      progress:(void (^)(double fractionCompleted))progress
       success:(void (^)(id result))success
       failure:(void (^)(NSString *errorDesc))failure{
    
    if (!requestID) {
        requestID = [self autoRequestID];
    }
    
    BOOL addInfo = [self addRequestInfoWithRequestID:requestID URLString:URLString parameters:parameters success:success failure:failure requestMethod:KFRequestMethodUpload downloadDestinationPath:URLString progress:progress downloadMethod:nil constructingBody:constructingBody];
    
    if (!addInfo) {
        return;
    }
    
    [self uploadTask:URLString requestID:requestID parameters:parameters constructingBody:constructingBody progress:progress success:success failure:failure];
}

- (void)DOWNLOAD:(NSString *)URLString
       requestID:(NSString *)requestID
          method:(NSString *)method
      parameters:(NSDictionary *)parameters
 destinationPath:(NSString *)destinationPath
        progress:(void (^)(double fractionCompleted))progress
         success:(void (^)(id result))success
         failure:(void (^)(NSString *errorDesc))failure
{
    if (!requestID) {
        requestID = [self autoRequestID];
    }
    
    BOOL result = [self addRequestInfoWithRequestID:requestID URLString:URLString parameters:parameters success:success failure:failure requestMethod:KFRequestMethodDownload downloadDestinationPath:URLString progress:progress downloadMethod:method constructingBody:nil];
    if (!result) {
        return;
    }
    
    [self downloadTask:URLString requestID:requestID method:method parameters:parameters destinationPath:destinationPath progress:progress success:success failure:failure];
}

- (void)refreshRequestsWithNewKey:(NSString *)key andValue:(id)value{
    NSArray *requestIDs = [self.requestInfoDic allKeys];
    for (NSString *requestID in requestIDs) {
        KFRequestInfo *requestInfo = [self.requestInfoDic objectForKey:requestID];
        
        NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:requestInfo.params];
        newParams[key] = value;
        requestInfo.params = newParams;
        
        switch (requestInfo.requestMethod) {
            case KFRequestMethodGet:
            case KFRequestMethodPost:
                [self httpRequestWithMethod:requestInfo.requestMethod URLString:requestInfo.urlString requestID:requestID parameters:requestInfo.params success:requestInfo.success failure:requestInfo.failure];
                break;
            case KFRequestMethodDownload:
                [self downloadTask:requestInfo.urlString requestID:requestID method:requestInfo.downloadMethod parameters:requestInfo.params destinationPath:requestInfo.downloadMethod progress:requestInfo.progress success:requestInfo.success failure:requestInfo.failure];
                break;
            case KFRequestMethodUpload:
                [self uploadTask:requestInfo.urlString requestID:requestID parameters:requestInfo.params constructingBody:requestInfo.constructingBody progress:requestInfo.progress success:requestInfo.success failure:requestInfo.failure];
                break;
            default:
                break;
        }
    }
}

- (void)cancelRequest:(NSString *)requestID{
    NSURLSessionTask *sessionTask = self.sessionTaskDic[requestID];
    [sessionTask cancel];
    [self.sessionTaskDic removeObjectForKey:requestID];
    [self.requestInfoDic removeObjectForKey:requestID];
}

- (void)cancelAll{
    NSArray *allTasks = [self.sessionTaskDic allValues];
    [allTasks makeObjectsPerformSelector:@selector(cancel)];
    [self.sessionTaskDic removeAllObjects];
    [self.requestInfoDic removeAllObjects];
}

- (void)cancelRequestExceptFor:(NSArray *)requestIDs{
    [self.sessionTaskDic removeObjectsForKeys:requestIDs];
    [self cancelAll];
}


#pragma mark - private methods

#pragma mark request id

- (NSString *)autoRequestID{
    return [NSString stringWithFormat:@"%@.requestId.%@",kBundle,@(globalRequestId)];
}

#pragma mark add for request info dic
- (BOOL)addRequestInfoWithRequestID:(NSString *)requestID
                          URLString:(NSString *)URLString
                         parameters:(NSDictionary *)parameters
                            success:(void (^)(id result))success
                            failure:(void (^)(NSString *errorDesc))failure
                      requestMethod:(KFRequestMethod)requestMethod
            downloadDestinationPath:(NSString *)downloadDestinationPath
                           progress:(void (^)(double fractionCompleted))progress
                     downloadMethod:(NSString *)downloadMethod
                   constructingBody:(void (^)(id formData))constructingBody{
    if ([self.requestInfoDic objectForKey:requestID]) {
        return NO;
    }
    
    KFRequestInfo *requestInfo = [[KFRequestInfo alloc]initWithURLString:requestID
                                                           requestMethod:requestMethod
                                                                  params:parameters
                                                                 success:success
                                                                 failure:failure
                                                 downloadDestinationPath:downloadDestinationPath
                                                                progress:progress
                                                          downloadMethod:downloadMethod
                                                        constructingBody:constructingBody];
    [self.requestInfoDic setObject:requestInfo forKey:requestID];
    return YES;
}


#pragma mark add for session dic
- (BOOL)addSessionTaskWithRequestID:(NSString *)requestID
                        sessionTask:(id)sessionTask
{
    if ([self.sessionTaskDic objectForKey:requestID]) {
        return NO;
    }
    
    [self.sessionTaskDic setObject:sessionTask forKey:requestID];
    
    return YES;
}


#pragma mark deal with results
- (void)dealSuccessWithRequest:(NSString *)requestID responseObject:(id)responseObject success:(void(^)(id result))success{
    id result = responseObject;
    [self.sessionTaskDic removeObjectForKey:requestID];;
    [self.requestInfoDic removeObjectForKey:requestID];
    if (success) {
        success(result);
    }
    
}

- (void)dealFailureWithRequest:(NSString *)requestID errorDesc:(NSString *)errorDesc errorCode:(NSInteger)errorCode failure:(void(^)(NSString *errorDesc))failure{
    [self.sessionTaskDic removeObjectForKey:requestID];;
    [self.requestInfoDic removeObjectForKey:requestID];
    if(failure){
        failure(errorDesc);
    }
}


#pragma mark post & get
- (void)httpRequestWithMethod:(KFRequestMethod)requestMethod
                    URLString:(NSString *)URLString
                    requestID:(NSString *)requestID
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(id result))success
                      failure:(void (^)(NSString *errorDesc))failure{
    void(^successBlock)(NSURLSessionTask *task, id responseObject) = ^(NSURLSessionTask *task, id responseObject){
        [self dealSuccessWithRequest:requestID responseObject:responseObject success:success];
    };
    
    void(^failureBlock)(NSURLSessionTask *task, NSError *error) = ^(NSURLSessionTask *task,NSError *error){
        [self dealFailureWithRequest:requestID errorDesc:error.localizedDescription errorCode:error.code failure:failure];
    };
    NSURLSessionDataTask * sessionTask = nil;
    switch (requestMethod) {
        case KFRequestMethodGet:
            sessionTask = [self.httpSessionManager GET:URLString parameters:parameters progress:nil success:successBlock failure:failureBlock];
            break;
        case KFRequestMethodPost:
            sessionTask = [self.httpSessionManager POST:URLString parameters:parameters progress:nil success:successBlock failure:failureBlock];
            break;
        default:
            break;
    }
    
    
    if (sessionTask) {
        [self addSessionTaskWithRequestID:requestID sessionTask:sessionTask];
    }
    
}


#pragma mark upload

- (void)uploadTask:(NSString *)URLString
         requestID:(NSString *)requestID
        parameters:(NSDictionary *)parameters
  constructingBody:(void (^)(id formData))constructingBody
          progress:(void (^)(double fractionCompleted))progress
           success:(void (^)(id result))success
           failure:(void (^)(NSString *errorDesc))failure
{
    if (self.httpSessionManager.baseURL) {
        URLString = [NSString stringWithFormat:@"%@%@",self.httpSessionManager.baseURL.absoluteString,URLString];
    }
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:parameters constructingBodyWithBlock:constructingBody error:nil];
    
    NSString *tmpFileName = [NSString stringWithFormat:@"mlt_r_%f",[[NSDate date] timeIntervalSince1970]];
    NSURL *tmpFileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:tmpFileName]];
    
    [[AFHTTPRequestSerializer serializer] requestWithMultipartFormRequest:request writingStreamContentsToFile:tmpFileURL completionHandler:^(NSError *error) {
        NSURLSessionUploadTask *uploadTask = [self.httpSessionManager uploadTaskWithRequest:request fromFile:tmpFileURL progress:^(NSProgress *uploadProgress) {
            if (progress) {
                progress(uploadProgress.fractionCompleted);
            }
        } completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            [[NSFileManager defaultManager] removeItemAtURL:tmpFileURL error:nil];
            
            if (error) {
                [self dealFailureWithRequest:requestID errorDesc:error.localizedDescription errorCode:error.code failure:failure];
                return;
            }
            
            [self dealSuccessWithRequest:requestID responseObject:responseObject success:success];
        }];
        
        [uploadTask resume];
        
        if (uploadTask) {
            [self addSessionTaskWithRequestID:requestID sessionTask:uploadTask];
        }
    }];
}



#pragma mark download
- (NSString *)downloadDefaultPathWithMIMEType:(NSString *)MIMEType requestID:(NSString *)requestID {
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",requestID,MIMEType];
    return [kDefaultCachePath stringByAppendingPathComponent:fileName];
}


- (void)downloadTask:(NSString *)URLString
           requestID:(NSString *)requestID
              method:(NSString *)method
          parameters:(NSDictionary *)parameters
     destinationPath:(NSString *)destinationPath
            progress:(void (^)(double fractionCompleted))progress
             success:(void (^)(id result))success
             failure:(void (^)(NSString *errorDesc))failure
{
    if (self.httpSessionManager.baseURL) {
        URLString = [NSString stringWithFormat:@"%@%@",self.httpSessionManager.baseURL,URLString];
    }
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer]requestWithMethod:method URLString:URLString parameters:parameters error:nil];
    NSURLSessionDownloadTask *downloadTask = [self.httpSessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
//            NSLog(@"%@",downloadProgress);
            progress(downloadProgress.fractionCompleted);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (destinationPath) {
            return [NSURL fileURLWithPath:destinationPath];
        }
        NSString *defaultPath = [self downloadDefaultPathWithMIMEType:response.MIMEType requestID:requestID];
        return [NSURL fileURLWithPath:defaultPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if(error){
            [self dealFailureWithRequest:requestID errorDesc:error.localizedDescription errorCode:error.code failure:failure];
            return;
        }
        
        if (!filePath) {
            [self dealFailureWithRequest:requestID errorDesc:@"下载路径为空" errorCode:0 failure:failure];
            return;
        }
        
 
        [self dealSuccessWithRequest:requestID responseObject:filePath success:success];

    }];
    
    [downloadTask resume];
    
    if (downloadTask) {
        [self addSessionTaskWithRequestID:requestID sessionTask:downloadTask];
    }
}


#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"KFRequestManager Dealloc");
}

@end