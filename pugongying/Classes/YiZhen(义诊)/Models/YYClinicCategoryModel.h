//
//  YYClinicCategoryModel.h
//  pugongying
//
//  Created by wyy on 16/5/3.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYClinicCategoryModel : NSObject<NSCoding>
/**
 *  义诊分类ID
 */
@property (nonatomic, copy) NSString *clinicCategoryID;
/**
 *  义诊名称
 */
@property (nonatomic, copy) NSString *name;
@end
