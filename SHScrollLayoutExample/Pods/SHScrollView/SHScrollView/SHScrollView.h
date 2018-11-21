//
//  SHScrollView.h
//  SHScrollView
//
//  Created by CSH on 2018/8/15.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHScrollView : UIView

//内容Arr (http、path、view、image、vc)
@property (nonatomic, copy) NSArray *contentArr;
//显示位置(设置在 contentArr 之后)
@property (nonatomic, assign) NSInteger currentIndex;
//默认图片
@property (nonatomic, copy) UIImage *placeholderImage;

//自动轮播时间间隔 (默认是0）
// < 0 不自动 不界面循环
// = 0 不自动 界面循环
// > 0 自动 界面循环
@property (nonatomic, assign) CGFloat timeInterval;

//是否是水平方向(默认 YES)
@property (nonatomic, assign) BOOL isHorizontal;

//开始
@property (nonatomic, copy) void (^startRollingBlock)(void);
//滚动中
@property (nonatomic, copy) void (^rollingBlock)(CGFloat offset);
//滚动了一页
@property (nonatomic, copy) void (^endRollingBlock)(BOOL isClick,NSInteger currentIndex);

//刷新视图
- (void)reloadView;


@end
