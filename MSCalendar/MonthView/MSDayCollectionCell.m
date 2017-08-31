//
//  MSDayCollectionCell.m
//  MSCalendar
//
//  Created by Ishita Agarwal on 23/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import "MSDayCollectionCell.h"

@implementation MSDayCollectionCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    _selectedCircleView.frame = self.contentView.frame;
    _selectedCircleView.backgroundColor = [UIColor colorWithRed:200.0f / 255.0f green:16.0f / 255.0f blue:46.0f / 255.0f alpha:0.5f];
    CAShapeLayer *shape = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.contentView.center radius:(self.contentView.bounds.size.width /3)-2 startAngle:0 endAngle:(2 * M_PI) clockwise:YES];
    shape.path = path.CGPath;
    _selectedCircleView.layer.mask = shape;
    self.selectedBackgroundView = _selectedCircleView;
    self.monthNameLabel.hidden = NO;

}


-(void)updateValues:(NSDate *)dayValue month:(NSString *)monthValue
{
    [self.monthNameLabel setText:self.state?@"":monthValue];
    [self.dayLabel setText:dayValue.dayFromDate];
    [self.dayLabel setTextColor:(dayValue.isToday? [UIColor colorWithRed:200.0f / 255.0f green:16.0f / 255.0f blue:46.0f / 255.0f alpha:1.0f]:[UIColor darkGrayColor])];
    CGFloat dayFontSize = self.state?12.0:17.0;
    [self.dayLabel setFont:(self.monthType <= MSCalendarSameMonth? [UIFont boldSystemFontOfSize:dayFontSize] : [UIFont systemFontOfSize:dayFontSize])];
    [self.dotLabel setHidden:self.isEventPlannedForDay ? NO : YES];
}
@end
