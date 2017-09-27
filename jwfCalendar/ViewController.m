//
//  ViewController.m
//  jwfCalendar
//
//  Created by htx app on 2017/9/27.
//  Copyright © 2017年 htx app. All rights reserved.
//

#import "ViewController.h"
#import "jwfCalendarView.h"

@interface ViewController ()<jwfCalendarViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)DateSelectBtnAction:(id)sender
{
    jwfCalendarView *calendarview = [[jwfCalendarView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    calendarview.delegate = self;
//    [[[[UIApplication sharedApplication] delegate] window] addSubview:calendarview];
    [self.view addSubview:calendarview];
}

#pragma -mark jwfCalendarViewDelegate
-(void)ClickDay:(NSDate *)selectdate
{
    NSLog(@"jwfCalendarViewDelegate ClickDay");
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"选择日期：yyyy年M月dd日"];
    NSString *str = [fmt stringFromDate:selectdate];
    [self.dateLabel setText:str];
}

@end
