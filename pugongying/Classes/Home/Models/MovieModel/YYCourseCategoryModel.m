
//
//  YYCategoryModel.m
//  pugongying
//
//  Created by wyy on 16/4/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYCourseCategoryModel.h"

@implementation YYCourseCategoryModel

- (instancetype)initWithCategoryID:(NSString *)categoryID categoryName:(NSString *)categoryName categoryIcon:(NSString *)categoryIcon categoryCourseNum:(NSString *)categoryCourseNum{
    if (self = [super init]) {
        self.categoryID = categoryID;
        self.categoryName = categoryName;
        self.categoryIcon = categoryIcon;
        self.categoryCourseNum = categoryCourseNum;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.categoryID forKey:@"categoryID"];
    [aCoder encodeObject:self.categoryName forKey:@"categoryName"];
    [aCoder encodeObject:self.categoryIcon forKey:@"categoryIcon"];
    [aCoder encodeObject:self.categoryCourseNum forKey:@"categoryCourseNum"];
    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.categoryID = [aDecoder decodeObjectForKey:@"categoryID"];
        self.categoryName = [aDecoder decodeObjectForKey:@"categoryName"];
        self.categoryIcon = [aDecoder decodeObjectForKey:@"categoryIcon"];
        self.categoryCourseNum = [aDecoder decodeObjectForKey:@"categoryCourseNum"];
    }
    return self;
}
@end
