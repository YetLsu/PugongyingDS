//
//  YYYizhenUserModel.m
//  pugongying
//
//  Created by wyy on 16/3/29.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYYizhenUserModel.h"

@interface YYYizhenUserModel()
@property (nonatomic, assign) NSInteger tag;

@end

@implementation YYYizhenUserModel
- (instancetype) initWithUserName:(NSString *)userName phone:(NSString *)phone sex:(NSString *)sex qq:(NSString *)qq userIconImgUrl:(NSString *)userIconImgUrl userID:(NSString *)userID{
    
    if (self = [super init]) {
        self.userName = userName;
        self.phone = phone;
        self.sex = sex;
        self.qq = qq;
        self.userIocnImgUrl = userIconImgUrl;
        self.userID = userID;
    }
    return self;
}
- (instancetype)initWithTag:(NSInteger)tag{
    if (self = [super init]) {
        self.tag = tag;
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if (self.tag == 0) {//用户
        if ([key isEqualToString:@"name"]) {
            self.userName = value;
        }
        else if ([key isEqualToString:@"headimgurl"]){
            if (value == [NSNull null]) {
                self.userIocnImgUrl = value;
            }
        }
        else if ([key isEqualToString:@"userid"]){
            self.userID = value;
        }
    }
}
@end
