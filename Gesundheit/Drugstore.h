//
//  Drugstore.h
//  Gesundheit
//
//  Created by Jhaybie on 10/29/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface Drugstore : NSObject
@property (weak, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (nonatomic) CLLocationCoordinate2D coord;
@property (nonatomic) BOOL openNow;

@end
