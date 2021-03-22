//
//  SHViewController.h
//  ScrollLayout
//
//  Created by CSH on 2018/9/7.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHTableView;
/**
 视图内容 可以自己定义
 */
@interface SHViewController : UIViewController

//内容
@property (nonatomic, strong) UITableView *tableView;

@end
