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

-(NSArray *) fetchPollenData {
    NSString *zip = @"60654";// [self getCurrentLocationZip];
    weeklyForecast = [[NSArray alloc] init];
    NSString *address = [NSString stringWithFormat:@"http://direct.weatherbug.com/DataService/GetPollen.ashx?zip=%@", zip];
    NSURL *url = [NSURL URLWithString:address];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary *initialDump = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:0
                                                                                             error:&connectionError];
                               weeklyForecast = [initialDump objectForKey:@"dayList"];
                               NSLog(@"%@, %@", [initialDump objectForKey:@"city"], [initialDump objectForKey:@"state"]);
                               NSLog(@"%@", [weeklyForecast[0] objectForKey:@"desc"]);
                               [self showResults];
                           }];
    return weeklyForecast;
}

- (void) showResults
{
//    TALocation *location = [[TALocation alloc] init];
    weeklyForecast = [self fetchPollenData];
    if (!weeklyForecast) {
        _desciptionTextView.text = [weeklyForecast[0] objectForKey:@"desc"];
        _cityLabel.text = [weeklyForecast[0] objectForKey:@"city"];
        _stateAbbreviationLabel.text = [weeklyForecast[0] objectForKey:@"state"];;
        _prodominateTypeLabel.text = [weeklyForecast[0] objectForKey:@"predominantType"];
    }
}

- (void) labelFonts
{
    UIFont *jandaAppleFont = [UIFont fontWithName:@"JandaAppleCobbler" size:88];
    UIFont *airplaneFont = [UIFont fontWithName:@"Airplanes in the Night Sky" size:17];
    _cityLabel.font = airplaneFont;
    _allergenLevelLabel.font = jandaAppleFont;
    _stateAbbreviationLabel.font = airplaneFont;
    
}

@end
