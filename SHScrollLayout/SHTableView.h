//
//  SHTableView.h
//  ScrollLayout
//
//  Created by CSH on 2018/9/15.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kNotSHScrollLayout @"kNotSHScrollLayout"


@interface SHTableView : UITableView

//悬停的组
@property (nonatomic, assign) NSInteger section;
//组悬停位置
@property (nonatomic, assign) CGFloat sectionY;
//内容高度
@property (nonatomic, assign) CGFloat contentH;
//子视图集合
@property (nonatomic, copy) NSArray <UIScrollView *>*scrollViews;

@end
