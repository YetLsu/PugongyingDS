//
//  YYWebViewController.h
//  pugongying
//
//  Created by wyy on 16/3/4.
//  Copyright © 2016年 WYY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYInformationModel;
@interface YYWebViewController : UIViewController
- (instancetype)initWithModel:(YYInformationModel *)model andnewsCategoryID:(NSString *)categoryID;
@end
