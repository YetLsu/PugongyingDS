//
//  YYCourseCollectionCellModel.m
//  pugongying
//
//  Created by wyy on 16/2/25.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseCollectionCellModel.h"

@implementation YYCourseCollectionCellModel
- (instancetype)initWithcourseID:(NSString *)courseID categoryID:(NSString *)categoryID teacherID:(NSString *)teacherID title:(NSString *)title introduce:(NSString *)introduce courseimgurl:(NSString *)courseimgurl showImgurl:(NSString *)showImgurl listImgurl:(NSString *)listImgurl tags:(NSString *)tags feature:(NSString *)feature crowd:(NSString *)crowd seriesNum:(NSString *)seriesNum collectionNum:(NSString *)collectionNum commentNum:(NSString *)commentNum score:(NSString *)score{
    
    if (self = [super init]) {
        self.courseID = courseID;
        self.categoryID = categoryID;
        self.courseTeacherID = teacherID;
        self.courseTitle = title;
        self.courseIntroduce = introduce;
        self.courseimgurl = courseimgurl;
        self.courseShowimgurl = showImgurl;
        self.courseListimgurl = listImgurl;
        self.courseTags = tags;
        self.coursefFeature = feature;
        self.courseCrowd = crowd;
        self.courseSeriesNum = seriesNum;
        self.courseCollectionNum = collectionNum;
        self.courseCommentNum = commentNum;
        self.courseScore = score;
    }
    return self;
}
@end
