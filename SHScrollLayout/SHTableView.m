//
//  SHTableView.m
//  ScrollLayout
//
//  Created by CSH on 2018/9/15.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHTableView.h"

@interface SHTableView () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

//主视图是否可以滚动(子视图与它相反)
@property (nonatomic, assign) BOOL canScroll;
//主视图悬停位置
@property (nonatomic, assign) CGFloat location;
//是否需要更新
@property (nonatomic, assign) BOOL isUpdate;

@end

@implementation SHTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        //默认主视图可以滚动
        self.canScroll = YES;
        //计算一下
        self.isUpdate = YES;
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        //滚动通知
        [[NSNotificationCenter defaultCenter] addObserverForName:kNotSHScrollLayout
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *_Nonnull note) {
            [self scrollViewDidScroll:note.object];
        }];
    }
    return self;
}

#pragma mark - SET
#pragma mark 设置内容视图偏移量
- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    
    if (canScroll) {
        //处理子视图到顶部
        for (UIScrollView *obj in self.scrollViews) {
            //修改所有子vc的状态回到顶部
            obj.contentOffset = CGPointZero;
        }
    } else {
        //处理主视图规定位置
        self.contentOffset = CGPointMake(0, self.location);
    }
}

- (void)setSection:(NSInteger)section {
    _section = section;
    self.isUpdate = YES;
}

- (void)setSectionY:(CGFloat)sectionY {
    _sectionY = sectionY;
    self.isUpdate = YES;
}

- (void)setScrollViews:(NSArray<UIScrollView *> *)scrollViews {
    _scrollViews = scrollViews;
    [self configFrame];
}

- (void)setContentH:(CGFloat)contentH {
    _contentH = contentH;
    [self configFrame];
}

#pragma mark 配置数据
- (void)configFrame {
    for (UIScrollView *scroll in self.scrollViews) {
        if (self.contentH) {
            CGRect frame = scroll.frame;
            frame.size.height = self.contentH;
            scroll.frame = frame;
        }
        
        NSAssert((self.bounces || scroll.bounces), @"主视图或者子视图最少有一个的属性 bounces 为YES");
    }
}

#pragma mark
- (void)configData {
    if (self.isUpdate) {
        self.isUpdate = NO;
        //主视图悬停位置
        self.location = ([self rectForSection:self.section].origin.y - self.sectionY);
    }
}

#pragma mark - 主视图与子视图滚动处理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self configData];
    
    if ([scrollView isEqual:self]) {
        //主视图滚动
        if (self.canScroll) { //可以滚动
            //主视图到达指定位置,主视图不可滚动
            if (self.contentOffset.y >= self.location) {
                //告诉 子视图可以滚动了
                self.canScroll = NO;
            }
            
        } else { //不可滚动
            //手动设置位置
            self.contentOffset = CGPointMake(0, self.location);
        }
    } else {
        //子视图滚动
        if (!self.canScroll) { //可以滚动
            //子视图到达顶部,子视图不可滚动
            if (scrollView.contentOffset.y <= 0) {
                //告诉 主视图可以滚动了
                self.canScroll = YES;
            }
            
        } else { //不可以滚动
            
            //虽然 主视图可以滚动，但是 主视图设置了不能滚动 并且 已经达到位置了
            if (!self.bounces && (self.contentOffset.y == 0 || self.contentOffset.y == self.location)) {
                //子视图滚动
                
            } else {
                //手动设置位置
                scrollView.contentOffset = CGPointZero;
            }
        }
    }
}

#pragma mark - 多手势处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
