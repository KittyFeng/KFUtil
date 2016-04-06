//
//  UIView+Frame.m
//  KFUtil
//
//  Created by KittyFeng on 3/11/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

///---getter---

- (CGFloat) height{
    return self.frame.size.height;
}
- (CGFloat) width{
    return self.frame.size.width;
}

- (CGFloat)top{
    return self.frame.origin.y;
}

- (CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)left{
    return self.frame.origin.x;
}

- (CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGPoint)origin{
    return self.frame.origin;
}


///---setter---
- (void)setHeight:(CGFloat)height{
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
}

- (void)setWidth:(CGFloat)width{
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
}

- (void)setTop:(CGFloat)top{
    CGRect newFrame = self.frame;
    newFrame.origin.y = top;
    self.frame = newFrame;
}

- (void)setBottom:(CGFloat)bottom{
    CGRect newFrame = self.frame;
    newFrame.origin.y  = bottom - newFrame.size.height;
    self.frame = newFrame;
}
- (void)setLeft:(CGFloat)left{
    CGRect newFrame = self.frame;
    newFrame.origin.x  = left;
    self.frame = newFrame;
}
- (void)setRight:(CGFloat)right{
    CGRect newFrame = self.frame;
    newFrame.origin.x  = right - newFrame.size.width;
    self.frame = newFrame;
}




@end
