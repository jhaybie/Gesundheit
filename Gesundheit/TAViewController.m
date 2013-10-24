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
    TALocation *location;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    weeklyForecast = [self fetchPollenData];
    location = [[TALocation alloc] init];
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
                               location.city = [initialDump objectForKey:@"city"];
                               NSLog(@"%@", location.city);
                               location.state = [initialDump objectForKey:@"state"];
                               NSLog(@"%@", location.state);
                               location.predominantType = [initialDump objectForKey:@"predominantType"];
                               [self showResults];
                           }];
    return weeklyForecast;
}

- (void) showResults
{
//    TALocation *location = [[TALocation alloc] init];
    if (weeklyForecast.count > 0) {
        _desciptionTextView.text = [weeklyForecast[0] objectForKey:@"desc"];
        _cityLabel.text = location.city;
        _stateAbbreviationLabel.text = location.state.uppercaseString;
        _prodominateTypeLabel.text = location.predominantType;
        _allergenLevelLabel.text = [NSString stringWithFormat:@"%@",[weeklyForecast[0] objectForKey:@"level"]];
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
