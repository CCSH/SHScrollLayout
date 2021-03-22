//
//  SHLabelPageView.h
//  SHLabelPageView
//
//  Created by CSH on 2018/7/10.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+SHExtension.h"

//标签页类型
typedef enum : NSUInteger {
    SHLabelPageType_more,   //多页(横屏滚动)
    SHLabelPageType_one,    //一页(标签居中)
} SHLabelPageType;

//滚动方向
typedef enum : NSUInteger {
    SHLabelPageDirectione_ver,   //水平滚动
    SHLabelPageDirectione_hor,   //竖直滚动
} SHLabelPageDirectione;

/**
 标签页
 */
@interface SHLabelPageView : UIView

#pragma mark - 必须设置
//数组
@property (nonatomic, strong) NSArray <NSString *>*pageList;

//回调(标签点击回调)
@property (nonatomic, copy) void(^pageViewBlock)(SHLabelPageView *pageView);

#pragma mark - 选择设置
//类型
@property (nonatomic, assign) SHLabelPageType type;
//当前位置(默认是0)
@property (nonatomic, assign) NSInteger index;

//偏移量(设置滑动中的效果)
@property (nonatomic, assign) CGFloat contentOffsetX;

#pragma mark 标签布局设置(更改设置需要调用 reloadView)

//标签开始的X(如果是 一页的话就是居中)
@property (nonatomic, assign) CGFloat startX;
//标签间间隔
//如果一页设置了 spaceW 则 startX 失效
//如果一页不设置 spaceW 则去除 2*startX 均分)
@property (nonatomic, assign) CGFloat spaceW;

//标签宽度(可以不设置自适应)
@property (nonatomic, assign) CGFloat labelW;

//标签字体大小(默认是加粗16)
@property (nonatomic, strong) UIFont *fontSize;
//标签未选中字体大小(默认是16)
@property (nonatomic, strong) UIFont *unFontSize;
//标签选中颜色(默认是黑色)
@property (nonatomic, strong) UIColor *checkColor;
//标签未选中颜色(默认是黑色 0.3)
@property (nonatomic, strong) UIColor *uncheckColor;

#pragma mark 其他功能定制
#pragma mark 标记
//key   标签位置
//value frame
@property (nonatomic, strong) NSDictionary *labelTag;
//标记颜色（默认红色）
@property (nonatomic, strong) UIColor *tagColor;

#pragma mark 选中线
//选中线 Y
@property (nonatomic, assign) CGFloat currentLineY;
//选中线图片
@property (nonatomic, strong) UIImage *currentImg;
//选中线 size(默认 文字宽度, 4)
@property (nonatomic, assign) CGSize currentLineSize;
//选中线 多出间隙(未设置宽度 currentLineSize.width 时需要多余的间隙 如果设置了宽度则 此属性失效)
@property (nonatomic, assign) CGFloat currentLineMargin;

//选中线 弧度(默认 2)
@property (nonatomic, assign) CGFloat currentLineRadius;
//选中线 color(默认 redColor)
@property (nonatomic, strong) UIColor *currentLineColor;


//方向
@property (nonatomic, assign) SHLabelPageDirectione directione;

#pragma mark 竖直配置(购物类APP分类形式)
//标签高度(默认40)
@property (nonatomic, assign) CGFloat labelH;


#pragma mark 刷新
- (void)reloadView;

@end
