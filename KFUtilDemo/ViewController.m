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
        _requestManager = [KFRequestManager manager];
    }
    return self;
}



- (void)viewDidLoad1
{
    [super viewDidLoad];
}

- (void)dealloc{
    
}

@end
