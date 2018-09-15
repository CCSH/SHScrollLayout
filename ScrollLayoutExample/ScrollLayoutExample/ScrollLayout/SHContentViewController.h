//
//  SHContentViewController.h
//  ScrollLayout
//
//  Created by CSH on 2018/9/7.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 视图内容 可以自己定义
 */
@interface SHContentViewController : UIViewController

//是否可以滚动
@property (nonatomic, assign) BOOL canScroll;
//到达顶部通知
@property (nonatomic, copy) NSString *topNot;
//内容
@property (nonatomic, strong) UITableView *tableView;

@end
