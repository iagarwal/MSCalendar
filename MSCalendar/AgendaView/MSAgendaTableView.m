//
//  MSAgendaTableView.m
//  MSCalendar
//
//  Created by Ishita Agarwal on 27/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import "MSAgendaTableView.h"
#import "MSAgendaViewModel.h"

@implementation MSAgendaTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIView *)viewForSectionHeaderWithText:(NSString *)headerText with:(BOOL)isToday
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, self.frame.size.width, 30.0)];
    [bgView setBackgroundColor: [UIColor whiteColor]];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, self.frame.size.width, 30.0)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width, 30.0)];
    [label setFont:[UIFont systemFontOfSize:16]];
    [headerView setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.3]];
    [label setTextColor:isToday? [UIColor colorWithRed:200.0f / 255.0f green:16.0f / 255.0f blue:46.0f / 255.0f alpha:1.0f] : [UIColor darkGrayColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:headerText];
    [headerView addSubview:label];
    [bgView addSubview:headerView];
    return bgView;
}


@end
