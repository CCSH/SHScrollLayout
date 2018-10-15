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
@property (nonatomic, strong) NSArray *pageList;
//类型
@property (nonatomic, assign) SHLabelPageType type;
//当前位置(默认是0)
@property (nonatomic, assign) NSInteger index;


//标签字体大小(默认是18)
@property (nonatomic, strong) UIFont *fontSize;
//标签选中颜色(默认是黑色)
@property (nonatomic, strong) UIColor *checkColor;
//标签未选中颜色(默认是黑色 0.3)
@property (nonatomic, strong) UIColor *uncheckColor;

//选中线的颜色(默认是红)
@property (nonatomic, strong) UIColor *currentColor;
//选中线的Y(默认距离视图下方 3)
@property (nonatomic, assign) CGFloat currentY;

//标签开始的X(默认 0)
@property (nonatomic, assign) CGFloat startX;

//偏移量(设置滑动中的效果)
@property (nonatomic, assign) CGFloat contentOffsetX;

//回调(标签点击回调)
@property (nonatomic, copy) void(^pageViewBlock)(SHLabelPageView *pageView);

//初始化
+ (instancetype)shareSHLabelPageView;

//刷新
- (void)reloadView;

@end
