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
#import <QuartzCore/QuartzCore.h>

@interface RootVC ()
@property (weak, nonatomic) IBOutlet UIButton    *searchButtonToggler;
@property (weak, nonatomic) IBOutlet UIButton *changeDefaultCityButton;
@property (weak, nonatomic) IBOutlet UILabel     *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel     *currentDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UILabel     *predominantTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dandelionGifImage;
@property (weak, nonatomic) IBOutlet UITextView  *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextField *enterZipTextField;
@property (weak, nonatomic) IBOutlet UIButton *allergenLevelButton;
@property (weak, nonatomic) IBOutlet UIImageView *dandelionImage;
- (IBAction)onTouchSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addLocationButton;
- (IBAction)onChangeDefaultCityButtonTap:(id)sender;
- (IBAction)onGoButtonTap:(id)sender;
@end


@implementation RootVC
@synthesize cityLabel,
            addLocationButton,
            dandelionImage,
            changeDefaultCityButton,
            currentDateLabel,
            dandelionGifImage,
            descriptionTextView,
            enterZipTextField,
            goButton,
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
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://direct.weatherbug.com/DataService/GetPollen.ashx?zip=%@", zipCode]]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               location = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:&connectionError];
                               changeDefaultCityButton.hidden = NO;
                               cityLabel.text = [location objectForKey:@"city"];
                               descriptionTextView.text = [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"desc"];
                               predominantTypeLabel.text = [location objectForKey:@"predominantType"];
                               [allergenLevelButton setTitle:[NSString stringWithFormat:@"%@", [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"level"]] forState:UIControlStateNormal];
                               [locationManager stopUpdatingLocation];
                               [self allergenLevelChangeFontColor];
                           }];
}

//- (id)path {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths firstObject];
//    return [documentsDirectory stringByAppendingPathComponent:@"Gesundheit.plist"];
//}

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
    dandelionGifImage.image = [UIImage imageNamed:@"skyBackRound2.png"];
    dandelionImage.image = [UIImage imageNamed:@"testDandyDan.png"];
    [dandelionImage setAlpha:.50];

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
    [self buttonBorder];
    [self showGifImage];
    isShown = NO;
    NSString *defaultLocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLocation"];
    if (!defaultLocation) {
        locationManager = [[CLLocationManager alloc] init];
        [self getCurrentLocationZip];
    } else {
        [self fetchPollenDataFromZip:defaultLocation];
    }
}

- (void) buttonBorder {
    [[allergenLevelButton layer] setCornerRadius:40.0f];
    [[allergenLevelButton layer] setOpacity:0.85f];
    [[allergenLevelButton layer] setBorderWidth:4.0f];
    [[allergenLevelButton layer] setBorderColor:[UIColor whiteColor].CGColor];

    [[addLocationButton layer] setCornerRadius:10.0f];
    [[addLocationButton layer] setBorderWidth:2.0f];
    [[addLocationButton layer] setOpacity:.85f];
    [[addLocationButton layer] setBorderColor:[UIColor whiteColor].CGColor];


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

- (IBAction)onChangeDefaultCityButtonTap:(id)sender {
    changeDefaultCityButton.hidden = YES;
    enterZipTextField.hidden = NO;
    [enterZipTextField becomeFirstResponder];
    goButton.hidden = NO;
}

- (IBAction)onGoButtonTap:(id)sender {
    if (enterZipTextField.text.length == 5) {
        [enterZipTextField resignFirstResponder];
        enterZipTextField.hidden = YES;
        goButton.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setObject: enterZipTextField.text forKey:@"defaultLocation"];
        [self fetchPollenDataFromZip:enterZipTextField.text];
    }
}

@end
