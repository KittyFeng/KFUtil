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


#define NSLog(...) NSLog(__VA_ARGS__)

#else

#define NSLog(...)

#endif



#ifdef KFLogMode

#define KFLogObject(KEY,VALUE)   NSLog(@"[SLOG::%@]:%@",KEY,VALUE)
#define KFLogInt(KEY,VALUE)      NSLog(@"[SLOG::%@]:%d",KEY,VALUE)
#define KFLogFloat(KEY,VALUE)    NSLog(@"[SLOG::%@]:%f",KEY,VALUE)

#define KFLogError(ErrorDesc)    NSLog(@"[SLOG::ERROR]:%@",ErrorDesc)

#define KFLogMarkPosition        NSLog(@"[SLOG::Position Mark]:%@\n%s(line:%d)",NSStringFromClass([self class]),__func__,__LINE__)
#define KFLogMethodIn            NSLog(@"[SLOG::Method In]:%s(line:%d)",__func__,__LINE__)
#define KFLogMethodOut           NSLog(@"[SLOG::Method Out]:%s(line:%d)",__func__,__LINE__)

#define KFLogSubviews(VIEW)      NSLog(@"[SLOG::Subviews]:VIEW:%@\nSUBVIEWS:%@",VIEW,[VIEW subviews])

#else

#define KFLogObject(KEY,VALUE)
#define KFLogInt(KEY,VALUE)
#define KFLogFloat(KEY,VALUE)

#define KFLogError(ErrorDesc)

#define SMethodIn
#define SMethodOut
#define SMarkPosition
#define KFLogSubviews(VIEW)


#endif



#endif /* LogMacro_h */






