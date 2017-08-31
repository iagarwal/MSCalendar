//
//  ViewController.m
//  MSCalendar
//
//  Created by Ishita Agarwal on 20/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import "MSCalendarViewController.h"
#import "MSMonthViewController.h"
#import "MSMonthViewModel.h"
#import "MSCalendarConstants.h"
#import "MSAgendaTableView.h"
#import "MSAgendaViewModel.h"
#import "NSDate+MSCalender.h"
#import "MSCalendarSourceModel.h"
#import "MSAgendaTableCell.h"
#import "MSLocationFinder.h"
#import "MSWeatherView.h"

@interface MSCalendarViewController ()<MSMonthViewChangeDelegate,UITableViewDelegate,UITableViewDataSource,MSPageUpdateProtocol>
{
    MSAgendaViewModel *agendaSharedModel;
    MSCalendarSourceModel *calendarSourceModel;
    BOOL scrollingInProgress;
    MonthViewState viewState;

}
@property (weak, nonatomic) IBOutlet UIButton *minimizeBtn;
@property (strong,nonatomic) MSMonthViewController *pageController;
@property (weak, nonatomic) IBOutlet UIView *monthView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *monthViewHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *monthViewTrailingConstant;
@property (weak, nonatomic) IBOutlet MSAgendaTableView *agendaTableView;
@property (weak, nonatomic) IBOutlet MSWeatherView *weatherView;


- (IBAction)minimizeBtnClicked:(id)sender;

@end

@implementation MSCalendarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    agendaSharedModel = [MSAgendaViewModel sharedInstance];
    
    calendarSourceModel = [MSCalendarSourceModel sharedInstance];
    
    calendarSourceModel.calendarViewState = MonthViewExpanded;
    calendarSourceModel.pageDelegate = self;
    
    [[MSLocationFinder sharedLocationFinder] setDelegate:calendarSourceModel];
    NSDictionary *options =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                forKey: UIPageViewControllerOptionSpineLocationKey];

    self.monthViewHeightConstant.constant =  self.view.frame.size.width-20;
    self.pageController = [[MSMonthViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options: options];
    self.pageController.monthDelegate = self;
    _pageController.view.backgroundColor = [UIColor blueColor];
    [[_pageController view] setFrame:[[self monthView] bounds]];
    
    [self addChildViewController:_pageController];
    [[self monthView] addSubview:[_pageController view]];
    [_pageController didMoveToParentViewController:self];

    
    
    self.agendaTableView.delegate = self;
    self.agendaTableView.dataSource = self;
    NSInteger currentDateIndex = [[MSAgendaViewModel sharedInstance] indexOfDate:[MSMonthViewModel sharedInstance].calendarMonth_Year];
    scrollingInProgress = YES;
    [self.agendaTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:currentDateIndex] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    _minimizeBtn.hidden = YES;
    
}
-(void)viewWillLayoutSubviews
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma TableView datasource methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSArray *eventList = [agendaSharedModel eventsForSection:indexPath.section];
    if (eventList.count >0) {
        MSAgendaTableCell * cell = (MSAgendaTableCell *)[tableView dequeueReusableCellWithIdentifier:@"AgendaCell"];
        [cell configureCellWithEventData:[eventList objectAtIndex:indexPath.row]];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
        cell.textLabel.text = @"No Events";
        return cell;

    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return agendaSharedModel.numberOfSections;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  [_agendaTableView viewForSectionHeaderWithText:[agendaSharedModel dateStringForIndex:section] with:[agendaSharedModel dateForIndex:section].isToday];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numberOfRows = [agendaSharedModel eventsForSection:indexPath.section].count;
    if (numberOfRows > 0)
    {
        return ROW_HEIGHT_FOREVENT;
    }
    else
    {
        return ROW_HEIGHT_NOEVENT;
    }
        
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = [agendaSharedModel eventsForSection:section].count;
    if (numberOfRows == 0)
    {
        numberOfRows = 1;
    }
    return numberOfRows;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!scrollingInProgress)
    {
        NSIndexPath *firstVisibleCellOnTop = [[_agendaTableView indexPathsForVisibleRows] objectAtIndex:1];
        NSDate *scrolledDate = [agendaSharedModel dateForIndex:firstVisibleCellOnTop.section];
        [calendarSourceModel dateScrolledInCalendarView:scrolledDate withMinimizedView:viewState height:0];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self minimizeMonthView];
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if ((maximumOffset - currentOffset) <= _agendaTableView.frame.size.height)
    {
        NSInteger addedIndexes =[[MSAgendaViewModel sharedInstance] addYearsForEventsInFuture:YES];
        [_agendaTableView beginUpdates];
        [_agendaTableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, addedIndexes)] withRowAnimation:UITableViewRowAnimationFade];
        [_agendaTableView endUpdates];
    }
    else if(currentOffset <= _agendaTableView.frame.size.height )
    {
        NSInteger addedIndexes =[[MSAgendaViewModel sharedInstance] addYearsForEventsInFuture:NO];
        [_agendaTableView beginUpdates];
        [_agendaTableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,addedIndexes)] withRowAnimation:UITableViewRowAnimationFade];
        [_agendaTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:addedIndexes-1] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        [_agendaTableView endUpdates];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    scrollingInProgress = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (void)monthChangedTo:(NSDate *)mmmYYYY {
    //This method is called when month changed by turning page from Month view...
    //Adjust height of Month view as per number of rows which could be 6 or 7 on basis of total days.total days contain previous month days + next month days to cover pending weekday in a month view.
    
    NSInteger rowsInMonthView = [MSMonthViewModel sharedInstance].totalRowsInMonth;
    if (viewState == MonthViewContracted)
    {
        if (rowsInMonthView == MONTH_VIEW_ROWS)
        {
            self.monthViewHeightConstant.constant =  self.view.frame.size.width/2 + 15;
        }
        else
        {
            self.monthViewHeightConstant.constant =  self.view.frame.size.width/2 + 45;
        }
    }
    else
    {
        if (rowsInMonthView == MONTH_VIEW_ROWS)
        {
            self.monthViewHeightConstant.constant =  self.view.frame.size.width-20;
        }
        else
        {
            self.monthViewHeightConstant.constant =  self.view.frame.size.width+30;
        }
    }
}

#pragma Source update protocol
// Called when a date is selected in Month view
//Scroll Agenda view to selected date
-(void)calendarPageDateChangedTo:(NSDate *)selectedDate
{
    NSInteger dateIndex = [agendaSharedModel indexOfDate:selectedDate];
    scrollingInProgress = YES;
    [_agendaTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:dateIndex+1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

//
-(void)minimizeMonthView
{
    if (viewState == MonthViewContracted) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        NSInteger rowsInMonthView = [MSMonthViewModel sharedInstance].totalRowsInMonth;
        self.monthViewTrailingConstant.constant = self.view.frame.size.width*1/2;
        if (rowsInMonthView == MONTH_VIEW_ROWS) {
            self.monthViewHeightConstant.constant =  self.view.frame.size.width/2 + 15;
        }
        else
        {
            self.monthViewHeightConstant.constant =  self.view.frame.size.width/2 + 45;
        }
        viewState = MonthViewContracted;
        calendarSourceModel.calendarViewState = MonthViewContracted;
        _minimizeBtn.hidden = false;

    }];
}

//Minimize agenda list on tap of down arrow button
- (IBAction)minimizeBtnClicked:(id)sender
{
        scrollingInProgress = NO;
    //Update layout to adjust constraint of month view..
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            self.monthViewTrailingConstant.constant = 4;
            NSInteger rowsInMonthView = [MSMonthViewModel sharedInstance].totalRowsInMonth;
            if (rowsInMonthView == MONTH_VIEW_ROWS) {
                self.monthViewHeightConstant.constant =  self.view.frame.size.width-20;
            }
            else
            {
                self.monthViewHeightConstant.constant =  self.view.frame.size.width+30;
            }
            [self updateViewConstraints];
            [UIView animateWithDuration:0 animations:^{
                [self.view layoutIfNeeded];
                [self.monthView layoutIfNeeded];

            } completion:^(BOOL finished) {
                //change state to MonthViewExpanded
                viewState = MonthViewExpanded;
                calendarSourceModel.calendarViewState = MonthViewExpanded;
                
                // update Month view page with scrolled date in list...
                NSIndexPath *firstVisibleCellOnTop = [[_agendaTableView indexPathsForVisibleRows] objectAtIndex:1];
                NSDate *scrolledDate = [agendaSharedModel dateForIndex:firstVisibleCellOnTop.section];
                [calendarSourceModel dateScrolledInCalendarView:scrolledDate withMinimizedView:viewState height:self.monthView.frame.size.width];

            }];

        } completion:^(BOOL finished) {
            _minimizeBtn.hidden = true;
        }];

}

//Called when location gets updated & starts requesting weather data
-(void)startedFetchingForcast:(BOOL)fetching forCity:(NSString *)cityName
{
    if (fetching)
    {
        //show location in weather view
        [_weatherView startLoadingAnimationForCity:cityName];
    }
    else
    {
        
    }
    
}
//called when app receives weather info
-(void)fetchedWeatherForcast:(NSDictionary *)weatherInfo ForCity:(NSString *)cityName
{
    if (weatherInfo) {
        //update weather data in weather view...
        [_weatherView updateWeatherInfo:[weatherInfo objectForKey:@"currently"] inCity:cityName];
    }
    else
    {
        
    }
    
}
@end
