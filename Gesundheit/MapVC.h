//
//  MapVC.h
//  Gesundheit
//
//  Created by Jhaybie on 10/28/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>


@interface MapVC : UIViewController

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address1;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (nonatomic) CLLocationCoordinate2D coord;

@end
