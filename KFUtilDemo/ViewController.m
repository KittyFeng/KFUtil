//
//  ViewController.m
//  KFUtil
//
//  Created by KittyFeng on 3/1/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "ViewController.h"
#import "KFLogMacro.h"
#import "AFNetworking.h"
#import "KFRequestManager.h"
@interface ViewController ()

@property (nonatomic) KFRequestManager *requestManager;

@end

@implementation ViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //init
    self.requestManager = [KFRequestManager manager];
    
    //get
    [self.requestManager GET:@"http://123.57.33.218/odeum/app/musicConcert/history" requestID:@"123543" parameters:@{@"type":@"N",@"rows":@10,@"timestamp":@(-1)} success:^(id result) {
        NSLog(@"result:%@",result);
    } failure:^(NSString *errorDesc) {
        NSLog(@"%@",errorDesc);
    }];
    
    //download
    [self.requestManager DOWNLOAD:@"http://123.57.33.218/ayr_odeum/file/music/voice/13/10/0a8d941b720040b18b708a4d50265beb.mp3" requestID:@"((1))" method:@"GET" parameters:nil destinationPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"test.mp3"] progress:^(double fractionCompleted) {
        NSLog(@"%.1f",fractionCompleted);
    } success:^(id result) {
        NSLog(@"result:%@",result);
    } failure:^(NSString *errorDesc) {
        NSLog(@"ERROR:%@",errorDesc);
    }];
    
    //upload
    
    UIImage *image = [UIImage imageNamed:@"cat.JPG"];
    NSData *data = UIImageJPEGRepresentation(image, 0.6);
    [self.requestManager UPLOAD:@"http://www.qiuyuehui.com/date/uploadfile" requestID:@"((3))" parameters:@{@"fileType":@"0",@"token":@""} constructingBody:^(id formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"cat.JPG" mimeType:@"image/jpeg"];
    } progress:^(double fractionCompleted) {
        NSLog(@"%.2f",fractionCompleted);
    } success:^(id result) {
        NSLog(@"result:%@",result);
    } failure:^(NSString *errorDesc) {
        NSLog(@"ERROR:%@",errorDesc);
    }];
}

- (void)dealloc{
    [_requestManager cancelAll];
}

@end
