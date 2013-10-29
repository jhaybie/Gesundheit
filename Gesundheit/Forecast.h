//
//  Forecast.h
//  Gesundheit
//
//  Created by Jhaybie on 10/29/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Forecast : NSObject
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zip;
@property (strong, nonatomic) NSString *predominantType;
@property (strong, nonatomic) NSString *desc;
@property (nonatomic) float level;
@end
