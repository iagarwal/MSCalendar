//
//  MSMonthViewModel.h
//  MSCalendar
//
//  Created by Ishita Agarwal on 24/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MSMonthViewModel : NSObject

@property (strong , nonatomic) NSDate *calendarMonth_Year;
@property (strong , nonatomic) NSDate *prevCalendarMonth_Year;


+(instancetype) sharedInstance;

-(NSString *)monthTitle;
-(NSDate *)updateCalendarMonthToNextMonth:(BOOL)isMovingAhead;
-(NSArray *)monthValuesForRows:(int)rows;
-(NSString *)getShortMonthStringForIndex:(long)index day:(NSDate *)day;
-(NSInteger)totalRowsInMonth;
-(BOOL)isEventPlannedForDate:(NSDate *)date;


@end
