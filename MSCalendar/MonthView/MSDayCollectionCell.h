//
//  MSDayCollectionCell.h
//  MSCalendar
//
//  Created by Ishita Agarwal on 23/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+MSCalender.h"

@interface MSDayCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel  *dayLabel;


@property (weak, nonatomic) IBOutlet UIView   *selectedCircleView;


@property (weak, nonatomic) IBOutlet UILabel  *dotLabel;


@property (weak, nonatomic) IBOutlet UILabel  *monthNameLabel;



@property (assign, nonatomic) BOOL   isEventPlannedForDay;


@property (weak, nonatomic) IBOutlet UILabel  *separatorLine;


@property (assign, nonatomic) MSCalendarMonthType monthType;

@property (assign, nonatomic) int state;


-(void)updateValues:(NSDate *)dayValue month:(NSString *)monthValue ;
@end
