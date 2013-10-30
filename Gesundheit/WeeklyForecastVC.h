//
//  TAWeeklyForecastViewController.h
//  Gesundheit
//
//  Created by Jhaybie on 10/25/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RxListVC.h"

@interface WeeklyForecastVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSDictionary *location;
@end
