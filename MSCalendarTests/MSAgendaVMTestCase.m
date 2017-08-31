//
//  MSAgendaVMTestCase.m
//  MSCalendarTests
//
//  Created by Ishita Agarwal on 31/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MSAgendaViewModel.h"
#import "MSEventDataStore.h"
@interface MSAgendaVMTestCase : XCTestCase

@end

@implementation MSAgendaVMTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIndexOfDate {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    MSAgendaViewModel *model = [[MSAgendaViewModel alloc] init];
    NSInteger dateIndex = [model indexOfDate:[NSDate distantFuture]];
    XCTAssertGreaterThan(dateIndex,0);
}
-(void)testEventData
{
    MSEventDataStore *store = [[MSEventDataStore alloc] init];
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:[NSDate date]];
    [comps setDay:31];
    [comps setMonth:8];
    [comps setYear:2017];
    [store readDummyEventListFromPlist];
    NSArray *eventData = [store eventListForDate:[[NSCalendar currentCalendar] dateFromComponents:comps] ];
    XCTAssertGreaterThan(eventData.count,0);

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        MSEventDataStore *store = [[MSEventDataStore alloc] init];
        [store readDummyEventListFromPlist];

    }];
}

@end
