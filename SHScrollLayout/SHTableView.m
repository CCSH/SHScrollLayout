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

//主视图是否可以滚动(子视图与它相反)
@property (nonatomic, assign) BOOL canScroll;
//是否需要更新
@property (nonatomic, assign) BOOL isUpdate;
//主视图规定位置
@property (nonatomic, assign) CGFloat location;

@end

@implementation SHTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        //默认主视图可以滚动
        self.canScroll = YES;
        
        if (@available(iOS 11.0, *))
        {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

- (void)configData{
    if (self.isUpdate) {
        self.isUpdate = NO;
        //找到主视图规定的位置
        self.location = ([self rectForSection:self.section].origin.y - self.headPosition);
    }
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
    }else{
        //处理主视图规定位置
        self.contentOffset = CGPointMake(0, self.location);
    }
}

- (void)setSection:(NSInteger)section{
    _section = section;
    self.isUpdate = YES;
}

- (void)setHeadPosition:(CGFloat)headPosition{
    _headPosition = headPosition;
    self.isUpdate = YES;
}

#pragma mark - 多手势处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark - 处理主视图滑动数据
- (void)handleMainScroll{
    
    [self configData];
  
    if (self.canScroll) {//可以滚动
        //主视图到达指定位置,主视图不可滚动
        if (self.contentOffset.y >= self.location) {
            //告诉 子视图可以滚动了
            self.canScroll = NO;
        }
        
    }else{//不可滚动
        //手动设置位置
        self.contentOffset = CGPointMake(0, self.location);
    }
}

#pragma mark - 处理子视图滑动数据
- (void)handleChildScrollWithScroll:(UIScrollView *)scroll{

    [self configData];
    
    if (!self.canScroll) {//可以滚动
        //子视图到达顶部,子视图不可滚动
        if (scroll.contentOffset.y <= 0) {
            //告诉 主视图可以滚动了
            self.canScroll = YES;
        }
        
    }else{//不可以滚动
        
        //虽然 主视图可以滚动，但是 主视图设置了不能滚动 并且 已经达到位置了
        if (!self.bounces && (self.contentOffset.y == 0 || self.contentOffset.y == self.location)) {
            //子视图滚动
            
        }else{
            //手动设置位置
            scroll.contentOffset = CGPointZero;
        }
    }
}

@end
