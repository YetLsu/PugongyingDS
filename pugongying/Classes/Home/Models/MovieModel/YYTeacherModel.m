//
//  YYTeacherModel.m
//  pugongying
//
//  Created by wyy on 16/2/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYTeacherModel.h"

@implementation YYTeacherModel
- (instancetype)initWithTeacherID:(NSString *)teacherID andIconURL:(NSString *)iconURLStr andName:(NSString *)teacherName andIntroduce:(NSString *)teacherIntroduce{
    if (self = [super init]) {
        self.teacherID = teacherID;
        self.teacherIconUrl = iconURLStr;
        self.teacherName = teacherName;
        self.teacherIntroduce = teacherIntroduce;
    }
    return self;
}
@end
