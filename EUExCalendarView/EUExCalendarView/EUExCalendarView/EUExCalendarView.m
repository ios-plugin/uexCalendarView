//
//  EUExCalendarView.m
//  AppCanPlugin
//
//  Created by hongbao.cui on 15-1-10.
//  Copyright (c) 2015年 zywx. All rights reserved.
//

#import "EUExCalendarView.h"
#import "JSON.h"
#import "ABCalendarPicker/ABCalendarPicker.h"
#import "EUtility.h"
@interface EUExCalendarView()<ABCalendarPickerDelegateProtocol>{
    
}
@property (retain, nonatomic) ABCalendarPicker *calendarPicker;
@end
@implementation EUExCalendarView
-(id)initWithBrwView:(EBrowserView *)eInBrwView{
    self = [super initWithBrwView:eInBrwView];
    if (self) {
        
    }
    return self;
}
-(void)clean{
    if (self.calendarPicker) {
        [self.calendarPicker removeFromSuperview];
        self.calendarPicker = nil;
    }
    [super clean];
}
-(void)dealloc{
    if (self.calendarPicker) {
        [self.calendarPicker removeFromSuperview];
        self.calendarPicker = nil;
    }    [super dealloc];
}
-(void)open:(NSMutableArray *)array{
    if ([array count] ==0) {
       
        return;
    }
    NSDictionary *dict = [[array objectAtIndex:0] JSONValue];
    CGFloat x = [[dict objectForKey:@"x"] floatValue];
    CGFloat y = [[dict objectForKey:@"y"] floatValue];
    CGFloat width = [[dict objectForKey:@"w"] floatValue];
    CGFloat height = [[dict objectForKey:@"h"] floatValue];
    if (!self.calendarPicker) {
       ABCalendarPicker *calendarPicker = [[ABCalendarPicker alloc] initWithFrame:CGRectMake(x, y, width, height)];
        self.calendarPicker = calendarPicker;
        [calendarPicker release];
        [self.calendarPicker setDelegate:self];
    }
    [EUtility brwView:self.meBrwView addSubview:self.calendarPicker];
}
-(void)close:(NSMutableArray *)array{
    if (self.calendarPicker) {
        [self.calendarPicker removeFromSuperview];
        self.calendarPicker = nil;
    }
}
-(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}
-(void)setSelectedDate:(NSMutableArray *)argurs{
    if ([argurs count] ==0) {
        NSLog(@"params is error!!");
        return;
    }
    NSDictionary *dict = [[argurs objectAtIndex:0] JSONValue];
    NSDictionary *dateDict = [dict objectForKey:@"date"];
    NSString *day = [dateDict objectForKey:@"day"];
    NSString *month = [dateDict objectForKey:@"month"];
    NSString *year = [dateDict objectForKey:@"year"];
    NSString *dateFormate = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    NSDate *date = [self convertDateFromString:dateFormate];
    [self.calendarPicker setDate:date andState:ABCalendarPickerStateDays animated:YES];
}
- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
//ABCalendarPickerDelegateProtocol
- (void)calendarPicker:(ABCalendarPicker*)calendarPicker
          dateSelected:(NSDate*)date
             withState:(ABCalendarPickerState)state{
    //回调函数
    NSString *stringFromDate = [self stringFromDate:date];
    NSArray *array = [stringFromDate componentsSeparatedByString:@"-"];
    NSArray *keys = [NSArray arrayWithObjects:@"year",@"month",@"day", nil];
    NSMutableDictionary *dateDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:array forKeys:keys];
    [dateDict setObject:dict forKey:@"date"];
    NSString *jsonStr = [NSString stringWithFormat:@"{\"date\":{\"year\":\"%@\",\"month\":\"%@\",\"day\":\"%@\"}}",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2]];
    NSString *json = [NSString stringWithFormat:@"uexCalendarView.onItemClick('%@')",jsonStr];
//    [self.meBrwView stringByEvaluatingJavaScriptFromString:json];
    [EUtility brwView:self.meBrwView evaluateScript:json];
}
@end
