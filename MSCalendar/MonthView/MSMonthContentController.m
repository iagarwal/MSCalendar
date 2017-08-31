//
//  MSMonthContentControllerViewController.m
//  MSCalendar
//
//  Created by Ishita Agarwal on 22/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import "MSMonthContentController.h"
#import "MSDayCollectionCell.h"
#import "MSMonthViewModel.h"
#import "NSDate+MSCalender.h"
#import "MSCalendarSourceModel.h"

@interface MSMonthContentController ()<MSListUpdateProtocol>
{
    NSArray *dayValuesArray;
    NSDate *firstDateOfMonth;
    MSCalendarSourceModel *sourceModel;
    MSMonthViewModel *monthModel;
}
@property (weak, nonatomic) IBOutlet UICollectionView *dayCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *monthNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewBottomConstraint;

@end

@implementation MSMonthContentController


+(instancetype) instantiateViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MSMonthContentController *contentVC = [storyboard instantiateViewControllerWithIdentifier:@"MSMonthContentController"];
    return contentVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    monthModel = [MSMonthViewModel sharedInstance];
    _monthNameLabel.text = [monthModel monthTitle];
    
    NSInteger rowsInMonthView = monthModel.totalRowsInMonth;
    dayValuesArray = [monthModel monthValuesForRows:(int)rowsInMonthView];
    firstDateOfMonth = monthModel.calendarMonth_Year;
    sourceModel = [MSCalendarSourceModel sharedInstance];
    sourceModel.listDelegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return monthModel.totalRowsInMonth;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return 7;
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSDayCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
   
    if ((indexPath.row + indexPath.section*7) < dayValuesArray.count)
    {
        NSDate *dateValue = [dayValuesArray objectAtIndex:(indexPath.row + indexPath.section*7)];
        NSString *monthValue = [monthModel getShortMonthStringForIndex:(indexPath.row + indexPath.section*7) day:dateValue];
        cell.monthType = [dateValue monthTypeWithDate:monthModel.calendarMonth_Year];
        cell.state = sourceModel.calendarViewState;
        cell.isEventPlannedForDay = [monthModel isEventPlannedForDate:dateValue];
        [cell updateValues:dateValue month:monthValue];

    }
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
        return CGSizeMake(_dayCollectionView.bounds.size.width/7, _dayCollectionView.bounds.size.width/7);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //exclude first 7 items as week days & then calculate index of selected item
    if (indexPath.section == 0)
    {
        return;
    }
    if ((((indexPath.section) * 7) + indexPath.item)<dayValuesArray.count) {
        NSDate *selectedDate = [dayValuesArray objectAtIndex:((indexPath.section) * 7) + indexPath.item];
        [sourceModel selectCalendarDateInMonthView:selectedDate];
    }
}

//Delegate method Called when date changed in Agenda list by scrolling to update date on Month view
-(void)eventListDateChangedTo:(NSDate *)scrolledDate withMinimizedView:(MonthViewState)state height:(float)superViewHeight
{
    //set scrolled date to selected date in calendar view.
    [_dayCollectionView reloadData];
    if (scrolledDate && [dayValuesArray containsObject:scrolledDate])
    {
        NSInteger dateIndex = [dayValuesArray indexOfObject:scrolledDate];
        NSInteger section = dateIndex/7;
        NSInteger itemIndex = dateIndex - (section*7);
        if (section<_dayCollectionView.numberOfSections && itemIndex <=[_dayCollectionView numberOfItemsInSection:section])
        {
            [_dayCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:section] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    else if (scrolledDate < [dayValuesArray objectAtIndex:7])
    {
        if (_dayDelegate && [_dayDelegate respondsToSelector:@selector(turnMonthPageToNextPage:completion:)])
        {
            [_dayDelegate turnMonthPageToNextPage:NO completion:^{
            }];
        }
    }
    else if(scrolledDate > dayValuesArray.lastObject)
    {
        if (_dayDelegate && [_dayDelegate respondsToSelector:@selector(turnMonthPageToNextPage:completion:)])
        {
            [_dayDelegate turnMonthPageToNextPage:YES completion:^{

            }];
        }
    }
    else
    {
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
