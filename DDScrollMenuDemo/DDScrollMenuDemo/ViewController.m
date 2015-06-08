//
//  ViewController.m
//  DDScrollMenuDemo
//
//  Created by DingDang on 15/6/4.
//  Copyright (c) 2015年 DingDang. All rights reserved.
//

#import "ViewController.h"
#import "DDScrollMenu.h"

#define kScreenWidth    (CGRectGetWidth([UIScreen mainScreen].bounds))
#define kScreenHeight   (CGRectGetHeight([UIScreen mainScreen].bounds))

@interface ViewController () <UIScrollViewDelegate, DDScrollMenuDelegate>

@property (nonatomic, strong) DDScrollMenu *scrollMenu;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ViewController

#pragma mark - View Controller

- (void)viewDidLoad
{
    [super viewDidLoad];

//    NSArray *titles = @[@"头条", @"热点", @"娱乐"];
    NSArray *titles = @[@"头条", @"热点", @"娱乐", @"体育", @"财经", @"科技", @"房产", @"游戏"];
    _scrollMenu = [[DDScrollMenu alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 40) andTitles:titles];
    _scrollMenu.delegate = self;
    [self.view addSubview:_scrollMenu];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight - 60)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * titles.count, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    for (int i = 0; i < titles.count; ++i) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight - 60)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        label.text = titles[i];
        label.center = [view convertPoint:view.center fromView:_scrollView];
        [view addSubview:label];

        [_scrollView addSubview:view];
    }
    [self.view addSubview:_scrollView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.scrollMenu.selectedIndex = 1;
    [self scrollToViewAtIndex:1 animated:animated];
}

- (void)scrollToViewAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    [self.scrollView setContentOffset:CGPointMake(index * kScreenWidth, 0) animated:animated];
}

#pragma mark - DDScrollMenuDelegate

- (void)scrollMenu:(DDScrollMenu *)scrollMenu didSelectMenuAtIndex:(NSUInteger)index
{
    [self scrollToViewAtIndex:index animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger pageIndex = scrollView.contentOffset.x / kScreenWidth;
    [self.scrollMenu setSelectedIndex:pageIndex animated:NO];
}

@end
