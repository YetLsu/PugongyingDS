//
//  YYNewsCommentModel.m
//  pugongying
//
//  Created by wyy on 16/4/13.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYNewsCommentModel.h"

@implementation YYNewsCommentModel
- (instancetype)initWithiconURL:(NSString *)iconURLStr userName:(NSString *)userName commentStr:(NSString *)commentStr dateStr:(NSString *)dateStr{
    if (self = [super init]) {
        self.iconURLStr = iconURLStr;
        self.userName = userName;
        self.commentStr = commentStr;
        self.dateStr = dateStr;

    }
    return self;
}
@end
