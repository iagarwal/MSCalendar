//
//  MSMonthViewController.m
//  MSCalendar
//
//  Created by Ishita Agarwal on 22/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import "MSMonthViewController.h"
#import "MSMonthContentController.h"
#import "MSMonthViewModel.h"
#import "MSCalendarSourceModel.h"

@interface MSMonthViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,DayChangeProtocol>
{
    BOOL isAnimationInProgress;
    NSDate *currentMonthDateInCalendar;
}
@end

@implementation MSMonthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.dataSource = self;
    isAnimationInProgress = NO;
    MSMonthContentController *contentVC = [MSMonthContentController instantiateViewController];
    contentVC.dayDelegate = self;
    [self setViewControllers:[NSArray arrayWithObject:contentVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        
    }];
    
    NSMutableArray *gestures = [self.gestureRecognizers mutableCopy];
    //get index of tap gesture which turns page on selecting a day
    NSInteger index = [gestures indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            *stop = YES;
            return YES;
        }
        return  NO;
    }];
    //remove gesture from index
    [gestures removeObjectAtIndex:index];
    [self.view setGestureRecognizers:gestures];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    isAnimationInProgress = YES;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    isAnimationInProgress = NO;
    if (!completed) {
        [[MSMonthViewModel sharedInstance] setCalendarMonth_Year:[MSMonthViewModel sharedInstance].prevCalendarMonth_Year];
    }
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    return [self updateCalendarToNextMonth:NO];
}


- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    return [self updateCalendarToNextMonth:YES];
}

// update dates on basis of month moves to next if goAhead is true or previous if goAhead is false
-(MSMonthContentController *)updateCalendarToNextMonth:(BOOL)goAhead
{
    if (isAnimationInProgress)
    {
        return nil;
    }
    [[MSMonthViewModel sharedInstance] setPrevCalendarMonth_Year:[MSMonthViewModel sharedInstance].calendarMonth_Year];
    [[MSMonthViewModel sharedInstance] updateCalendarMonthToNextMonth:goAhead];
    if (_monthDelegate && [_monthDelegate respondsToSelector:@selector(monthChangedTo:)])
    {
        [_monthDelegate monthChangedTo:[MSMonthViewModel sharedInstance].calendarMonth_Year];
        [[MSCalendarSourceModel sharedInstance] selectCalendarDateInMonthView:[MSMonthViewModel sharedInstance].calendarMonth_Year];

    }
    MSMonthContentController *vc = [MSMonthContentController instantiateViewController];
    vc.dayDelegate = self;
    return vc;
}

//Called to turn page if scrolled date moves to next month date which is not present in current view..
-(void)turnMonthPageToNextPage:(BOOL)moveAhead completion:(void (^)(void))completion
{
    MSMonthContentController *contentVC = [self updateCalendarToNextMonth:moveAhead];
    [self setViewControllers:[NSArray arrayWithObject:contentVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished)
    {
        completion();
    }];
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
