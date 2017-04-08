//
//  ChangeBarCollectionViewCell.m
//  ChangeBar
//
//  Created by 程科 on 2016/12/5.
//  Copyright © 2016年 程科. All rights reserved.
//

#import "ChangeBarCollectionViewCell.h"

@implementation ChangeBarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setView];
    }
    return self;
}


#pragma mark - -- 视图
- (void)setView {
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.label];
}


#pragma mark - -- 
- (void)showChangeBarCollectionView:(NSString *)type andIsCheck:(BOOL)isCheck {
    
    self.label.text = type;
    
    if (isCheck) {
        
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont systemFontOfSize:16];
    }
    else {
        
        self.label.textColor = [UIColor colorWithWhite:0.95 alpha:1];
        self.label.font = [UIFont systemFontOfSize:15];
    }
}


@end
