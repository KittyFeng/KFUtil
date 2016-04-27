//
//  LogMacro.h
//  KFUtil
//
//  Created by KittyFeng on 3/11/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#ifndef KFLogMacro_h
#define KFLogMacro_h


#ifdef DEBUG

#define KFLogObject(KEY,VALUE)   NSLog(@"[KFLOG::%@]:%@",KEY,VALUE)
#define KFLogInt(KEY,VALUE)      NSLog(@"[KFLOG::%@]:%d",KEY,VALUE)
#define KFLogFloat(KEY,VALUE)    NSLog(@"[KFLOG::%@]:%f",KEY,VALUE)

#define KFLogError(ErrorDesc)    NSLog(@"[KFLOG::ERROR]:%@",ErrorDesc)

#define KFLogMarkPosition        NSLog(@"[KFLOG::Position Mark]:%@\n%s(line:%d)",NSStringFromClass([self class]),__func__,__LINE__)
#define KFLogMethodIn            NSLog(@"[KFLOG::Method In]:%s(line:%d)",__func__,__LINE__)
#define KFLogMethodOut           NSLog(@"[KFLOG::Method Out]:%s(line:%d)",__func__,__LINE__)

#define KFLogSubviews(VIEW)      NSLog(@"[KFLOG::Subviews]:VIEW:%@\nSUBVIEWS:%@",VIEW,[VIEW subviews])

#else

#define KFLogObject(KEY,VALUE)
#define KFLogInt(KEY,VALUE)
#define KFLogFloat(KEY,VALUE)

#define KFLogError(ErrorDesc)

#define KFMethodIn
#define KFMethodOut
#define KFMarkPosition
#define KFLogSubviews(VIEW)


#endif



#endif /* LogMacro_h */






