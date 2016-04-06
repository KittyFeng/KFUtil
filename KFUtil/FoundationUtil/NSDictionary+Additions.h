//
//  NSDictionary+Additions.h
//  KFUtil
//
//  Created by KittyFeng on 3/18/16.
//  Copyright © 2016 KittyFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)


- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

- (NSInteger)getIntegerValueForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue;

- (float)getFloatValueValueForKey:(NSString *)key defaultValue:(float)defaultValue;
- (double)getDoubleValueValueForKey:(NSString *)key defaultValue:(double)defaultValue;

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

- (NSDictionary *)getDictionaryForKey:(NSString *)key defaultDictionary:(NSDictionary *)defaultDic;

- (NSArray *)getArrayForKey:(NSString *)key defaultArray:(NSArray *)defaultArray;



@end
