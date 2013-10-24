//
//  TAViewController.m
//  Gesundheit
//
//  Created by Jhaybie on 10/23/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "TAViewController.h"
#import "TALocation.h"

@interface TAViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateAbbreviationLabel;
@property (weak, nonatomic) IBOutlet UILabel *allergenLevelLabel;
@property (weak, nonatomic) IBOutlet UITextView *desciptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *prodominateTypeLabel;

@end

@implementation TAViewController {
    NSArray *weeklyForecast;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) showResults
{
    TALocation *location = [[TALocation alloc] init];
    weeklyForecast = [location fetchPollenData];
    NSDictionary *tempDict;

    for (NSDictionary *dict in weeklyForecast) {
        weeklyForecast = [tempDict objectForKey:@"city"];
        weeklyForecast = [tempDict objectForKey:@"desc"];
        weeklyForecast = [tempDict objectForKey:@"predominantType"];
        weeklyForecast = [tempDict objectForKey:@"state"];
        
        location = weeklyForecast[0];
        _desciptionTextView.text = [location desc];
        _cityLabel.text = [location city];
        _stateAbbreviationLabel.text = [location state];
        _prodominateTypeLabel.text = [location predominantType];
    }
}

@end
