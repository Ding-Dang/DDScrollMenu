//
//  DDScrollMenu.m
//  DDScrollMenuDemo
//
//  Created by DingDang on 15/6/4.
//  Copyright (c) 2015年 DingDang. All rights reserved.
//

#define PADDING     20
#define FONTSIZE    14
#define BASETAG     100

#define BACKGROUND_COLOR        ([UIColor lightGrayColor])
#define ITEM_COLOR_DEFUALT      ([UIColor lightTextColor])
#define ITEM_COLOR_SELECTED     ([UIColor redColor])

#import "DDScrollMenu.h"

@interface DDScrollMenu() {
    CGFloat padding;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *titles; // array of NSString

@end

@implementation DDScrollMenu

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        _titles = titles;
        _selectedIndex = 0;
        [self setup];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setup
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _scrollView.backgroundColor = BACKGROUND_COLOR;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];

    CGFloat x = 0;
    CGFloat totalWidth = 0;
    NSArray *buttonWidths = [self getButtonWidths];
    for (int i = 0; i < buttonWidths.count; ++i) {
        CGFloat width = [buttonWidths[i] doubleValue];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = BASETAG + i;
        button.frame = CGRectMake(x, 0, width, CGRectGetHeight(self.frame));
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button setTitleColor:ITEM_COLOR_DEFUALT forState:UIControlStateNormal];
        button.exclusiveTouch = YES;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        x += width;
        totalWidth += width;
    }
    _scrollView.contentSize = CGSizeMake(totalWidth, CGRectGetHeight(self.frame));
}

- (NSArray *)getButtonWidths
{
    CGFloat totalWidth = 0;
    padding = PADDING;
    NSMutableArray *titleWidths = [[NSMutableArray alloc] initWithCapacity:_titles.count];
    NSMutableArray *buttonWidths = [[NSMutableArray alloc] initWithCapacity:_titles.count];

    for (NSString *title in _titles) {
        CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONTSIZE]}].width;
        totalWidth += width + PADDING * 2;

        [titleWidths addObject:@(width)];
    }
    if (totalWidth < CGRectGetWidth(self.frame)) {
        padding += (CGRectGetWidth(self.frame) - totalWidth) / _titles.count / 2;
    }
    for (NSNumber *titleWidth in titleWidths) {
        [buttonWidths addObject:@([titleWidth doubleValue] + padding * 2)];
    }
    return buttonWidths;
}

- (void)tryScrollViewToCenter:(UIView *)view animated:(BOOL)animated
{
    CGFloat offset = view.center.x - self.scrollView.center.x;
    if (offset < 0) {
        offset = 0;
    }
    if (offset > self.scrollView.contentSize.width - CGRectGetMaxX(view.frame)) {
        offset = self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.frame);
    }
    [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:animated];
}

#pragma mark - Event Handlers

- (void)buttonClicked:(UIButton *)button
{
    NSUInteger index = button.tag - BASETAG;
    [self setSelectedIndex:index animated:YES];

    if ([_delegate respondsToSelector:@selector(scrollMenu:didSelectMenuAtIndex:)]) {
        [_delegate scrollMenu:self didSelectMenuAtIndex:index];
    }
}

#pragma mark - Public Interface

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated
{
    _selectedIndex = selectedIndex;

    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (![view isKindOfClass:[UIButton class]]) {
            return;
        }
        UIButton *button = (UIButton *)view;
        NSUInteger tag = BASETAG + selectedIndex;
        if (button.tag == tag) {
            [button setTitleColor:ITEM_COLOR_SELECTED forState:UIControlStateNormal];
            [self tryScrollViewToCenter:button animated:animated];
        } else {
            [button setTitleColor:ITEM_COLOR_DEFUALT forState:UIControlStateNormal];
        }
    }];
}

@end
