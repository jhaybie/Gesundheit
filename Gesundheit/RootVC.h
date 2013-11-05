//
//  TAViewController.h
//  Gesundheit
//
//  Created by Jhaybie on 10/23/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "WeeklyForecastVC.h"
#import "RxListVC.h"


@interface RootVC : UIViewController <CLLocationManagerDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSMutableDictionary *location;
@property (strong, nonatomic) NSMutableArray *locations;
@property (nonatomic) int currentLocationIndex;
@end