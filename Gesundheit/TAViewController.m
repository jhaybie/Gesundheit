//
//  TAViewController.m
//  Gesundheit
//
//  Created by Jhaybie on 10/23/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "TAViewController.h"
#import "TALocation.h"
#import "TALegendViewController.h"

@interface TAViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateAbbreviationLabel;
@property (weak, nonatomic) IBOutlet UILabel *allergenLevelLabel;
@property (weak, nonatomic) IBOutlet UITextView *desciptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *prodominateTypeLabel;
- (IBAction)onPollenLevelTapShowLegendViewController:(id)sender;

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
                               location.state = [initialDump objectForKey:@"state"];
                               location.predominantType = [initialDump objectForKey:@"predominantType"];
                               [self showResults];
                           }];
    return weeklyForecast;
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    TALegendViewController *lvc = [self.storyboard instantiateViewControllerWithIdentifier:@"legendViewController"];
//    [self.navigationController pushViewController:lvc animated:YES];
//    
//    
//}

//low (0 - 2.4)
//low-medium (2.5 - 4.8)
//medium (4.9 - 7.2)
//medium - high (7.3 - 9.6)
//  High (9.7 - 12)

- (void) allergenLevelChangeFontColor
{
    if (_allergenLevelLabel.text.floatValue >= 0.1 && _allergenLevelLabel.text.floatValue <= 2.4) {
//        _allergenLevelLabel.textColor = [UIColor redColor];
        _allergenLevelLabel.textColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1.0];
    }else if   (_allergenLevelLabel.text.floatValue >= 2.5 && _allergenLevelLabel.text.floatValue <= 4.8) {
        _allergenLevelLabel.textColor = [UIColor colorWithRed:124.0f/255.0f green:252.0f/255.0f blue:0.0f/255.0f alpha:1];
    }else if (_allergenLevelLabel.text.floatValue >= 4.9 && _allergenLevelLabel.text.floatValue >= 7.2) {
        _allergenLevelLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:215.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    }else if (_allergenLevelLabel.text.floatValue >= 7.3 && _allergenLevelLabel.text.floatValue <= 9.6) {
        _allergenLevelLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:140.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    }else {
        _allergenLevelLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    }
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
        NSLog(@"%@", [NSString stringWithFormat:@"%@", [weeklyForecast[0] objectForKey:@"level"]]);
    }
    [self allergenLevelChangeFontColor];
}

- (void) labelFonts
{
    UIFont *jandaAppleFont = [UIFont fontWithName:@"JandaAppleCobbler" size:55];
    UIFont *airplaneFont = [UIFont fontWithName:@"Airplanes in the Night Sky" size:17];
    _cityLabel.font = airplaneFont;
    _allergenLevelLabel.font = jandaAppleFont;
    _stateAbbreviationLabel.font = airplaneFont;
    
}

- (IBAction)onPollenLevelTapShowLegendViewController:(id)sender {
}
@end
