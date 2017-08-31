//
//  MSAgendaTableCell.m
//  MSCalendar
//
//  Created by Ishita Agarwal on 27/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import "MSAgendaTableCell.h"

@implementation MSAgendaTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCellWithEventData:(NSDictionary *)eventData
{
    NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",[eventData objectForKey:@"Time"]] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    [timeString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[eventData objectForKey:@"Duration"] attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor] , NSFontAttributeName:[UIFont systemFontOfSize:14.0]}]];
    [self.timeLabel setAttributedText:timeString];
    
    NSTextAttachment *locationAttachment = [[NSTextAttachment alloc] init];
    locationAttachment.image = [UIImage imageNamed:@"location"];

    NSMutableAttributedString *detailString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",[eventData objectForKey:@"Title"]] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor] , NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    NSMutableAttributedString *locationString = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"x%@",[eventData objectForKey:@"Location"]] attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor], NSFontAttributeName:[UIFont systemFontOfSize:14.0]}]];
    [locationString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:[NSAttributedString attributedStringWithAttachment:locationAttachment]];
    [detailString appendAttributedString:locationString];
    [self.eventDetailLabel setAttributedText:detailString];
    
}
@end
