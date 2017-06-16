//
//  YYCourseCellModel.m
//  pugongying
//
//  Created by wyy on 16/2/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseCellModel.h"

@implementation YYCourseCellModel
- (instancetype)initWithID:(NSString *)ID courseID:(NSString *)courseID courseIndex:(NSString *)courseIndex courseTitle:(NSString *)courseTitle courseMediaURL:(NSString *)courseMediaUrl viewNum:(NSString *)viewNum{
    if (self = [super init]) {
        
        self.ID =  ID;
        self.courseID = courseID;
        self.courseIndex = courseIndex;
        self.courseTitle = courseTitle;
        self.courseMediaURL = courseMediaUrl;
        self.viewNum = viewNum;
        
    }
    return self;
}
@end
