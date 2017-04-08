//
//  ChangeBarView.h
//  ChangeBar
//
//  Created by 程科 on 2016/12/5.
//  Copyright © 2016年 程科. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeBarDelegate <NSObject>

@required
- (void)clickCurrentRow:(NSIndexPath *)indexPath;

@end

@interface ChangeBarView : UIView

@property (nonatomic, assign) id <ChangeBarDelegate> delegate;

/*
 * 切换bar，需要的值
 *
 * 参数一：一个type的size
 * 参数二：type数据
 */
- (void)showChangeBarViewOneSize:(CGSize)size andData:(NSArray *)arr;

@end
