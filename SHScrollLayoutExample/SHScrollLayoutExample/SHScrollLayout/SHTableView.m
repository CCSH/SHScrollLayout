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
    
    if (canScroll) {
        //处理子视图到顶部
        for (UIScrollView *obj in self.scrollViews) {
            //修改所有子vc的状态回到顶部
            obj.contentOffset = CGPointZero;
        }
    }
}

#pragma mark - 多手势处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark - 处理主视图滑动数据
- (void)handleMainScroll{
    
    //找到主视图规定的位置
    int headOffset = (int)([self rectForSection:self.section].origin.y - self.headPosition);

    if (self.canScroll) {//可以滚动
        
        //主视图到达指定位置，主视图不可滚动
        if (self.contentOffset.y >= headOffset) {
            //告诉 内容视图可以滚动了
            self.canScroll = NO;
            self.contentOffset = CGPointMake(0, headOffset);
        }
    }else{//不可滚动
        //手动设置主视图位置
        self.contentOffset = CGPointMake(0, headOffset);
    }
}

#pragma mark - 处理子视图滑动数据
- (void)handleChildScrollWithScroll:(UIScrollView *)scroll{

    if (self.canScroll) {//不可以滚动
        
        //找到主视图规定的位置
        int headOffset = (int)([self rectForSection:self.section].origin.y - self.headPosition);
        
        //虽然 主视图可以滚动，但是 主视图设置了不能滚动 并且 已经达到位置了
        if (!self.bounces && (self.contentOffset.y == 0 || self.contentOffset.y == headOffset)) {
            //则内容视图滚动
            
        }else{//手动设置位置
            scroll.contentOffset = CGPointZero;
        }
    }else{//可以滚动
        //内容视图到达顶部
        if (scroll.contentOffset.y <= 0) {
            //告诉 主视图可以滚动了
            self.canScroll = YES;
        }
    }
}

@end
