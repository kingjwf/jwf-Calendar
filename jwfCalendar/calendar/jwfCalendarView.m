//
//  jwfCalendarView.m
//  YueDong
//
//  Created by htx app on 2017/9/21.
//  Copyright © 2017年 htx app. All rights reserved.
//

#import "jwfCalendarView.h"




@interface jwfCalendarView ()
{
    UILabel *titleLable;
    
    UIView *bgView;
    UIView *daysView;
    
    NSDate *curdatemouth;    //当前的时间
    NSCalendar *calendar;    //日历类，用于获得当前日期的具体值，年／月／日／时...
    
    UILabel *selectLabel;    //当前选择的日期,用蓝色背景标示
}

@end

@implementation jwfCalendarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)Cancle_Action  //点击背景，隐藏视图
{
    NSLog(@"jwfCalendarView Cancle_Action");
    if (self.delegate && [self.delegate respondsToSelector:@selector(Cancle_Action)]) {
        [self.delegate Cancle_Action];
    }
    [self removeFromSuperview];
    
}

-(void)prevButtonAction
{
    NSLog(@"jwfCalendarView prevButtonAction");
    if (self.delegate && [self.delegate respondsToSelector:@selector(prevButtonAction)]) {
        [self.delegate prevButtonAction];
    }
    
    NSDateComponents *monthComponent = [NSDateComponents new];
    monthComponent.month = -1; // 上一月，时间上减少一月
    curdatemouth = [calendar dateByAddingComponents:monthComponent toDate:curdatemouth options:0];
    

//    curdatemouth = [NSDate dateWithTimeInterval:-30*86400 sinceDate:curdatemouth];
    [self UpdateDaysView];
    
}


-(void)nextButtonAction
{
    NSLog(@"jwfCalendarView nextButtonAction");
    if (self.delegate && [self.delegate respondsToSelector:@selector(nextButtonAction)]) {
        [self.delegate nextButtonAction];
    }
    NSDateComponents *monthComponent = [NSDateComponents new];
    monthComponent.month = 1;  // 下一月，时间上增加一月
    curdatemouth = [calendar dateByAddingComponents:monthComponent toDate:curdatemouth options:0];
    
//    curdatemouth = [NSDate dateWithTimeInterval:30*86400 sinceDate:curdatemouth];
    [self UpdateDaysView];
    
}

-(void)UpdateDaysView
{
    for (UIView *subview in daysView.subviews) {
        [subview removeFromSuperview];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"calendarpage"
                                                     ofType:@"plist"];
    NSDictionary* rootDict= [[NSDictionary alloc]
                             initWithContentsOfFile:path];
    
    NSDictionary *dicssPage = [rootDict objectForKey:@"calendarview"];

    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy MM月"];
    NSString *strcurmouth = [fmt stringFromDate:curdatemouth];
    NSDate *stardate = [fmt dateFromString:strcurmouth];
    
//    转换“01月”为中文的“一月”
    NSString *strZhongMonth = [strcurmouth stringByReplacingOccurrencesOfString:@"01月" withString:@"一月"];
    strZhongMonth = [strZhongMonth stringByReplacingOccurrencesOfString:@"02月" withString:@"二月"];
    strZhongMonth = [strZhongMonth stringByReplacingOccurrencesOfString:@"03月" withString:@"三月"];
    strZhongMonth = [strZhongMonth stringByReplacingOccurrencesOfString:@"04月" withString:@"四月"];
    strZhongMonth = [strZhongMonth stringByReplacingOccurrencesOfString:@"05月" withString:@"五月"];
    strZhongMonth = [strZhongMonth stringByReplacingOccurrencesOfString:@"06月" withString:@"六月"];
    strZhongMonth = [strZhongMonth stringByReplacingOccurrencesOfString:@"07月" withString:@"七月"];
    strZhongMonth = [strZhongMonth stringByReplacingOccurrencesOfString:@"08月" withString:@"八月"];
    strZhongMonth = [strZhongMonth stringByReplacingOccurrencesOfString:@"09月" withString:@"九月"];
    strZhongMonth = [strZhongMonth stringByReplacingOccurrencesOfString:@"10月" withString:@"十月"];
    strZhongMonth = [strZhongMonth stringByReplacingOccurrencesOfString:@"11月" withString:@"十一月"];
    strZhongMonth = [strZhongMonth stringByReplacingOccurrencesOfString:@"12月" withString:@"十二月"];
    titleLable.text = strZhongMonth;
    
    
    NSDateComponents *starcomps = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitMonth fromDate:stardate];
    NSInteger currentMonthIndex = starcomps.month;
    NSInteger currentweekdayIndex = starcomps.weekday;
    for (int n=0; n<31; n++) {
        UILabel* dayLable = [self GetPlistLabel:[dicssPage objectForKey:@"dayLable"]];
        dayLable.textAlignment=NSTextAlignmentCenter;
        [daysView addSubview:dayLable];
//        dayLable.text = [strarr objectAtIndex:n];
        NSDate *dateday = [NSDate dateWithTimeInterval:86400*n sinceDate:stardate];
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        [fmt setDateFormat:@"dd"];
        NSString *strday = [fmt stringFromDate:dateday];
        dayLable.text =  strday;
        
        CGRect rc3 = dayLable.frame;
        long nx = (n+currentweekdayIndex-1)%7;
        long ny = (n+currentweekdayIndex-1)/7;
        rc3.origin.x = rc3.origin.x + 0.135*SCREEN_WIDTH*nx;
        rc3.origin.y = rc3.origin.y + rc3.size.height*ny;
        dayLable.frame = rc3;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch:)];
        dayLable.userInteractionEnabled = YES;
        [dayLable addGestureRecognizer:gesture];
        
        
        NSDateComponents *datedaycomps = [calendar components:NSCalendarUnitMonth fromDate:dateday];
        NSInteger currentdatedayMonthIndex = datedaycomps.month;
        if (currentdatedayMonthIndex != currentMonthIndex) {
            dayLable.hidden = YES;//如果不是当前的月份就隐藏了当天的显示
        }
    }

//    选中的带背景的显示项，在这里创建，在之前就会被覆盖住
    selectLabel = [[UILabel alloc]init];
    selectLabel.backgroundColor = [UIColor blueColor];
    selectLabel.textColor = [UIColor whiteColor];
    selectLabel.frame = CGRectMake(0, 0, 0, 0);
    selectLabel.textAlignment = NSTextAlignmentCenter;
    selectLabel.hidden = YES;
    
    [daysView addSubview:selectLabel];
    
}


- (void)didTouch:(UITapGestureRecognizer *)tap
{
    UILabel *dayLable = (UILabel*)tap.view;
    
    CGFloat sizeCircle = MIN(dayLable.frame.size.width, dayLable.frame.size.height);
    sizeCircle = sizeCircle*0.8;  //获取label的宽高最小值，缩放0.8倍，取圆形区域显示选中项
    selectLabel.frame = CGRectMake(dayLable.frame.origin.x+(dayLable.frame.size.width-sizeCircle)/2, dayLable.frame.origin.y+(dayLable.frame.size.height-sizeCircle)/2, sizeCircle, sizeCircle);
    selectLabel.hidden = NO;
    selectLabel.layer.cornerRadius = sizeCircle/2;  //
    selectLabel.layer.masksToBounds = YES;
    selectLabel.font = dayLable.font;
    selectLabel.text = dayLable.text;
    
    NSDateComponents* selectcomp =  [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour fromDate:curdatemouth];
    [selectcomp setDay:[dayLable.text integerValue]];
    NSDate *selectdate = [calendar dateFromComponents:selectcomp];
    NSLog(@"didTouch,select day:%@，date：%@", dayLable.text, selectdate);
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClickDay:)]) {
        [self.delegate ClickDay:selectdate];
    }
    
//    [self removeFromSuperview];  //在这里是否需要删除视图
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.xarr = [[NSMutableArray alloc]init];
        self.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
        UIButton *Backbtn = [[UIButton alloc]initWithFrame:frame];
        [Backbtn addTarget:self action:@selector(Cancle_Action) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:Backbtn];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"calendarpage"
                                                         ofType:@"plist"];
        NSDictionary* rootDict= [[NSDictionary alloc]
                                 initWithContentsOfFile:path];
        
        NSDictionary *dicssPage = [rootDict objectForKey:@"calendarview"];
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.465*SCREEN_HEIGHT*AUTO_SIZE_IPHONE5_HEIGHT)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        
        titleLable = [self GetPlistLabel:[dicssPage objectForKey:@"titleLabel"]];
        titleLable.textAlignment=NSTextAlignmentCenter;
        [bgView addSubview:titleLable];
        
        UIButton *prevButton = [self GetPlistButton:[dicssPage objectForKey:@"prevButton"]];
        [prevButton addTarget:self action:@selector(prevButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:prevButton];
        
        UIButton *nextButton = [self GetPlistButton:[dicssPage objectForKey:@"nextButton"]];
        [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:nextButton];
        
        UIView* drawlineview = [[UIView alloc]initWithFrame:CGRectMake(0, 0.094*SCREEN_HEIGHT*AUTO_SIZE_IPHONE5_HEIGHT-1, SCREEN_WIDTH, 1)];
        drawlineview.backgroundColor = [UIColor grayColor];
        [bgView addSubview:drawlineview];
        
        [self initweekView];
        
        daysView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.151*SCREEN_HEIGHT*AUTO_SIZE_IPHONE5_HEIGHT, SCREEN_WIDTH, 0.313*SCREEN_HEIGHT*AUTO_SIZE_IPHONE5_HEIGHT)];
        daysView.backgroundColor = [UIColor whiteColor];
        [self addSubview:daysView];
        
        curdatemouth = [[NSDate alloc]init];
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        calendar.timeZone = [NSTimeZone localTimeZone];
        calendar.firstWeekday = 2;// Sunday == 1, Saturday == 7
        [self UpdateDaysView];
    }
    return self;
}

//初始化周一到周日的中文提示label
-(void)initweekView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"calendarpage"
                                                     ofType:@"plist"];
    NSDictionary* rootDict= [[NSDictionary alloc]
                             initWithContentsOfFile:path];
    
    NSDictionary *dicssPage = [rootDict objectForKey:@"calendarview"];
    NSArray *strarr = [NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    
    for (int n=0; n<7; n++) {
        UILabel* dayLable = [self GetPlistLabel:[dicssPage objectForKey:@"weekdayLable"]];
        dayLable.textAlignment=NSTextAlignmentCenter;
        [bgView addSubview:dayLable];
        dayLable.text = [strarr objectAtIndex:n];
        
        CGRect rc3 = dayLable.frame;
        rc3.origin.x = rc3.origin.x + 0.135*SCREEN_WIDTH*n;
    
        dayLable.frame = rc3;
    }
    
}

- (UIColor *)colorFromRGBString2:(NSString *)rgbStr {
    
    if (rgbStr == nil || rgbStr.length == 0)
        return nil;
    
    NSArray *arrayColor = [rgbStr componentsSeparatedByString:@","];
    if (arrayColor.count < 3)
        return nil;
    char *charR = (char *)[[arrayColor objectAtIndex:0] UTF8String];
    char *charG = (char *)[[arrayColor objectAtIndex:1] UTF8String];
    char *charB = (char *)[[arrayColor objectAtIndex:2] UTF8String];
    
    return [UIColor colorWithRed:strtol(charR,&charR,16)/255.0f green:strtol(charG,&charG,16)/255.0f blue:strtol(charB,&charB,16)/255.0f alpha:1.0f];
}

-(UILabel*)GetPlistLabel:(NSDictionary*)dict
{
    NSString *labelRectStr = [dict objectForKey:@"Rect"];
    NSArray *labelRectAry = [labelRectStr componentsSeparatedByString:@","];
    CGRect rcfrom = CGRectMake(0, 0, 0, 0);
    if (labelRectAry.count >= 3) {
        rcfrom.origin.x = [[labelRectAry objectAtIndex:0] floatValue]*SCREEN_WIDTH;//使用数组{0.1，01，0.110，0.110} 修改
        rcfrom.origin.y = [[labelRectAry objectAtIndex:1] floatValue]*SCREEN_HEIGHT*AUTO_SIZE_IPHONE5_HEIGHT;
        rcfrom.size.width = [[labelRectAry objectAtIndex:2] floatValue]*SCREEN_WIDTH;//iphone4高度比切图的高低，宽度拉伸了，是否需要乘以一个比例 AUTO_SIZE_SCREEN  by jwf
        rcfrom.size.height = [[labelRectAry objectAtIndex:3] floatValue]*SCREEN_HEIGHT*AUTO_SIZE_IPHONE5_HEIGHT;
    }
    //    UIColor *labelTextColor = [UIColor colorFromRGBString2:[dict objectForKey:@"Color"]];
    UIColor *labelTextColor = [self colorFromRGBString2:[dict objectForKey:@"Color"]];
    UIFont *labelFont = [UIFont systemFontOfSize:[[dict objectForKey:@"Font"] floatValue]];
    UILabel *label = [[UILabel alloc] init];
    [label setFrame:rcfrom];
    [label setFont:labelFont];
    [label setTextColor:labelTextColor];
    
    NSString *strbtnPathName = [dict objectForKey:@"Name"];
    if (strbtnPathName && ![strbtnPathName isEqualToString:@""])
    {
        label.text = strbtnPathName;
    }
    
    return label;
}
-(UIButton*)GetPlistButton:(NSDictionary*)dicbutton
{
    NSString *strbtnrect = [dicbutton objectForKey:@"buttonRect"];
    NSArray *array = [strbtnrect componentsSeparatedByString:@","];
    CGRect rcfrom = CGRectMake(0, 0, 0, 0);
    if (array.count >= 3) {
        rcfrom.origin.x = [[array objectAtIndex:0] floatValue]*SCREEN_WIDTH;//使用数组{0.1，01，0.110，0.110} 修改
        rcfrom.origin.y = [[array objectAtIndex:1] floatValue]*SCREEN_HEIGHT*AUTO_SIZE_IPHONE5_HEIGHT;
        rcfrom.size.width = [[array objectAtIndex:2] floatValue]*SCREEN_WIDTH;//iphone4高度比切图的高低，宽度拉伸了，是否需要乘以一个比例 AUTO_SIZE_SCREEN  by jwf
        rcfrom.size.height = [[array objectAtIndex:3] floatValue]*SCREEN_HEIGHT*AUTO_SIZE_IPHONE5_HEIGHT;//iphone4高度比切图iphone5的高低，高度缩放了，是否需要乘以一个比例 AUTO_SIZE_IPHONE5_HEIGHT，使视图的高位iphone5的比例，界面显示不下就滚动  by jwf
    }
    NSString *strbtnPathName = [dicbutton objectForKey:@"imagePathName"];
    UIImage *btnImage = [UIImage imageNamed:strbtnPathName];
    UIButton *button = [[UIButton alloc] initWithFrame:rcfrom];
    //    NSString *strbtnName = [dicbutton objectForKey:@"buttonName"];
    //    [button setTitle:strbtnName forState:UIControlStateNormal];
    //    [button setTitleEdgeInsets:UIEdgeInsetsMake(70*SCREEN_HEIGHT, 0.0, 0.0, 0.0)];
    //    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    //    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:btnImage forState:UIControlStateNormal];
    NSString *strbtnPathHighName = [dicbutton objectForKey:@"imagePathNameHigh"];
    if (strbtnPathHighName && ![strbtnPathHighName isEqualToString:@""])
    {
        UIImage *btnHighImage = [UIImage imageNamed:strbtnPathHighName];
        [button setBackgroundImage:btnHighImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:btnHighImage forState:UIControlStateSelected];
    }
    return button;
}

@end
