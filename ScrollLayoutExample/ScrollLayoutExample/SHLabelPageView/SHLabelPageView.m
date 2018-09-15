//
//  SHLabelPageView.m
//  SHLabelPageView
//
//  Created by CSH on 2018/7/10.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHLabelPageView.h"
#import "UIView+SHExtension.h"

@interface SHLabelPageView ()

//标签滚动视图
@property (nonatomic, strong) UIScrollView *pageScroll;
//当前点击的线
@property (nonatomic, strong) UIView *currentLine;
//视图分割线
@property (nonatomic, strong) UIView *line;

@end

@implementation SHLabelPageView

//标签tag
static NSInteger labTag = 10000000000;
//标签左右间距
static CGFloat space = 20;

#pragma mark - 私有方法
#pragma mark 初始化
+ (instancetype)shareSHLabelPageView{
    
    static SHLabelPageView *labelPageView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        labelPageView = [[self alloc]init];
    });
    return labelPageView;
}

#pragma mark SET
- (void)setIndex:(NSInteger)index{
    
    if (_index == index) {
        return;
    }
    
    _index = index;
    //刷新界面
    [self reloadPage];
    //回调
    if (self.pageViewBlock) {
        self.pageViewBlock(self);
    }
}

- (void)setContentOffsetX:(CGFloat)contentOffsetX{
    
    _contentOffsetX = contentOffsetX;
    
    if (contentOffsetX == self.index) {//已经设置完毕 -> 界面滚动 -> 触发本方法
        return;
    }
    
    if (contentOffsetX < 0) {//最左边
        return;
    }
    
    if (contentOffsetX > self.pageList.count - 1) {//最右边
        return;
    }
    
    //左右位置
    NSInteger leftIndex = (NSInteger)contentOffsetX;
    NSInteger rightIndex = leftIndex + 1;
    
    //取出左右的视图
    UILabel *leftLab  = [self.pageScroll viewWithTag:(leftIndex + labTag)];
    UILabel *rightLab = [self.pageScroll viewWithTag:(rightIndex + labTag)];
    
    //增加下划线动画
    CGFloat scale = 0;
    
    //文字颜色
    CGFloat scaleRight = 0;
    CGFloat scaleLeft = 0;
    
    //间隔
    CGFloat margin = rightLab.centerX - leftLab.centerX;
    
    //设置 X 变化
    if (self.index > leftIndex) {//右滑
        
        if (contentOffsetX - leftIndex >= 0.5) {//首先
            //宽度增大 0 ~ 1
            scale = (1 - (contentOffsetX - leftIndex))*2;
            //X减小
            self.currentLine.x = (leftLab.centerX - 10) + (1 - scale)*margin;
        }else{//然后
            
            //宽度减小 1 ~ 0
            scale = ((contentOffsetX - leftIndex))*2;
            //X不变
            self.currentLine.x = (leftLab.centerX - 10);
        }
        //右边边颜色越来越小
        scaleRight = 0.5 + (contentOffsetX - leftIndex)/2;
        scaleLeft = 0.5 + (1 - (contentOffsetX - leftIndex))/2;
    }
    
    if (self.index < rightIndex) {//左滑

        if (rightIndex - contentOffsetX > 0.5){//首先
            
            //宽度增大 0 ~ 1
            scale = (1 - (rightIndex - contentOffsetX))*2;
            //X不变
            self.currentLine.x = (leftLab.centerX - 10);
        }else{//然后
            
            //宽度减小 1 ~ 0
            scale = (rightIndex - contentOffsetX)*2;
            //X减小
            self.currentLine.x = (rightLab.centerX - 10) - scale*margin;
        }

        //左边边颜色越来越小
        scaleLeft = 0.5 + (rightIndex - contentOffsetX)/2;
        scaleRight = 0.5 + (1 - (rightIndex - contentOffsetX))/2;
    }
    
    //设置 width 变化
    self.currentLine.width = 20 + scale*margin;
    
    //设置左右视图颜色变化
    leftLab.textColor  = [self.selectedColor?:[UIColor blackColor] colorWithAlphaComponent:scaleLeft];
    rightLab.textColor = [self.selectedColor?:[UIColor blackColor] colorWithAlphaComponent:scaleRight];
    
    if (leftIndex == contentOffsetX) {
        self.index = leftIndex;
    }
}

#pragma mark 配置UI
- (void)configUI{
    
    //视图分割线
    self.line.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
    //设置滚动大小
    self.pageScroll.size = CGSizeMake(self.width, self.line.y);
    //选中的线
    if (self.currentY) {
        self.currentLine.y = self.currentY;
    }else{
        self.currentLine.y = self.pageScroll.height/2 + (self.fontSize.lineHeight?:[UIFont systemFontOfSize:18].lineHeight)/2 + 4;
    }
    self.currentLine.width = 20;
    self.currentLine.backgroundColor = self.currentColor?:[UIColor redColor];
    
    //设置标签
    CGFloat view_h = self.pageScroll.bounds.size.height;
    
    //间隔
    __block  CGFloat view_x = 8;
    __block CGFloat view_width = 0;
    
    if (self.type == SHLabelPageType_one) {
        view_x = 30;
        view_width = (self.width - 2*view_x)/self.pageList.count;
    }
    
    //设置内容
    [self.pageList enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //设置标签
        UILabel *label = [self getChannelLab];
        label.text = obj;
        
        
        if (self.type == SHLabelPageType_one) {
            label.frame = CGRectMake(view_x, 0, view_width, view_h);
        }else{
            label.frame = CGRectMake(view_x, 0, [self getChannelWithText:obj], view_h);
        }
        
        view_x += label.width;
        label.tag = idx + labTag;
        
        [self.pageScroll addSubview:label];
    }];

    self.pageScroll.contentSize = CGSizeMake(self.width, 0);
    [self.pageScroll addSubview:self.currentLine];
    //刷新界面
    [self reloadPage];
}

#pragma mark 获取标签
- (UILabel *)getChannelLab{
    
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = self.fontSize?:[UIFont systemFontOfSize:18];
    label.userInteractionEnabled = YES;
    
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    
    return label;
}

#pragma mark 获取宽度
- (CGFloat)getChannelWithText:(NSString *)text{
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.pageScroll.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.fontSize?:[UIFont systemFontOfSize:18]} context:nil].size;
    
    return ceil(size.width) + space;
}

#pragma mark 标签点击
- (void)labelClick:(UITapGestureRecognizer *)tap{
    
    self.index = tap.view.tag - labTag;
}

#pragma mark 刷新视图
- (void)reloadPage{
    
    if (self.index >= self.pageList.count) {
        NSLog(@"数组超出了");
        return;
    }
    
    NSLog(@"\n当前位置 === %@",self.pageList[self.index]);
    
    //取出当前的标签
    UILabel *currentLab = [self.pageScroll viewWithTag:self.index + labTag];
    
    if (self.type == SHLabelPageType_more) {
        
        //设置scroll居中
        CGFloat offsetX = currentLab.centerX - self.pageScroll.width * 0.5;
        CGFloat offsetMaxX = self.pageScroll.contentSize.width - self.pageScroll.width;
        
        if (offsetX < 0){
            offsetX = 0;
        }
        if (offsetX > offsetMaxX) {
            offsetX = offsetMaxX;
        }
        [self.pageScroll setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    //改变颜色
    for (UILabel *label in self.pageScroll.subviews) {
        if (label.tag >= labTag && label.tag < (self.pageList.count + labTag)) {
            //未选中颜色
            label.textColor = [self.selectedColor?:[UIColor blackColor] colorWithAlphaComponent:0.5];
        }
    }
    
    self.currentLine.width = 20;
    //设置选中下划线
    [UIView animateWithDuration:0.25 animations:^{
        self.currentLine.centerX = currentLab.centerX;
        //选中颜色
        currentLab.textColor = self.selectedColor?:[UIColor blackColor];
    }];
}

#pragma mark - 懒加载
//滚动视图
- (UIScrollView *)pageScroll{
    if (!_pageScroll) {
        _pageScroll = [[UIScrollView alloc] init];
        _pageScroll.origin = CGPointMake(0, 0);
        _pageScroll.backgroundColor = [UIColor clearColor];
        _pageScroll.showsHorizontalScrollIndicator = NO;
        // 设置下划线
        [self addSubview:_pageScroll];
    }
    return _pageScroll;
}

//视图分割线
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor grayColor];
        [self addSubview:_line];
    }
    return _line;
}

//当前点击的线
- (UIView *)currentLine{
    if (!_currentLine) {
        _currentLine = [[UIView alloc]init];
        _currentLine.size = CGSizeMake(20, 4);
        _currentLine.layer.cornerRadius = 2;
        _currentLine.layer.masksToBounds = YES;
    }
    return _currentLine;
}

#pragma mark - 公共方法
#pragma mark - 刷新
- (void)reloadView{
    
    for (UIView *view in self.pageScroll.subviews) {
        [view removeFromSuperview];
    }
    
    if (self.pageList.count) {
        //配置UI
        [self configUI];
    }
}

@end
