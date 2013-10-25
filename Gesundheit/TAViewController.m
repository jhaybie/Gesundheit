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
@property (weak, nonatomic) IBOutlet UILabel *cityAndStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *allergenLevelLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *predominantTypeLabel;
- (IBAction)onPollenLevelTap:(id)sender;
@end


@implementation TAViewController
NSArray *weeklyForecast;
TALocation *location;
UIColor *darkGreenColor;
UIColor *greenColor;
UIColor *yellowColor;
UIColor *orangeColor;
UIColor *redColor;


- (void)getCurrentDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    _currentDateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    weeklyForecast = [self fetchPollenData];
    location = [[TALocation alloc] init];
    darkGreenColor = [UIColor colorWithRed:34.0f/255.0f
                                     green:139.0f/255.0f
                                      blue:34.0f/255.0f
                                     alpha:1];
    greenColor = [UIColor colorWithRed:124.0f/255.0f
                                 green:252.0f/255.0f
                                  blue:0.0f/255.0f
                                 alpha:1];
    yellowColor = [UIColor colorWithRed:255.0f/255.0f
                                  green:215.0f/255.0f
                                   blue:0.0f/255.0f
                                  alpha:1.0];
    orangeColor = [UIColor colorWithRed:255.0f/255.0f
                                  green:140.0f/255.0f
                                   blue:0.0f/255.0f
                                  alpha:1.0];
    redColor = [UIColor colorWithRed:255.0f/255.0f
                               green:0.0f/255.0f
                                blue:0.0f/255.0f
                               alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getCurrentDate];
}

-(NSArray *) fetchPollenData {
    NSString *zip = [self getCurrentLocationZip];
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

- (void) allergenLevelChangeFontColor {
    float level = _allergenLevelLabel.text.floatValue;
    if (level >= 0.1 && level <= 2.4) {
        _allergenLevelLabel.backgroundColor = darkGreenColor;
        _descriptionTextView.backgroundColor = darkGreenColor;
    } else if (level >= 2.5 && level <= 4.8) {
        _allergenLevelLabel.backgroundColor = greenColor;
        _descriptionTextView.backgroundColor = greenColor;
    } else if (level >= 4.9 && level >= 7.2) {
        _allergenLevelLabel.backgroundColor = yellowColor;
        _descriptionTextView.backgroundColor = yellowColor;
    } else if (level >= 7.3 && level <= 9.6) {
        _allergenLevelLabel.backgroundColor = orangeColor;
        _descriptionTextView.backgroundColor = orangeColor;
    } else {
        _allergenLevelLabel.backgroundColor = redColor;
        _descriptionTextView.backgroundColor = redColor;
    }
}

- (void) showResults {
    if (weeklyForecast.count > 0) {
        _descriptionTextView.text = [weeklyForecast[0] objectForKey:@"desc"];
        _cityAndStateLabel.text = [NSString stringWithFormat:@"%@, %@", location.city, location.state.uppercaseString];
        _predominantTypeLabel.text = location.predominantType;
        _allergenLevelLabel.text = [NSString stringWithFormat:@"%@",[weeklyForecast[0] objectForKey:@"level"]];
    }
    [self allergenLevelChangeFontColor];
}

- (void) labelFonts {
    UIFont *jandaAppleFont = [UIFont fontWithName:@"JandaAppleCobbler" size:55];
    UIFont *airplaneFont = [UIFont fontWithName:@"Airplanes in the Night Sky" size:17];
    _cityAndStateLabel.font = airplaneFont;
    _allergenLevelLabel.font = jandaAppleFont;
}





















- (NSString *)getCurrentLocationZip {
    NSString *zip;
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    CLLocation *currentLocation = locationManager.location;
    CLGeocoder *test;
    [test reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //if (!error) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"%@",[placemark description]);
        //}
    }];
    return zip;
}

- (IBAction)onPollenLevelTap:(id)sender {
}

@end
