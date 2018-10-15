//
//  SHTableView.h
//  ScrollLayout
//
//  Created by CSH on 2018/9/15.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHViewController.h"

@interface SHTableView : UITableView 

//头部悬停位置
@property (nonatomic, assign) CGFloat headPosition;
//头部视图高度
@property (nonatomic, assign) CGFloat head_h;
//子视图集合(主要为了控制主视图可以滚动时 内容视图全部滚动到顶部)
@property (nonatomic, strong) NSMutableArray <SHViewController *>*viewControllers;

//处理整体滑动数据(在整体滑动中 - (void)scrollViewDidScroll:(UIScrollView *)scrollView)
- (void)dealMainScrollData;

//处理内容滑动数据(在内容滑动中 - (void)scrollViewDidScroll:(UIScrollView *)scrollView)
- (void)dealContentScrollDataWithScroll:(UIScrollView *)scroll;

@end
