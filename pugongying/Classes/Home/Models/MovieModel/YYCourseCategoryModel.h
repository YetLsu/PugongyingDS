//
//  YYCategoryModel.h
//  pugongying
//
//  Created by wyy on 16/4/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCourseCategoryModel : NSObject<NSCoding>
/**
*  分类id
*/
@property (nonatomic, copy) NSString *categoryID;
/**
 *  类名
 */
@property (nonatomic, copy) NSString *categoryName;
/**
 *  图标地址
 */
@property (nonatomic, copy) NSString *categoryIcon;
/**
 *  拥有的课程数
 */
@property (nonatomic, copy) NSString *categoryCourseNum;

- (instancetype)initWithCategoryID:(NSString *)categoryID categoryName:(NSString *)categoryName categoryIcon:(NSString *)categoryIcon categoryCourseNum:(NSString *)categoryCourseNum;
@end
