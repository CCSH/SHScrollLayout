//
//  SHTableView.m
//  ScrollLayout
//
//  Created by CSH on 2018/9/15.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHTableView.h"

#define kSHContentScrollTop @"SHContentScrollTop"

@interface SHTableView ()<UIGestureRecognizerDelegate>

//主视图是否可以滚动(内容视图与它相反)
@property (nonatomic, assign) BOOL canScroll;

@end

@implementation SHTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        //默认主视图可以滚动
        self.canScroll = YES;
    }
    return self;
}

#pragma mark - SET
#pragma mark 设置内容视图偏移量
- (void)setCanScroll:(BOOL)canScroll{
    _canScroll = canScroll;
    
    //主视图可以滚动则子视图不可滚动
    for (SHViewController *obj in self.viewControllers) {
        //如果主视图滑动，修改所有子vc的状态回到顶部
        if (canScroll) {
            obj.tableView.contentOffset = CGPointZero;
        }
    }
}

#pragma mark - 多手势处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

#pragma mark - 处理滑动数据
- (void)dealMainScrollData{
    
    //找到悬浮的位置
    CGFloat headOffset = [self rectForSection:1].origin.y - self.headPosition;
    
    if (self.contentOffset.y >= headOffset) {//达到了规定位置、父视图不可滚动
        
        self.contentOffset = CGPointMake(0, headOffset);
        
        if (self.canScroll) {
            self.canScroll = NO;
        }
    }else{//达到了规定位置、父视图可滚动
        if (!self.canScroll) {//父视图不允许滚动、手动设置位置
            self.contentOffset = CGPointMake(0, headOffset);
        }
    }
}

#pragma mark - 处理内容滑动数据
- (void)dealContentScrollDataWithScroll:(UIScrollView *)scroll{
    
    if (self.canScroll) {
        scroll.contentOffset = CGPointZero;
    }
    
    //子 tableview 到顶部了
    if (scroll.contentOffset.y <= 0) {
        //到顶通知父视图改变状态
        self.canScroll = YES;
        scroll.contentOffset = CGPointZero;
    }
}

@end
