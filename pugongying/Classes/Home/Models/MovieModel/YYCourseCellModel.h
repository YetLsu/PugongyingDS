//
//  YYCourseCellModel.h
//  pugongying
//
//  Created by wyy on 16/2/26.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYCourseCellModel : NSObject
/**
 *  课件id
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  课程id
 */
@property (nonatomic, copy) NSString *courseID;
/**
 *  课程序号(第几节)
 */
@property (nonatomic, copy) NSString *courseIndex;
/**
 *  课程标题
 */
@property (nonatomic, copy) NSString *courseTitle;
/**
 *  课程视频的URL字符串
 */
@property (nonatomic, copy) NSString *courseMediaURL;
/**
 *  观看人次
 */
@property (nonatomic, copy) NSString *viewNum;

- (instancetype)initWithID:(NSString *)ID courseID:(NSString *)courseID courseIndex:(NSString *)courseIndex courseTitle:(NSString *)courseTitle courseMediaURL:(NSString *)courseMediaUrl viewNum:(NSString *)viewNum;


@end
