//
//  YYNewsCategoryModel.m
//  pugongying
//
//  Created by wyy on 16/4/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYNewsCategoryModel.h"

@implementation YYNewsCategoryModel

- (instancetype)initWithnewsCategoryID:(NSString *)newsCategoryID newsCategoryName:(NSString *)newsCategoryName newsCategoryNewsNum:(NSString *)newsCategoryNewsNum{
    if (self = [super init]) {
        self.newsCategoryID = newsCategoryID;
        self.newsCategoryName = newsCategoryName;
        self.newsCategoryNewsNum = newsCategoryNewsNum;
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.newsCategoryID forKey:@"newsCategoryID"];
    [aCoder encodeObject:self.newsCategoryName forKey:@"newsCategoryName"];
    [aCoder encodeObject:self.newsCategoryNewsNum forKey:@"newsCategoryNewsNum"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.newsCategoryID = [aDecoder decodeObjectForKey:@"newsCategoryID"];
        self.newsCategoryName = [aDecoder decodeObjectForKey:@"newsCategoryName"];
        self.newsCategoryNewsNum = [aDecoder decodeObjectForKey:@"newsCategoryNewsNum"];
    }
    
    return self;
}
@end
