//
//  ChangeBarCollectionViewCell.h
//  ChangeBar
//
//  Created by 程科 on 2016/12/5.
//  Copyright © 2016年 程科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeBarCollectionViewCell : UICollectionViewCell

@property (nonnull, strong) UILabel * label;


- (void)showChangeBarCollectionView:(nonnull NSString *)type andIsCheck:(BOOL)isCheck;

@end
