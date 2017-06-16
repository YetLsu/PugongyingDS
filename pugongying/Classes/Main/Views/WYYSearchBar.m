//
//  WYYSearchBar.m
//  weibo
//
//  Created by wyy on 15/10/31.
//  Copyright © 2015年 wyy. All rights reserved.
//

#import "WYYSearchBar.h"

@interface WYYSearchBar ()
@property (nonatomic, weak) UILabel *label;

@end

NSString *_placeholder;

@implementation WYYSearchBar
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:16];
        self.placeholder = _placeholder;
        self.textColor = [UIColor whiteColor];
        
        UILabel *label = [self valueForKey:@"placeholderLabel"];
        self.label = label;
        self.label.textColor = [UIColor whiteColor];
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon-1"];
        
        searchIcon.width = 40;
        searchIcon.height = 40;
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return self;
}

+ (instancetype)searchBarWithPlaceholderText:(NSString *)placeholder{
    _placeholder = placeholder;
    return [[self alloc] init];
}



@end
