//
//  MSAgendaTableCell.h
//  MSCalendar
//
//  Created by Ishita Agarwal on 27/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSAgendaTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel  *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel  *eventDetailLabel;

-(void)configureCellWithEventData:(NSDictionary *)eventData;

@end
