//
//  YYNewsCategoryModel.h
//  pugongying
//
//  Created by wyy on 16/4/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYNewsCategoryModel : NSObject<NSCoding>

/**
 * 资讯分类ID
 */
@property (nonatomic, copy) NSString *newsCategoryID;
/**
 * 类名
 */
@property (nonatomic, copy) NSString *newsCategoryName;
/**
 * 拥有的资讯数
 */
@property (nonatomic, copy) NSString *newsCategoryNewsNum;

- (instancetype)initWithnewsCategoryID:(NSString *)newsCategoryID newsCategoryName:(NSString *)newsCategoryName newsCategoryNewsNum:(NSString *)newsCategoryNewsNum;


@end
