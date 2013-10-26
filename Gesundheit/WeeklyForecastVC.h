//
//  TAWeeklyForecastViewController.h
//  Gesundheit
//
//  Created by Jhaybie on 10/25/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeeklyForecastVC : UIViewController <UITableViewDataSource>
@property (weak, nonatomic) NSString *city;
@property (weak, nonatomic) NSString *state;
@property (nonatomic) float level;

@end
