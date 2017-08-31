//
//  MSWeatherView.h
//  MSCalendar
//
//  Created by Ishita Agarwal on 31/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSWeatherView : UIView

@property (nonatomic, weak) IBOutlet UILabel *infoLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *progressIndicator;
@property (nonatomic, weak) IBOutlet UIVisualEffectView *blurredView;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;


-(void)startLoadingAnimationForCity:(NSString *)cityName;
-(void)updateWeatherInfo:(NSDictionary *)weatherInfo inCity:(NSString *)cityName;

@end
