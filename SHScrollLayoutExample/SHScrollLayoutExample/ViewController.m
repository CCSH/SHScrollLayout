//
//  ViewController.m
//  ScrollLayout
//
//  Created by CSH on 2018/8/24.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "ViewController.h"
#import "UIView+SHExtension.h"
#import "SHTableView.h"
#import "SHViewController.h"
#import "SHScrollView.h"
#import "SHLabelPageView.h"

#define kSHDevice_Width  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度
#define kSHDevice_Height [[UIScreen mainScreen] bounds].size.height //主屏幕的高度

// weak & strong
#define kSHWeak(VAR) \
@try {} @finally {} \
__weak __typeof__(VAR) weak_##VAR = (VAR);

#define kSHStrong(VAR) \
@try {} @finally {} \
__strong __typeof__(VAR) VAR = weak_##VAR


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

//主视图
@property (nonatomic, strong) SHTableView *tableView;
//标签页
@property (nonatomic, strong) SHLabelPageView *pageView;
//内容视图
@property (nonatomic, strong) SHScrollView *scrollView;

//头部视图高度
@property (nonatomic, assign) CGFloat head_h;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //设置数据源
    [self configData];
}

#pragma mark - 配置参数
- (void)configData{
    
    self.head_h = 48;
    
    NSMutableArray <UIScrollView *>*tableviews = [[NSMutableArray alloc]init];
    NSMutableArray <SHViewController *>*viewControllers = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 3; i++) {
        
        SHViewController *vc = [[SHViewController alloc]init];
        vc.tableView.height = self.scrollView.height;
        vc.mainTableView = self.tableView;
        [self addChildViewController:vc];
        [tableviews addObject:vc.tableView];
        [viewControllers addObject:vc];
        vc.view.tag = 10 + i;
    }
    
    self.tableView.taleviews = tableviews;
    self.scrollView.contentArr = viewControllers;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == self.tableView.section) {//内容
        return 1;
    }
    //头部
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == self.tableView.section) {//下方内容
        
        return self.tableView.height - self.tableView.headPosition - self.head_h;
    }
    //上方内容
    return 80;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == self.tableView.section) {
        return self.head_h;
    }
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == self.tableView.section) {
        return self.pageView;
    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == self.tableView.section) {//内容
        
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.scrollView];
        }
        
        return cell;
        
    }else{//头部
        
        static NSString *cellheadId = @"cellheadId";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellheadId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellheadId];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"头部cell %ld --- %ld",(long)indexPath.section,(long)indexPath.row];
        cell.backgroundColor = [UIColor orangeColor];
        
        return cell;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.tableView]) {
        //处理整体滑动数据
        [self.tableView dealMainScrollData];
    }
}

#pragma mark 懒加载
- (SHTableView *)tableView{
    if (!_tableView) {
        _tableView = [[SHTableView alloc]initWithFrame:CGRectMake(0, 0, kSHDevice_Width, kSHDevice_Height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        
        //设置了则标签下方刷新
        _tableView.bounces = NO;
        //需要处理的组
        _tableView.section = 2;
        //处理组头部悬停位置
        _tableView.headPosition = 100;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (SHScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[SHScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 0, self.tableView.width, self.tableView.height - self.tableView.headPosition - self.head_h);
        //设置自动轮播时间间隔
        _scrollView.timeInterval = -1;
        
        kSHWeak(self);
        //开始滚动
        _scrollView.startRollingBlock = ^{
            
            //下方视图开始左右滚动的时候主tableview不能滚动
            weak_self.tableView.scrollEnabled = NO;
        };
        //结束滚动
        _scrollView.endRollingBlock = ^(BOOL isClick, NSInteger currentIndex) {
            
            //下方视图结束左右滚动的时候主tableview滚动
            weak_self.tableView.scrollEnabled = YES;
        };
        
        //滚动中
        _scrollView.rollingBlock = ^(CGFloat offset) {
            //设置偏移
            [SHLabelPageView shareSHLabelPageView].contentOffsetX = offset;
        };
    }
    return _scrollView;
}

- (SHLabelPageView *)pageView{
    
    if (!_pageView) {
        
        NSArray *pageList = @[@"最新",@"热门",@"精华"];
        
        _pageView = [SHLabelPageView shareSHLabelPageView];
        
        _pageView.frame = CGRectMake(0, 0, self.tableView.width, self.head_h);
        _pageView.backgroundColor = [UIColor whiteColor];
        _pageView.pageList = pageList;
        _pageView.type = SHLabelPageType_one;
        _pageView.startX = 0;
        kSHWeak(self)
        //回调
        _pageView.pageViewBlock = ^(SHLabelPageView *pageView) {
            
            weak_self.scrollView.currentIndex = pageView.index;
        };
        
        _pageView.index = 1;
        //刷新界面
        [_pageView reloadView];
    }
    return _pageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
