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
    [self showResults];
}

- (void) showResults
{
    TALocation *location = [[TALocation alloc] init];
    weeklyForecast = [location fetchPollenData];
    
    _desciptionTextView.text = [weeklyForecast[0] objectForKey:@"desc"];
    _cityLabel.text = [weeklyForecast[0] objectForKey:@"city"];
    _stateAbbreviationLabel.text = [weeklyForecast[0] objectForKey:@"state"];;
    _prodominateTypeLabel.text = [weeklyForecast[0] objectForKey:@"predominantType"];
}

- (void) labelFonts
{
    UIFont *jandaAppleFont = [UIFont fontWithName:@"JandaAppleCobbler" size:17];
    UIFont *airplaneFont = [UIFont fontWithName:@"Helvetica Neue LT Pro-Light" size:8];
}

@end
