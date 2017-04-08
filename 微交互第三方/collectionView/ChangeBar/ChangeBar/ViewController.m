//
//  ViewController.m
//  ChangeBar
//
//  Created by 程科 on 2016/12/5.
//  Copyright © 2016年 程科. All rights reserved.
//

#import "ViewController.h"
#import "ChangeBarView.h"

@interface ViewController () <ChangeBarDelegate>

@property (nonatomic, strong) ChangeBarView * cbView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cbView = [[ChangeBarView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 40)];
    [self.view addSubview:self.cbView];
    
    self.cbView.delegate = self;
    CGSize size = CGSizeMake(CGRectGetWidth(self.cbView.frame) / 4, CGRectGetHeight(self.cbView.frame));
    NSArray * arr = @[@"全部",@"热门游戏",@"手游休闲",@"鱼乐新天地",@"鱼秀",@"颜值",@"科技",@"文娱课堂",@"体育频道"];
    [self.cbView showChangeBarViewOneSize:size andData:arr];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - -- ChangeBarDelegate
- (void)clickCurrentRow:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld",indexPath.row);
}



@end
