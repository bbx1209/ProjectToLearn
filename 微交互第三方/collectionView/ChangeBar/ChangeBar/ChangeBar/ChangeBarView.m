//
//  ChangeBarView.m
//  ChangeBar
//
//  Created by 程科 on 2016/12/5.
//  Copyright © 2016年 程科. All rights reserved.
//

#import "ChangeBarView.h"
#import "ChangeBarCollectionViewCell.h"

@interface ChangeBarView () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSArray * _dataArray;
    CGSize _oneSize;
    
    NSInteger _isCheck;
}

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIView * lineView;


@end

@implementation ChangeBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setView];
        
        _isCheck = 0;
    }
    return self;
}


#pragma mark - -- 视图
- (void)setView {
    
    
}


#pragma mark - --
- (void)showChangeBarViewOneSize:(CGSize)size andData:(NSArray *)arr {
    
    _oneSize = size;
    _dataArray = arr;
    
    [self addSubview:self.collectionView];
}


#pragma mark - -- 方法

#pragma mark 将当前row置于正中
- (void)willPlaceInTheMiddleOfRow:(NSInteger)row {
    
    BOOL canMove = [self canMoveOfRow:row];
    if (canMove) {
        
        CGFloat x = (row + 0.5) * _oneSize.width - self.bounds.size.width / 2;
        [self moveRow:CGPointMake(x, 0)];
    }
    else {
        
        CGSize size = self.collectionView.contentSize;
        CGPoint point = self.collectionView.contentOffset;
        if (point.x == 0 || point.x == size.width - self.bounds.size.width) {
            
            [self moveRow:self.collectionView.contentOffset];
            return;
        }
        
        NSInteger maxCount = self.bounds.size.width / (CGFloat)_oneSize.width;
        if (row < maxCount / 2.0) {
            
            [self moveRow:CGPointMake(0, 0)];
        }
        else {
            
            [self moveRow:CGPointMake(size.width - self.bounds.size.width, 0)];
        }
    }
}
#pragma mark 判断当前row是否处在可移动区域
- (BOOL)canMoveOfRow:(NSInteger)row {
    
    NSInteger maxCount = self.bounds.size.width / (CGFloat)_oneSize.width;
    if (row < maxCount / 2.0 || (_dataArray.count  - 1) - row < maxCount / 2.0) {
        
        return NO;
    }
    
    return YES;
}
#pragma mark 移动row动画
- (void)moveRow:(CGPoint)point {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.3];
    self.collectionView.contentOffset = point;
    self.lineView.center = CGPointMake(_oneSize.width * (_isCheck + 0.5), self.lineView.center.y);
    [UIView commitAnimations];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.collectionView reloadData];
    });
}


#pragma mark - -- UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ChangeBarCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChangeBarCollectionViewCell" forIndexPath:indexPath];
    
    [cell showChangeBarCollectionView:_dataArray[indexPath.row] andIsCheck:indexPath.row == _isCheck];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _isCheck = indexPath.row;
    
// 将当前点击row置于正中
    [self willPlaceInTheMiddleOfRow:indexPath.row];
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(ChangeBarDelegate)]) {
        
        [self.delegate clickCurrentRow:indexPath];
    }
}


#pragma mark - -- 懒加载

#pragma mark collectionView
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = _oneSize;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor orangeColor];
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ChangeBarCollectionViewCell class] forCellWithReuseIdentifier:@"ChangeBarCollectionViewCell"];
        
        [_collectionView addSubview:self.lineView];
    }
    
    return _collectionView;
}

#pragma mark lineView
- (UIView *)lineView {

    if (!_lineView) {
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _oneSize.height - 2, _oneSize.width, 2)];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    
    return _lineView;
}



@end
