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
//内容高度
@property (nonatomic, assign) CGFloat contentH;
//子视图集合
@property (nonatomic, copy) NSArray <UIScrollView *>*scrollViews;

//处理视图滑动(主视图与子视图 内部有默认处理，如果在其他地方有此代理方法则主动运行此方法)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
