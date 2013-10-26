//
//  TAViewController.m
//  Gesundheit
//
//  Created by Jhaybie on 10/23/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "TAViewController.h"
#import "TALegendViewController.h"
#import "UIImage+animatedGIF.h"

@interface TAViewController ()
@property (weak, nonatomic) IBOutlet UILabel    *allergenLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel    *cityAndStateLabel;
@property (weak, nonatomic) IBOutlet UILabel    *currentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel    *predominantTypeLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextView *lowTextExplanation;
@property (weak, nonatomic) IBOutlet UITextView *lowMedTextExplanation;
@property (weak, nonatomic) IBOutlet UILabel *medHighLabel;
@property (weak, nonatomic) IBOutlet UITextView *mediumTextExplanation;
@property (weak, nonatomic) IBOutlet UITextView *medHighTextExplanation;
@property (weak, nonatomic) IBOutlet UILabel *mediumLabel;
@property (weak, nonatomic) IBOutlet UITextView *highTextExplanation;
@property (weak, nonatomic) IBOutlet UILabel *lowMedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dandelionGifImage;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UIView *legendView;
@end


@implementation TAViewController
@synthesize
dandelionGifImage,
allergenLevelLabel,
cityAndStateLabel,
currentDateLabel,
descriptionTextView,
lowLabel,
lowMedLabel,
mediumLabel,
medHighLabel,
highLabel,
lowTextExplanation,
lowMedTextExplanation,
mediumTextExplanation,
medHighTextExplanation,
highTextExplanation,
legendView,
predominantTypeLabel;


bool isShown = false;

NSArray
*weeklyForecast;
NSString
*city,
*state,
*zip,
*predominantType,
*startAddress;
UIColor
*darkGreenColor,
*greenColor,
*yellowColor,
*orangeColor,
*redColor;


- (void)getCurrentDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    currentDateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
}

- (void)viewDidAppear:(BOOL)animated {
    [self getCurrentDate];
    legendView.hidden = YES;
    [self showGifImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

-(NSArray *)fetchPollenData {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://direct.weatherbug.com/DataService/GetPollen.ashx?zip=%@", zip]]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary *initialDump = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:0
                                                                                             error:&connectionError];
                               weeklyForecast = [initialDump objectForKey:@"dayList"];
                               city = [initialDump objectForKey:@"city"];
                               state = [initialDump objectForKey:@"state"];
                               predominantType = [initialDump objectForKey:@"predominantType"];
                               [self showResults];
                           }];
    return weeklyForecast;
}

- (void)allergenLevelChangeFontColor {
    float level = allergenLevelLabel.text.floatValue;
    UIColor *backgroundColor;

    if (level >= 0 && level <= 2.4)
        backgroundColor = darkGreenColor;
    else if (level >= 2.5 && level <= 4.8)
        backgroundColor = greenColor;
    else if (level >= 4.9 && level >= 7.2)
        backgroundColor = yellowColor;
    else if (level >= 7.3 && level <= 9.6)
        backgroundColor = orangeColor;
    else
        backgroundColor = redColor;
    allergenLevelLabel.backgroundColor = backgroundColor;
    descriptionTextView.backgroundColor = backgroundColor;
}

- (void)showResults {
    if (weeklyForecast.count > 0) {
        allergenLevelLabel.text = [NSString stringWithFormat:@"%@",[weeklyForecast[0] objectForKey:@"level"]];
        cityAndStateLabel.text = [NSString stringWithFormat:@"%@, %@", city, state.uppercaseString];
        descriptionTextView.text = [weeklyForecast[0] objectForKey:@"desc"];
        predominantTypeLabel.text = predominantType;
    }
    [self allergenLevelChangeFontColor];
}

- (void)labelFonts {
    UIFont *jandaAppleFont = [UIFont fontWithName:@"JandaAppleCobbler"
                                             size:55];
    UIFont *airplaneFont = [UIFont fontWithName:@"Airplanes in the Night Sky"
                                           size:17];

    allergenLevelLabel.font = jandaAppleFont;
    cityAndStateLabel.font = airplaneFont;
}

//    Hey jay take a look at this site i think it may help! sorry hope atleast what i found will help you

//    here is the website:   http://stackoverflow.com/questions/14346516/xcode-ios-clgeocoder-reversegeocodelocation-return-addressstring   check it out!

- (void)getCurrentLocationZip {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    CLLocation *currentLocation = locationManager.location;
    //NSLog(@"%@, ", locationManager.location);
    CLGeocoder *test = [[CLGeocoder alloc] init];
    weeklyForecast = [self fetchPollenData];
    [test reverseGeocodeLocation:currentLocation
               completionHandler:^(NSArray *placemarks, NSError *error) {
                   //if (!error) {
                   CLPlacemark *placemark = [placemarks lastObject];
                   zip = [NSString stringWithFormat:@"%@", placemark.postalCode];

                   weeklyForecast = [self fetchPollenData];
                   //}
                   NSLog(@"%@", placemark.postalCode);
               }];
    weeklyForecast = [self fetchPollenData];
}

//- (void) getCurrentLocationZip {
//    weeklyForecast = [self fetchPollenData];
//    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationManager startUpdatingLocation];
//    CLLocation *tempLocation = locationManager.location;
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:tempLocation completionHandler:
//     ^(NSArray* placemarks, NSError* error){
//         if ([placemarks count] > 0)
//         {
//             CLPlacemark *placemark = [placemarks objectAtIndex:0];
//             zip = [NSString stringWithFormat:@"%@", placemark.postalCode];
//             NSLog(@"%@", placemark.postalCode);
//             NSLog(@" %@",placemark.addressDictionary);
//             NSLog(@"%@", zip);
//         }
//     }];
//}

- (void) showGifImage {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dandeliontry111111" withExtension:@"gif"];
    dandelionGifImage.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    dandelionGifImage.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    dandelionGifImage.alpha = .5;
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
        legendView.transform = CGAffineTransformMakeScale(-2,.5);
        [UIView animateWithDuration:1.55 animations:^{
            legendView.frame =  CGRectMake(50, 210, 250, 315);
            legendView.transform = CGAffineTransformMakeRotation(0);
            legendView.backgroundColor = [UIColor cyanColor];
            legendView.alpha = .95;
            legendView.hidden = NO;
        }];
        isShown = true;
    } else {
        [UIView animateWithDuration:1.55 animations:^{
            legendView.frame =  CGRectMake(50, 110, 100, 200);
            legendView.hidden = YES;
        }];
        isShown = false;
    }
}
@end
