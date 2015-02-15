//
//  QSRankingTypeView.m
//  Eating
//
//  Created by ysmeng on 14/11/29.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSRankingType.h"
#import "QSImageView.h"
#import "QSConfig.h"
#import "QSBlockActionButton.h"

@interface QSRankingTypeView (){
    
    NSString *_unchoiceCallBackFlag;//!<当点击其他区域返回时，是否回调标记
    
    NSArray *_dataSource;//数据源
    
    CGFloat _startPoint;//!<开始的轴坐标
    
    int _currentSelectedIndex;//!<当前选择状态的下标：默认为0
    
}

@end

@implementation QSRankingTypeView

/**
 *  @author         yangshengmeng, 14-12-17 23:12:18
 *
 *  @brief          创建一个排序选择视图，加载到目标视图之上
 *
 *  @param target   目标视图
 *  @param callBack 回调
 *
 *  @return         返回当前视图
 *
 *  @since          2.0
 */
#pragma mark - 显示排序选择窗口
+ (instancetype)showRankingTypeView:(UIView *)target andCallBack:(void (^)(NSString *type,int index))callBack{
    return [self showRankingTypeView:target andAboveView:nil andCallBack:callBack];
}

/**
 *  @author             yangshengmeng, 14-12-17 23:12:44
 *
 *  @brief              返回一个排序选择视图，视图的排序项y坐标从0开始
 *
 *  @param target       目标视图
 *  @param aboveView    是否需要在某个视图之上
 *  @param callBack     回调
 *
 *  @return             返回当前视图
 *
 *  @since              2.0
 */
+ (instancetype)showRankingTypeView:(UIView *)target andAboveView:(UIView *)aboveView andCallBack:(void (^)(NSString *type,int index))callBack{
    
    return [self showRankingTypeView:target andYPoint:0.0f andAboveView:aboveView andCallBack:callBack];
}

/**
 *  @author             yangshengmeng, 14-12-17 22:12:22
 *
 *  @brief              创建一个默认的排序选择窗口
 *
 *  @param target       目标视图
 *  @param ypoint       排序选择的开始坐标
 *  @param aboveView    是否需要在某个view之上
 *  @param callBack     回调
 *
 *  @return             返回当前视图
 *
 *  @since              2.0
 */
+ (instancetype)showRankingTypeView:(UIView *)target andYPoint:(CGFloat)ypoint andAboveView:(UIView *)aboveView andCallBack:(void (^)(NSString *type,int index))callBack
{
    QSRankingTypeView *RankingType = [[QSRankingTypeView alloc] initWithFrame:CGRectMake(0.0f, ypoint-240.0f, target.frame.size.width, target.frame.size.height-ypoint) andCallBack:callBack];
    
    //加载
    [target insertSubview:RankingType aboveSubview:aboveView];
    
    //动画加载
    [UIView animateWithDuration:0.3 animations:^{
        RankingType.frame = CGRectMake(0.0f, ypoint, target.frame.size.width, target.frame.size.height-ypoint);
        RankingType.alpha = 1.0f;
    }];
    
    return RankingType;
}

/**
 *  @author             yangshengmeng, 14-12-17 22:12:23
 *
 *  @brief              显示一个当前选中第一项的排序选择窗口
 *
 *  @param target       目标视图
 *  @param array        数据源
 *  @param ypoint       排序选择开始坐标
 *  @param aboveView    是否需要在某个view之上
 *  @param callBack     回调
 *
 *  @return             返回当前对象
 *
 *  @since              2.0
 */
+ (instancetype)showRankingTypeView:(UIView *)target andDataSource:(NSArray *)array andYPoint:(CGFloat)ypoint andAboveView:(UIView *)aboveView andCallBack:(void (^)(NSString *type,int index))callBack
{
    return [self showRankingTypeView:target andDataSource:array andYPoint:ypoint andAboveView:aboveView andCurrentIndex:0 andCallBack:callBack];
}

/**
 *  @author yangshengmeng, 14-12-11 10:12:18
 *
 *  @brief               根据给定的数据源生成对应的选择视图，并显示在对应视图之上
 *
 *  @param target        目标视图：将选择窗口加载在的目标视图
 *  @param array         选择视图的数据源
 *  @param ypoint        数据源的起始坐标
 *  @param aboveView     选择视图的底下视图：需要遮盖的视图
 *  @param currentIndext 当前处于选择状态的下标
 *  @param callBack      回调
 *
 *  @return              返回一个选择视图
 *
 *  @since               2.0
 */
#pragma mark -  返回一个给定选择状态的排序选择视图
+ (instancetype)showRankingTypeView:(UIView *)target andDataSource:(NSArray *)array andYPoint:(CGFloat)ypoint andAboveView:(UIView *)aboveView andCurrentIndex:(int)currentIndext andCallBack:(void (^)(NSString *type,int index))callBack
{
    QSRankingTypeView *RankingType = [[QSRankingTypeView alloc] initWithFrame:CGRectMake(0.0f, ypoint-240.0f, target.frame.size.width, target.frame.size.height-ypoint) andDataSource:array andCurrentIndext:currentIndext andCallBack:callBack];
    
    //加载
    [target insertSubview:RankingType aboveSubview:aboveView];
    
    //动画加载
    [UIView animateWithDuration:0.3 animations:^{
        RankingType.frame = CGRectMake(0.0f, ypoint, target.frame.size.width, target.frame.size.height-ypoint);
        RankingType.alpha = 1.0f;
    }];
    
    return RankingType;
}

#pragma mark - 初始化/UI搭建
/**
 *  @author         yangshengmeng, 14-12-17 22:12:18
 *
 *  @brief          创建一个默认排序选择窗口
 *
 *  @param frame    在交视图的位置和大小
 *  @param callBack 回调
 *
 *  @return         返回当前排序选择视图
 *
 *  @since          2.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void (^)(NSString *type,int index))callBack
{
    return [self initWithFrame:frame andDataSource:[self getRankingTypeData] andCurrentIndext:0 andCallBack:callBack];
}

/**
 *  @author             yangshengmeng, 14-12-17 22:12:33
 *
 *  @brief              创建并显示一个排序选择窗口，当前选择状态的选项下标为0
 *
 *  @param frame        在父视图的坐标
 *  @param dataSource   数据源
 *  @param callBack     回调
 *
 *  @return             返回排序选择视图指针
 *
 *  @since              2.0
 */
- (instancetype)initWithFrame:(CGRect)frame andDataSource:(NSArray *)dataSource andCallBack:(void (^)(NSString *type,int index))callBack
{
    return [self initWithFrame:frame andDataSource:dataSource andCurrentIndext:0 andCallBack:callBack];
}

/**
 *  @author             yangshengmeng, 14-12-17 22:12:38
 *
 *  @brief              生成一个排序选择窗口
 *
 *  @param frame        需要加载的父视图
 *  @param dataSource   数据源
 *  @param currentIndex 当前选择状态的下标
 *  @param callBack     回调
 *
 *  @return             返回一个排序选择视图
 *
 *  @since              2.0
 */
- (instancetype)initWithFrame:(CGRect)frame andDataSource:(NSArray *)dataSource andCurrentIndext:(int)currentIndex andCallBack:(void (^)(NSString *type,int index))callBack
{
    if (self = [super initWithFrame:frame]) {
        
        //保存回调
        if (callBack) {
            self.callBack = callBack;
        }
        
        //背景
        self.alpha = 0.0f;
        
        //开始的y轴坐标
        _startPoint = 0.0f;
        
        ///没有选择的状态下是否需要回调
        _unchoiceCallBackFlag = @"0";
        
        //保存数据源
        _dataSource = [NSArray arrayWithArray:dataSource];
        
        //当前选择内容的下标
        _currentSelectedIndex = currentIndex;
        
        //创建UI
        [self createRankingTypeUI];
        
        //添加手势
        [self addSingleTapAction];
    }
    
    return self;
}

//创建UI
#pragma mark - 创建UI
- (void)createRankingTypeUI
{
    //背景
    self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
    
    //头信息底view
    QSImageView *typeRootView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 245.0f)];
    typeRootView.image = [UIImage imageNamed:@"prepaidcard_detail_header_bg"];
    [self addSubview:typeRootView];
    [self addSingleTapAction:typeRootView];
    
    //添加排序
    [self createRankingTypeButton:typeRootView];
}

//创建排序按钮
#pragma mark - 返回排序数据
- (void)createRankingTypeButton:(UIView *)view
{
    //获取排序数据
    NSArray *RankingTypeList;
    if ([_dataSource count] > 0) {
        RankingTypeList = _dataSource;
    } else {
        RankingTypeList = [self getRankingTypeData];
    }
    
    //先检测是否需要添加滚动视图
    [self checkRankingTypeCount:RankingTypeList andView:view];
}

//获取排序数据
#pragma mark - 返回一个默认的排序列表
- (NSArray *)getRankingTypeData
{
    return @[@"评价最高",@"最新发布",@"人气最高",@"价格最低",@"价格最高"];
}

//添加排序按钮
#pragma mark - 滚动添加排序按钮
- (void)addRankingTypeButtonWithList:(NSArray *)typeList andView:(UIView *)view
{
    //35 x 5 = 175
    for (int i = 0; i < [typeList count]; i++) {
        
        UIButton *button = [UIButton createBlockActionButton:CGRectMake(0.0f, 0.0f, 160.0f, 45.0f) andStyle:nil andCallBack:^(UIButton *button) {
            
            //回调
            if (self.callBack) {
                self.callBack(typeList[i],i);
            }
            
            //移聊
            [self hiddenRankingTypeView];
            
        }];
        button.center = CGPointMake(view.frame.size.width/2.0f, 75.0f+30*i);
        [button setTitle:typeList[i] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"· %@",typeList[i]] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        //标题颜色
        [button setTitleColor:kBaseGrayColor forState:UIControlStateNormal];
        [button setTitleColor:kBaseOrangeColor forState:UIControlStateSelected];
        
        //第一排序处于选择状态
        if (i == _currentSelectedIndex) {
            button.selected = YES;
        }
        
        [view addSubview:button];
    }
    
}

//如果排序大于5时，添加一个scrollview
- (void)addRankingTypeScrollViewWithList:(NSArray *)typeList andView:(UIView *)view
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
    scrollView.contentSize = CGSizeMake(view.frame.size.width, 20.0f+45.0f*[typeList count]);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [view addSubview:scrollView];
    
    //加载排序
    [self addRankingTypeButtonWithList:typeList andView:scrollView];
}

//排序数量过滤：大于5则先添加scrollView，小于5则直接加载
- (void)checkRankingTypeCount:(NSArray *)typeList andView:(UIView *)view
{
    if ([typeList count] > 5) {
        [self addRankingTypeScrollViewWithList:typeList andView:view];
        return;
    }
    
    [self addRankingTypeButtonWithList:typeList andView:view];
}

//添加单击事件
#pragma mark - 单击非功能区域时回收排序选择
- (void)addSingleTapAction
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(RankingTypeSingleTapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)addSingleTapAction:(UIView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subViewTapGestureAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tap];
}

- (void)subViewTapGestureAction:(UITapGestureRecognizer *)tap
{
    
}

//单击本视图时，移除
- (void)RankingTypeSingleTapAction:(UITapGestureRecognizer *)tap
{
    
    //判断点击的坐标
    CGPoint tapPoint = [tap locationInView:self];
    if (tapPoint.y < 100.0f) {
        return;
    }
    
    ///判断是否需要回调
    if ([_unchoiceCallBackFlag intValue] == 1 && self.callBack) {
        self.callBack(nil,-1);
    }
    
    [self hiddenRankingTypeView];
}

/**
 *  @author yangshengmeng, 14-12-11 12:12:06
 *
 *  @brief  移除选择视图
 *
 *  @param  flag 标记是否回调：为真时再次回调
 *
 *  @since  2.0
 */
#pragma mark - 移除选择视图
- (void)hiddenRankingTypeView:(BOOL)flag
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-240.0f, self.frame.size.width, self.frame.size.height);
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self removeFromSuperview];
        }
        
    }];
}

/**
 *  @author yangshengmeng, 14-12-11 12:12:40
 *
 *  @brief  提供给外部访问的隐藏选择窗口控件
 *
 *  @since  2.0
 */
#pragma mark - 提供给外部访问的隐藏选择窗口控件
- (void)hiddenRankingTypeView
{
    [self hiddenRankingTypeView:NO];
}

@end
