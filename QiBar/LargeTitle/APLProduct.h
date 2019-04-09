//
//  AppDelegate.m
//  QiNavigationBar
//
//  Created by wangdacheng on 2019/3/26.
//  Copyright © 2019 dac_1033. All rights reserved.
//

#import "Foundation/Foundation.h"

@interface APLProduct : NSObject <NSCoding>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *hardwareType;
@property (nonatomic, copy) NSNumber *yearIntroduced;
@property (nonatomic, copy) NSNumber *introPrice;

+ (APLProduct *)productWithType:(NSString *)type name:(NSString *)name year:(NSNumber *)year price:(NSNumber *)price;

+ (NSArray *)deviceTypeNames;
+ (NSString *)displayNameForType:(NSString *)type;

+ (NSString *)deviceTypeTitle;
+ (NSString *)desktopTypeTitle;
+ (NSString *)portableTypeTitle;

@end
