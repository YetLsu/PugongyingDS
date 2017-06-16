//
//  YYCourseCommentModel.m
//  pugongying
//
//  Created by wyy on 16/2/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseCommentModel.h"

@implementation YYCourseCommentModel
- (instancetype)initWithiconURL:(NSString *)iconURLStr userName:(NSString *)userName commentStr:(NSString *)commentStr dateStr:(NSString *)dateStr commentScore:(NSString *)commentScore{
    if (self = [super init]) {
        self.iconURLStr = iconURLStr;
        self.userName = userName;
        self.commentStr = commentStr;
        self.dateStr = dateStr;
        self.commentScore = commentScore;
    }
    return self;
}
@end
