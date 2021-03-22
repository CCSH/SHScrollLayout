//
//  SHScrollView.h
//  SHScrollView
//
//  Created by CSH on 2018/8/15.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHScrollView : UIView

#pragma mark - 必传
//内容Arr (http、UIView、UIImage、UIViewController, NSString ,NSAttributedString)
@property (nonatomic, copy) NSArray *contentArr;

#pragma mark - 非必传
//显示位置(设置在 contentArr 之后)
@property (nonatomic, assign) NSInteger currentIndex;
//默认图片
@property (nonatomic, copy) UIImage *placeholderImage;
//图片显示模式
@property (nonatomic, assign) UIViewContentMode contentMode;
//滚动方向(默认 水平方向)
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
//是否可以缩放
@property (nonatomic, assign) BOOL isZoom;
//是否可以点击
@property (nonatomic, assign) BOOL isClick;

//自动轮播时间间隔 (默认是0）
// < 0 不自动 不界面循环
// = 0 不自动 界面循环
// > 0 自动 界面循环
@property (nonatomic, assign) CGFloat timeInterval;

#pragma mark 如果自定义了 item 大小则 timeInterval isZoom失效
//内容大小(默认与视图相同)
@property (nonatomic, assign) CGSize itemSize;

#pragma mark 下方三个属性搭配使用
//间距
@property (nonatomic, assign) CGFloat space;
//内容边距
@property (nonatomic, assign) UIEdgeInsets edgeInset;

#pragma mark 标签样式
//如果 contentArr 有 str格式则使用uilabel展示
@property (nonatomic, strong) UIColor *labBGColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSInteger numberOfLines;

#pragma mark - 回调
//开始
@property (nonatomic, copy) void (^startRollingBlock)(void);
//滚动中
@property (nonatomic, copy) void (^rollingBlock)(CGFloat offset);
//滚动了一页
@property (nonatomic, copy) void (^endRollingBlock)(BOOL isClick,NSInteger currentIndex);
//内容返回
@property (nonatomic, copy) UIView *(^contentView)(id obj, NSInteger currentIndex);

//刷新视图
- (void)reloadView;

//禁止拖动
- (void)disableDrag;

@end
