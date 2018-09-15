//
//  SHTableView.m
//  ScrollLayout
//
//  Created by CSH on 2018/9/15.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHTableView.h"

#define kSHContentScrollTop @"SHContentScrollTop"

@implementation SHTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.topNot = kSHContentScrollTop;
        self.canScroll = YES;
    }
    return self;
}

#pragma mark 多手势处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

#pragma mark - SET
#pragma mark 设置内容视图偏移量
- (void)setCanScroll:(BOOL)canScroll{
    _canScroll = canScroll;
    
    //主视图可以滚动则子视图不可滚动
    for (SHContentViewController *obj in self.viewControllers) {
        obj.canScroll = !self.canScroll;
        //如果主视图滑动，修改所有子vc的状态回到顶部
        if (self.canScroll) {
            obj.tableView.contentOffset = CGPointZero;
        }
    }
}

- (void)setTopNot:(NSString *)topNot{
    _topNot = topNot;
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:topNot object:nil];
}

//改变主视图的状态
- (void)changeScrollStatus{
    self.canScroll = YES;
}

#pragma mark - 处理滑动数据
- (void)dealScrollData{
    
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

@end
