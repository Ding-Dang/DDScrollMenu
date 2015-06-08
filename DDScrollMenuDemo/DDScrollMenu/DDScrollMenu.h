//
//  DDScrollMenu.h
//  DDScrollMenuDemo
//
//  Created by DingDang on 15/6/4.
//  Copyright (c) 2015年 DingDang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDScrollMenu;
@protocol DDScrollMenuDelegate <NSObject>

@optional
- (void)scrollMenu:(DDScrollMenu *)scrollMenu didSelectMenuAtIndex:(NSUInteger)index;

@end

@interface DDScrollMenu : UIView

@property (nonatomic, assign) NSUInteger selectedIndex;            // default: 0
@property (nonatomic, assign) id <DDScrollMenuDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles;

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

@end
