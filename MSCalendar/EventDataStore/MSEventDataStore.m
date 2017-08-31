//
//  MSEventDataStore.m
//  MSCalendar
//
//  Created by Ishita Agarwal on 27/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import "MSEventDataStore.h"

@implementation MSEventDataStore


+(instancetype) sharedInstance
{
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(void)readDummyEventListFromPlist
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DummyEventData" ofType:@"plist"]];
    self.eventList=dictionary;
}

-(NSArray *)eventListForDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [formatter stringFromDate:date];
    NSDictionary *event = [self.eventList objectForKey:dateString];
    if (event) {
        return @[event];
    }
    else
    {
        return nil;
    }
}
@end
