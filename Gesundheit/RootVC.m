//
//  TAViewController.m
//  Gesundheit
//
//  Created by Jhaybie on 10/23/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "FavoriteLocationsVC.h"
#import "RootVC.h"
#import "UIImage+animatedGIF.h"
#import "UIColor+ColorCategory.h"

@interface RootVC ()
@property (weak, nonatomic) IBOutlet UIButton    *searchButtonToggler;
@property (weak, nonatomic) IBOutlet UILabel     *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel     *currentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel     *predominantTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dandelionGifImage;
@property (weak, nonatomic) IBOutlet UITextView  *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *allergenLevelButton;
- (IBAction)onTouchSearch:(id)sender;
@end


@implementation RootVC
@synthesize cityLabel,
            currentDateLabel,
            dandelionGifImage,
            descriptionTextView,
            predominantTypeLabel,
            allergenLevelButton,
            searchButtonToggler;


BOOL              isShown;
CLGeocoder        *geocoder;
CLLocationManager *locationManager;
int               weekDayValue;
NSArray           *week;
NSDictionary      *location;
NSString          *city,
                  *state,
                  *zip,
                  *predominantType;

- (void)getCurrentLocationZip {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)fetchPollenDataFromZip:(NSString *)zipCode {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://direct.weatherbug.com/DataService/GetPollen.ashx?zip=%@", zip]]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary *location = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:0
                                                                                             error:&connectionError];
                               cityLabel.text = [location objectForKey:@"city"];
                               descriptionTextView.text = [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"desc"];
                               predominantTypeLabel.text = [location objectForKey:@"predominantType"];
                               [allergenLevelButton setTitle:[NSString stringWithFormat:@"%@", [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"level"]] forState:UIControlStateNormal];
                               [locationManager stopUpdatingLocation];
                               [self allergenLevelChangeFontColor];
                           }];
}

- (void)allergenLevelChangeFontColor {
    float level = allergenLevelButton.currentTitle.floatValue;
    UIColor *textColor;
    if (level >= 0 && level < 2.5)
        textColor = [UIColor lowColor];
    else if (level >= 2.5 && level < 4.9)
        textColor = [UIColor lowMedColor];
    else if (level >= 4.9 && level < 7.3)
        textColor = [UIColor mediumColor];
    else if (level >= 7.3 && level < 9.6)
        textColor = [UIColor medHighColor];
    else
        textColor = [UIColor highColor];
    [allergenLevelButton setTitleColor:textColor forState:UIControlStateNormal];
    descriptionTextView.textColor = [UIColor blackColor];
}

- (void)showGifImage {
    dandelionGifImage.image = [UIImage imageNamed:@"skyBackRoundwithClouds.png"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"forecastSegue"]) {
        WeeklyForecastVC *wfvc = segue.destinationViewController;
        wfvc.location = location;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    geocoder = [[CLGeocoder alloc] init];
    [self showGifImage];
    isShown = NO;
    locationManager = [[CLLocationManager alloc] init];
    [self getCurrentLocationZip];
}

- (IBAction)allergenLevelNumberWasTouched:(id)sender {

}

- (IBAction)onTouchSearch:(id)sender {
        FavoriteLocationsVC *flvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZipCodeController"];
        [self presentViewController:flvc
                           animated:YES
                         completion:nil];
}

#pragma mark CLLocationManagerDelegate

//Ask Don or Max about replacing this deprecated method

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    CLLocation *currentLocation = newLocation;
    [geocoder reverseGeocodeLocation:currentLocation
                   completionHandler:^(NSArray* placemarks, NSError* error) {
                       if (error == nil && placemarks.count > 0) {
                           CLPlacemark *placemark = [placemarks lastObject];
                           zip = [NSString stringWithFormat:@"%@", placemark.postalCode];
                           [self fetchPollenDataFromZip:zip];
                       }
                   }];
}

@end
