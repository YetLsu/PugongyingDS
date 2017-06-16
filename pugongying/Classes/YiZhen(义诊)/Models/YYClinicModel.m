//
//  YYYiZhenCaseModel.m
//  pugongying
//
//  Created by wyy on 16/3/7.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYClinicModel.h"
#import "YYYizhenUserModel.h"

@implementation YYClinicModel
- (instancetype)initWithClinicID:(NSString *)clinicID userModel:(YYYizhenUserModel *)userModel adminModel:(YYYizhenUserModel *)adminModel categoryid:(NSString *)categoryid title:(NSString *)title elem1:(NSString *)elem1 elem2:(NSString *)elem2 elem3:(NSString *)elem3 elem4:(NSString *)elem4 content:(NSString *)content result:(NSString *)result done:(NSString *)done replyTime:(NSString *)replyTime createTime:(NSString *)createTime{
    if (self = [super init]) {
        self.clinicID = clinicID;
        self.userModel = userModel;
        self.administratorModel = adminModel;
        self.categoryid = categoryid;
        self.title = title;
        self.elem1 = elem1;
        self.elem2 = elem2;
        self.elem3 = elem3;
        self.elem4 = elem4;
        self.content = content;
        self.result = result;
        self.done = done;
        self.replyTime = replyTime;
        self.createTime = createTime;
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self.clinicID = value;
    }
    else if ([key isEqualToString:@"create_dt"]){
        self.createTime = value;
    }
    else if ([key isEqualToString:@"reply_dt"]){
        self.replyTime = value;
    }
}

@end
