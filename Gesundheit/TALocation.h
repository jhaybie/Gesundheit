//
//  TALocation.h
//  Gesundheit
//
//  Created by Jhaybie on 10/23/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
 
@interface TALocation : NSObject <CLLocationManagerDelegate>
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *predominantType;
@property (nonatomic) float level;

-(NSArray *) fetchPollenData;

@end
