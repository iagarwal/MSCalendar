//
//  MSAgendaTableView.h
//  MSCalendar
//
//  Created by Ishita Agarwal on 27/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSAgendaTableView : UITableView 


-(UIView *)viewForSectionHeaderWithText:(NSString *)headerText with:(BOOL)isToday;
@end
