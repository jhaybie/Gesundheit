//
//  TAViewController.m
//  Gesundheit
//
//  Created by Jhaybie on 10/23/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "TAViewController.h"

@interface TAViewController ()

@end

@implementation TAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) showResults
{
    
    
    NSDictionary *tempDict;
    NSArray *tempArray;
    for (NSDictionary *dict in forecastData) {
        forecastData = [tempDict objectForKey:@"city"];
        forecastData = [tempDict objectForKey:@"desc"];
        forecastData = [tempDict objectForKey:@"predominantType"];
        publicTimeline = [tempDict objectForKey:@"state"];
    }
}

@end
