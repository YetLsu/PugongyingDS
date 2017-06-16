//
//  YYMyMessageModel.m
//  pugongying
//
//  Created by wyy on 16/4/20.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYMyMessageModel.h"

@implementation YYMyMessageModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.messageID = value;
    }
    else if ([key isEqualToString:@"create_dt"]) {
        self.createTime = value;
    }
}
@end
