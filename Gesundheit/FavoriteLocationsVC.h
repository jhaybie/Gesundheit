//
//  TAFavoriteZipCodeViewController.h
//  Gesundheit
//
//  Created by Daniel Bostjancic on 10/26/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootVC.h"


@interface FavoriteLocationsVC : UIViewController <NSFileManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zip;

@end
