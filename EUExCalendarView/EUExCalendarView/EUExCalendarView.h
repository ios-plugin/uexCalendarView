//
//  EUExCalendarView.h
//  EUExCalendarView
//
//  Created by wang on 16/9/2.
//  Copyright © 2016年 com.wzyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppCanKit/AppCanKit.h>
#import "FSCalendar.h"
@interface EUExCalendarView : EUExBase<FSCalendarDataSource,FSCalendarDelegate>
@property (strong, nonatomic) FSCalendar *calendar;
@end
