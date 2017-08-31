//
//  MSMonthViewController.h
//  MSCalendar
//
//  Created by Ishita Agarwal on 22/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSMonthViewChangeDelegate <NSObject>

-(void)monthChangedTo:(NSDate *)mmmYYYY;

@end

@interface MSMonthViewController : UIPageViewController

@property (weak,nonatomic) id <MSMonthViewChangeDelegate> monthDelegate;

@end
