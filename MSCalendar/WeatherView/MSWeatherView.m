//
//  MSWeatherView.m
//  MSCalendar
//
//  Created by Ishita Agarwal on 31/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import "MSWeatherView.h"

@implementation MSWeatherView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)startLoadingAnimationForCity:(NSString *)cityName
{
    _detailLabel.hidden = false;
    [self.progressIndicator startAnimating];
    [_detailLabel setAttributedText:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",cityName] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor] , NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}]];;
}
-(void)updateWeatherInfo:(NSDictionary *)weatherInfo inCity:(NSString *)cityName
{
    _detailLabel.hidden = true;
    [self.progressIndicator setHidden:YES];
    NSString *temperature = [weatherInfo objectForKey:@"temperature"];
    NSString *summary = [weatherInfo objectForKey:@"summary"];
    NSString *icon =[weatherInfo objectForKey:@"icon"];
    int temperatureCelcius = (temperature.floatValue-32)/1.8;
    
    NSMutableAttributedString *strWeather = [[NSMutableAttributedString alloc] init];
    NSTextAttachment *iconAttachment = [[NSTextAttachment alloc] init];
    UIImage *weatherImage = [UIImage imageNamed:icon.lowercaseString];
    iconAttachment.image = weatherImage ? weatherImage : [UIImage imageNamed:@"sunny"];
    [strWeather appendAttributedString:[NSAttributedString attributedStringWithAttachment:iconAttachment]];
    [strWeather appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d°",temperatureCelcius] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor] , NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}]];
    [strWeather appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n%@\n",summary] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor] , NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}]];
    [strWeather appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",cityName] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor] , NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}]];
    
    [_infoLabel setAttributedText:strWeather];
    
}

@end
