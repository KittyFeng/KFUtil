//
//  UIView+Frame.h
//  KFUtil
//
//  Created by KittyFeng on 3/11/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

///---getter---

- (CGFloat)height;
- (CGFloat)width;

- (CGFloat)top;
- (CGFloat)bottom;
- (CGFloat)left;
- (CGFloat)right;



///---setter---
- (void) setHeight:(CGFloat)height;
- (void) setWidth:(CGFloat)width;

- (void) setTop:(CGFloat)top;
- (void) setBottom:(CGFloat)bottom;
- (void) setLeft:(CGFloat)left;
- (void) setRight:(CGFloat)right;




@end
