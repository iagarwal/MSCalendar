//
//  NSString+MSCalendar.h
//  MSCalendar
//
//  Created by Ishita Agarwal on 26/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MSCalendar)
-(NSString *)dayFromDate;
-(NSUInteger)monthTypeWithDate:(NSDate *)currentDate;
-(BOOL)isToday;
@end
