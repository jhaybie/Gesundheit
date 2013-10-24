//
//  Location.h
//  Gesundheit
//
//  Created by Hammad A  on 10/24/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * predominantType;

@end
