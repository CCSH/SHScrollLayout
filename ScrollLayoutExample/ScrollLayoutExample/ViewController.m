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
#import "SHContentViewController.h"
#import "SHScrollView.h"
#import "SHLabelPageView.h"

#define kSHContentScrollTop @"SHContentScrollTop"

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
//内容载体cell
@property (nonatomic, strong) UITableViewCell *contentCell;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //设置数据源
    [self configData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {//内容
        return 1;
    }
    //头部
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section) {//内容
        
        return self.tableView.height - self.tableView.head_h;
    }
    //头部
    return 100;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section) {
        return self.tableView.head_h;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section) {
        return self.pageView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section) {//内容
        
        static NSString *cellId = @"cellId";
        self.contentCell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!self.contentCell) {
            
            self.contentCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            self.contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self.contentCell.contentView addSubview:self.scrollView];
        }
        
        return self.contentCell;
        
    }else{//头部
        
        static NSString *cellheadId = @"cellheadId";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellheadId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellheadId];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"头部cell --- %ld",(long)indexPath.row];
        cell.backgroundColor = [UIColor orangeColor];
        
        return cell;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if ([scrollView isEqual:self.tableView]) {
        //处理滑动数据
        [self.tableView dealScrollData];
    }
}

#pragma mark 懒加载
- (SHTableView *)tableView{
    if (!_tableView) {
        _tableView = [[SHTableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.headPosition = 20;
        _tableView.head_h = 50;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (SHScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[SHScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 0, kSHDevice_Width, kSHDevice_Height - self.tableView.head_h - self.tableView.headPosition);
        
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

- (void)configData{
    
    NSMutableArray <SHContentViewController *>*viewControllers = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 3; i++) {
        
        SHContentViewController *vc = [[SHContentViewController alloc]init];
        vc.tableView.height = self.scrollView.height;
        vc.topNot = self.tableView.topNot;
        [self addChildViewController:vc];
        [viewControllers addObject:vc];
        
        vc.view.tag = 10 + i;
    }
    
    self.tableView.viewControllers = viewControllers;
    self.scrollView.contentArr = viewControllers;
    
    [self.tableView reloadData];
}

- (SHLabelPageView *)pageView{

    if (!_pageView) {

        NSArray *pageList = @[@"最新",@"热门",@"精华"];

        _pageView = [SHLabelPageView shareSHLabelPageView];

        _pageView.frame = CGRectMake(0, 0, kSHDevice_Width, 50);
        _pageView.pageList = pageList;
        _pageView.type = SHLabelPageType_one;
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
