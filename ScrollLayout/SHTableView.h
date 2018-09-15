//
//  SHTableView.h
//  ScrollLayout
//
//  Created by CSH on 2018/9/15.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHContentViewController.h"

@interface SHTableView : UITableView <UIGestureRecognizerDelegate>

//主视图是否可以滚动(内容视图与它相反)
@property (nonatomic, assign) BOOL canScroll;
//头部悬停位置
@property (nonatomic, assign) CGFloat headPosition;
//头部视图高度
@property (nonatomic, assign) CGFloat head_h;
//到达顶部通知
@property (nonatomic, copy) NSString *topNot;
//子视图集合
@property (nonatomic, strong) NSMutableArray <SHContentViewController *>*viewControllers;

//处理滑动数据
- (void)dealScrollData;

@end
