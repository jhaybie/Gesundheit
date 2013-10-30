//
//  RxListVC.h
//  Gesundheit
//
//  Created by Jhaybie on 10/28/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "MapVC.h"


@interface RxListVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) NSString *city;
@property (weak, nonatomic) NSString *state;

@end
