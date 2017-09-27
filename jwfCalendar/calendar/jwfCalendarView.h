//
//  jwfCalendarView.h
//  YueDong
//
//  Created by htx app on 2017/9/21.
//  Copyright © 2017年 htx app. All rights reserved.
//

#import <UIKit/UIKit.h>

//屏幕宽度
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
//屏幕高度
#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
//自适应屏幕的高度,默认时iphone5的
#define AUTO_SIZE_IPHONE5_HEIGHT 568*SCREEN_WIDTH/SCREEN_HEIGHT/320

@protocol jwfCalendarViewDelegate<NSObject>

@required  //必须实现的函数
-(void)ClickDay:(NSDate*)selectdate;


@optional  //不要求实现的函数
-(void)Cancle_Action;
-(void)prevButtonAction;
-(void)nextButtonAction;

@end

@interface jwfCalendarView : UIView


@property (nonatomic, weak)id<jwfCalendarViewDelegate>delegate;

@end
