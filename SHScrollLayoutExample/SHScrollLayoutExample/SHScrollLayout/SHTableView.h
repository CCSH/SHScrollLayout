//
//  SHTableView.h
//  ScrollLayout
//
//  Created by CSH on 2018/9/15.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHTableView : UITableView

//需要特殊处理的组
@property (nonatomic, assign) NSInteger section;
//头部悬停位置
@property (nonatomic, assign) CGFloat headPosition;
//子视图集合(主要为了控制主视图可以滚动时 内容视图全部滚动到顶部)
@property (nonatomic, copy) NSArray <UIScrollView *>*scrollViews;

//处理主视图滑动(在整体滑动中
//添加在主视图 scrollViewDidScroll
- (void)handleMainScroll;

//处理子视图滑动(在内容滑动中
//添加在子视图 scrollViewDidScroll
- (void)handleChildScrollWithScroll:(UIScrollView *)scroll;

@end
