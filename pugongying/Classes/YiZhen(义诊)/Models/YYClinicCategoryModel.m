//
//  YYClinicCategoryModel.m
//  pugongying
//
//  Created by wyy on 16/5/3.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import "YYClinicCategoryModel.h"

@implementation YYClinicCategoryModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.clinicCategoryID = value;
    }

}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.clinicCategoryID forKey:@"clinicCategoryID"];
    [aCoder encodeObject:self.name forKey:@"clinicCategoryName"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.clinicCategoryID = [aDecoder decodeObjectForKey:@"clinicCategoryID"];
        self.name = [aDecoder decodeObjectForKey:@"clinicCategoryName"];
    }
    return self;
}
@end
