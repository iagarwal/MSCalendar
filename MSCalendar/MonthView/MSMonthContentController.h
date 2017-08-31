//
//  MSMonthContentControllerViewController.h
//  MSCalendar
//
//  Created by Ishita Agarwal on 22/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DayChangeProtocol <NSObject>

-(void)turnMonthPageToNextPage:(BOOL)moveAhead completion:(void (^)(void))completion;

@end

@interface MSMonthContentController : UIViewController


@property (assign,nonatomic) id <DayChangeProtocol> dayDelegate;

+(instancetype) instantiateViewController;

@end
