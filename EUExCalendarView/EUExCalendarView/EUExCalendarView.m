//
//  EUExCalendarView.m
//  EUExCalendarView
//
//  Created by wang on 16/9/2.
//  Copyright © 2016年 com.wzyu. All rights reserved.
//

#import "EUExCalendarView.h"

@implementation EUExCalendarView

-(void)dealloc{
    [self close:nil];
}
-(void)open:(NSMutableArray *)inArgruments{
    if ([inArgruments count] ==0) {
        
        return;
    }
    ACArgsUnpack(NSDictionary*dict) = inArgruments;
    CGFloat x = [[dict objectForKey:@"x"] floatValue];
    CGFloat y = [[dict objectForKey:@"y"] floatValue];
    CGFloat width = [[dict objectForKey:@"w"] floatValue];
    CGFloat height = [[dict objectForKey:@"h"] floatValue];
    if (!self.calendar) {
        FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(x, y, width, height)];
        calendar.dataSource = self;
        calendar.delegate = self;
        calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
         calendar.scrollDirection = FSCalendarScrollDirectionVertical;
        calendar.backgroundColor = [UIColor whiteColor];
        self.calendar = calendar;
    }
    [[self.webViewEngine webView] addSubview:self.calendar];
}
-(void)close:(NSMutableArray *)array{
    if (self.calendar) {
        [self.calendar removeFromSuperview];
        self.calendar = nil;
    }
}
-(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}
-(void)setSelectedDate:(NSMutableArray *)inArgruments{
    
    if ([inArgruments count] ==0) {
        NSLog(@"params is error!!");
        return;
    }
    ACArgsUnpack(NSDictionary*dict) = inArgruments;
    NSDictionary *dateDict = [dict objectForKey:@"date"];
    NSString *day = [dateDict objectForKey:@"day"];
    NSString *month = [dateDict objectForKey:@"month"];
    NSString *year = [dateDict objectForKey:@"year"];
    NSString *dateFormate = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    NSDate *date = [self convertDateFromString:dateFormate];
    [_calendar setCurrentPage:date animated:YES];
}


#pragma mark - <FSCalendarDelegate>

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    NSString *dataStr = [calendar stringFromDate:date format:@"yyyy-MM-dd"];
    NSArray *dataArr = [dataStr componentsSeparatedByString:@"-"];
    if (dataArr && dataArr.count == 3) {
        dic[@"year"] = dataArr[0];
        dic[@"month"] = dataArr[1];
        dic[@"day"] = dataArr[2];
        resultDic[@"data"] = dic;
    }else{
        resultDic = nil;
    }
    [self.webViewEngine callbackWithFunctionKeyPath:@"uexCalendarView.onItemClick" arguments:ACArgsPack([resultDic ac_JSONFragment])];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"%s %@", __FUNCTION__, [calendar stringFromDate:calendar.currentPage format:@"MMMM yyyy dd"]);
}

@end
