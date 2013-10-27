//
//  TAViewController.m
//  Gesundheit
//
//  Created by Jhaybie on 10/23/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "FavoriteLocationsVC.h"
#import "LegendVC.h"
#import "RootVC.h"
#import "UIImage+animatedGIF.h"

@interface RootVC ()

@property (weak, nonatomic) IBOutlet UIButton    *searchButtonToggler;
@property (weak, nonatomic) IBOutlet UILabel     *allergenLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel     *cityAndStateLabel;
@property (weak, nonatomic) IBOutlet UILabel     *currentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel     *highLabel;
@property (weak, nonatomic) IBOutlet UILabel     *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel     *lowMedLabel;
@property (weak, nonatomic) IBOutlet UILabel     *medHighLabel;
@property (weak, nonatomic) IBOutlet UILabel     *mediumLabel;
@property (weak, nonatomic) IBOutlet UILabel     *predominantTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dandelionGifImage;
@property (weak, nonatomic) IBOutlet UITextView  *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextView  *highTextExplanation;
@property (weak, nonatomic) IBOutlet UITextView  *lowTextExplanation;
@property (weak, nonatomic) IBOutlet UITextView  *lowMedTextExplanation;
@property (weak, nonatomic) IBOutlet UITextView  *mediumTextExplanation;
@property (weak, nonatomic) IBOutlet UITextView  *medHighTextExplanation;
@property (weak, nonatomic) IBOutlet UIView      *legendView;
- (IBAction)onTouchSearch:(id)sender;

@end


@implementation RootVC
@synthesize allergenLevelLabel,
            cityAndStateLabel,
            currentDateLabel,
            dandelionGifImage,
            descriptionTextView,
            highLabel,
            highTextExplanation,
            legendView,
            lowLabel,
            lowMedLabel,
            lowMedTextExplanation,
            lowTextExplanation,
            medHighLabel,
            medHighTextExplanation,
            mediumLabel,
            mediumTextExplanation,
            predominantTypeLabel,
            searchButtonToggler;


BOOL              isShown;
CLGeocoder        *geocoder;
CLLocationManager *locationManager;
int               weekDayValue;
NSArray           *week,
                  *weeklyForecast;
NSString          *city,
                  *state,
                  *zip,
                  *predominantType;
UIColor           *darkGreenColor,
                  *greenColor,
                  *yellowColor,
                  *orangeColor,
                  *redColor;


- (void)getCurrentDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    currentDateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
//    if (currentDateLabel.text)
}


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


- (void)getCurrentLocationZip {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)fetchPollenDataFromZip: (NSString *)zipCode {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://direct.weatherbug.com/DataService/GetPollen.ashx?zip=%@", zip]]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary *initialDump = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:0
                                                                                             error:&connectionError];
                               weeklyForecast = [initialDump objectForKey:@"dayList"];
                               city = [initialDump objectForKey:@"city"];
                               state = [initialDump objectForKey:@"state"];
                               zip = [initialDump objectForKey:@"zip"];
                               predominantType = [initialDump objectForKey:@"predominantType"];
                               [self showResults];
                           }];
}

- (void)showResults {
    if (weeklyForecast.count > 0) {
        allergenLevelLabel.text = [NSString stringWithFormat:@"%@",[weeklyForecast[0] objectForKey:@"level"]];
        cityAndStateLabel.text = [NSString stringWithFormat:@"%@", city];
        descriptionTextView.text = [weeklyForecast[0] objectForKey:@"desc"];
        predominantTypeLabel.text = predominantType;
    }
    [locationManager stopUpdatingLocation];
    [self allergenLevelChangeFontColor];
}

- (void)allergenLevelChangeFontColor {
    float level = allergenLevelLabel.text.floatValue;
    UIColor *backgroundColor;
    if (level >= 0 && level < 2.5)
        backgroundColor = darkGreenColor;
    else if (level >= 2.5 && level < 4.9)
        backgroundColor = greenColor;
    else if (level >= 4.9 && level < 7.3)
        backgroundColor = yellowColor;
    else if (level >= 7.3 && level < 9.6)
        backgroundColor = orangeColor;
    else
        backgroundColor = redColor;
    allergenLevelLabel.backgroundColor = backgroundColor;
    descriptionTextView.backgroundColor = backgroundColor;
}

- (void)labelFonts {
    UIFont *jandaAppleFont = [UIFont fontWithName:@"JandaAppleCobbler"
                                             size:55];
    UIFont *airplaneFont = [UIFont fontWithName:@"Airplanes in the Night Sky"
                                           size:17];
    allergenLevelLabel.font = jandaAppleFont;
    cityAndStateLabel.font = airplaneFont;
}

- (void)showGifImage {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dandydan"
                                         withExtension:@"gif"];
    dandelionGifImage.image = [UIImage animatedImageWithAnimatedGIFData:[NSData
                                                  dataWithContentsOfURL:url]];
    dandelionGifImage.image = [UIImage animatedImageWithAnimatedGIFURL:url];
}

- (void)viewDidAppear:(BOOL)animated {
    [self getCurrentDate];
    legendView.hidden = YES;
    enterZipTextField.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    enterZipTextField.hidden = YES;
    geocoder = [[CLGeocoder alloc] init];
    [self showGifImage];
    isShown = NO;
    legendView.hidden = YES;
    locationManager = [[CLLocationManager alloc] init];
    week = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
    [self getCurrentLocationZip];
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

- (IBAction)allergenLevelNumberWasTouched:(id)sender {
    lowLabel.textColor = darkGreenColor;
    lowTextExplanation.backgroundColor = darkGreenColor;
    lowMedLabel.textColor = greenColor;
    lowMedTextExplanation.backgroundColor = greenColor;
    mediumLabel.textColor = yellowColor;
    mediumTextExplanation.backgroundColor = yellowColor;
    medHighLabel.textColor = orangeColor;
    medHighTextExplanation.backgroundColor = orangeColor;
    highLabel.textColor = redColor;
    highTextExplanation.backgroundColor = redColor;
    if (!isShown) {
        legendView.frame =  CGRectMake(0, 0, 50, 50);
        legendView.transform = CGAffineTransformMakeScale(0,0);
        [UIView animateWithDuration:1.55
                         animations:^{
            legendView.frame =  CGRectMake(50, 210, 250, 315);
            legendView.transform = CGAffineTransformMakeRotation(0);
            legendView.backgroundColor = [UIColor cyanColor];
            legendView.alpha = .95;
            legendView.hidden = NO;
        }];
        isShown = true;
    } else {
        [UIView animateWithDuration:1.55
                         animations:^{
            legendView.frame =  CGRectMake(50, 110, 100, 200);
            legendView.hidden = YES;
        }];
        isShown = false;
    }
}

- (IBAction)onTouchSearch:(id)sender {
        FavoriteLocationsVC *flvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZipCodeController"];
        [self fetchPollenDataFromZip:zip];
        flvc.zip = zip;
        flvc.city = city;
        flvc.state = state;
        [self presentViewController:flvc
                           animated:YES
                         completion:nil];
}

@end
