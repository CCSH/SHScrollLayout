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
    SHLabelPageType_more,   //多页
    SHLabelPageType_one,    //一页
} SHLabelPageType;

/**
 标签页
 */
@interface SHLabelPageView : UIView

//数组
@property (nonatomic, strong) NSArray <NSString *>*pageList;
//类型
@property (nonatomic, assign) SHLabelPageType type;
//当前位置(默认是0)
@property (nonatomic, assign) NSInteger index;

//标签开始的X(如果是 一页的话就是居中)
@property (nonatomic, assign) CGFloat startX;
//标签间间隔
//如果一页设置了 spaceW 则 startX 失效
//如果一页不设置 spaceW 则去除 2*startX 均分)
@property (nonatomic, assign) CGFloat spaceW;

//偏移量(设置滑动中的效果)
@property (nonatomic, assign) CGFloat contentOffsetX;

//标记
//key   标签名字
//value frame
@property (nonatomic, strong) NSDictionary *labelTag;
//标记颜色（默认红色）
@property (nonatomic, strong) UIColor *tagColor;

//标签字体大小(默认是加粗16)
@property (nonatomic, strong) UIFont *fontSize;
//标签未选中字体大小(默认是16)
@property (nonatomic, strong) UIFont *unFontSize;
//标签选中颜色(默认是黑色)
@property (nonatomic, strong) UIColor *checkColor;
//标签未选中颜色(默认是黑色 0.3)
@property (nonatomic, strong) UIColor *uncheckColor;

//选中线的颜色(默认是红)
@property (nonatomic, strong) UIColor *currentColor;
//选中线的Y(默认距离视图下方 3)
@property (nonatomic, assign) CGFloat currentY;

//分割线颜色(默认 237，237，237)
@property (nonatomic, strong) UIColor *lineColor;

//回调(标签点击回调)
@property (nonatomic, copy) void(^pageViewBlock)(SHLabelPageView *pageView);

//刷新
- (void)reloadView;

@end
