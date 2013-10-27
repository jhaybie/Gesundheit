//
//  TAFavoriteZipCodeViewController.h
//  Gesundheit
//
//  Created by Daniel Bostjancic on 10/26/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootVC.h"

@protocol FavoriteLocationDelegate <NSObject>

- (void)fetchPollenDataFromZip:(NSString *)zipCode;

@end

@interface FavoriteLocationsVC : UIViewController <NSFileManagerDelegate>

@property (strong, nonatomic) id <FavoriteLocationDelegate> delegate;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zip;

@end
