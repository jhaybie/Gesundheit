//
//  TAViewController.m
//  Gesundheit
//
//  Created by Jhaybie on 10/23/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "FavoriteLocationsVC.h"
#import "RootVC.h"
#import "WeeklyForecastVC.h"
#import "RxListVC.h"
#import "UIColor+ColorCategory.h"
#import <QuartzCore/QuartzCore.h>

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)


@interface RootVC ()
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
@property (weak, nonatomic) IBOutlet UIButton *rootVCDisabledButton;
@property (weak, nonatomic) IBOutlet UIButton *weeklyForecastVCActiveButton;
@property (weak, nonatomic) IBOutlet UIButton *rxListVCActiveButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *tabBarGrass;
@property (weak, nonatomic) IBOutlet UIView *lineBar;
@property (weak, nonatomic) IBOutlet UIView *lineBarTop;
@property (weak, nonatomic) IBOutlet UIView *lineBarBottom;

- (IBAction)onTapGoGoRxListVC:(id)sender;
- (IBAction)onSwipeGestureActivated:(id)sender;

- (IBAction)onTapGoGoWeeklyForecastVC:(id)sender;
- (IBAction)swipingPageControlMotion:(id)sender;


@property (retain) UISwipeGestureRecognizer * swipeLeftRecognizer;
@property (retain) UISwipeGestureRecognizer * swipeRightRecognizer;



- (IBAction)onChangeDefaultCityButtonTap:(id)sender;
- (IBAction)onGoButtonTap:(id)sender;
@end


@implementation RootVC
@synthesize cityLabel,
            lineBarBottom,
            lineBarTop,
            lineBar,
            tabBarGrass,
            rxListVCActiveButton,
            weeklyForecastVCActiveButton,
            rootVCDisabledButton,
            dandelionImage,
            changeDefaultCityButton,
            currentDateLabel,
            dandelionGifImage,
            descriptionTextView,
            enterZipTextField,
            goButton,
            pageControl,
            predominantTypeLabel,
            allergenLevelButton;


BOOL              isAddingLocation,
                  isCurrentLocation,
                  isShown;
CLGeocoder        *geocoder;
CLLocationManager *locationManager;
int               currentLocationIndex,
                  weekDayValue;
NSArray           *week;
NSDictionary      *currentLocation,
                  *location;
NSMutableArray    *locations;
NSString          *city,
                  *state,
                  *zip,
                  *predominantType;
UISwipeGestureRecognizer * _swipeLeftRecognizer;
UISwipeGestureRecognizer * _swipeRightRecognizer;

-(void)swipingPageControlMotion:(id)sender {

}

- (void) customTabBarColors {
        [UIView animateWithDuration:3.0f animations:^{

            lineBar.backgroundColor = [UIColor darkGreenColor];
            lineBar.alpha = 0.5;
                    lineBar.frame = CGRectMake(-160, 512, 320, 5);
            tabBarGrass.frame = CGRectMake(0, 776, 320, 208);


            lineBarBottom.backgroundColor = [UIColor veryDarkGreenColor];
            lineBarBottom.alpha = 0.5;
            lineBarBottom.frame = CGRectMake(320, 520, 320, 5);


            lineBarTop.backgroundColor = [UIColor veryDarkGreenColor];
            lineBarTop.alpha = 0.5;
                    lineBarTop.frame = CGRectMake(320, 504, 320, 5);

            lineBar.backgroundColor = [UIColor veryDarkGreenColor];
            lineBar.alpha = 0.85;
                    lineBar.frame = CGRectMake(0, 510, 320, 7);

            lineBarBottom.backgroundColor = [UIColor whiteColor];
            lineBarBottom.alpha = 0.85;
                lineBarBottom.frame = CGRectMake(0, 520, 320, 3);

            lineBarTop.backgroundColor = [UIColor whiteColor];
            lineBarTop.alpha = 0.85;
                lineBarTop.frame = CGRectMake(0, 504, 320, 3);

            rootVCDisabledButton.frame = CGRectMake(30, 490, 100, 50);
            rootVCDisabledButton.alpha = 0.85;
            rootVCDisabledButton.backgroundColor = [UIColor veryDarkGreenColor];
                [[rootVCDisabledButton layer] setBorderWidth:2.0f];

            weeklyForecastVCActiveButton.frame = CGRectMake(133, 490, 100, 50);
            weeklyForecastVCActiveButton.alpha = 0.85f;
            weeklyForecastVCActiveButton.backgroundColor = [UIColor darkGreenColor];
                [[weeklyForecastVCActiveButton layer] setBorderWidth:2.0f];

            rxListVCActiveButton.frame = CGRectMake(236, 490, 100, 50);
            rxListVCActiveButton.alpha = 0.85f;
            rxListVCActiveButton.backgroundColor = [UIColor darkGreenColor];
                [[rxListVCActiveButton layer] setBorderWidth:2.0f];
            tabBarGrass.frame = CGRectMake(0, 360, tabBarGrass.frame.size.width, tabBarGrass.frame.size.width);




    }];


}

- (void)loadPList {
    locations = [[[NSUserDefaults standardUserDefaults] objectForKey:@"locations"] ?: @[] mutableCopy];
    cityLabel.text = [location objectForKey:@"city"];
    descriptionTextView.text = [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"desc"];
    predominantTypeLabel.text = [location objectForKey:@"predominantType"];
    [allergenLevelButton setTitle:[NSString stringWithFormat:@"%@", [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"level"]] forState:UIControlStateNormal];
}

- (void)savePList {
    //[[NSUserDefaults standardUserDefaults] setObject:locations forKey:@"locations"];
}

- (void)getCurrentLocationZip {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)rotateDandy:(UIImageView *)image
           duration:(NSTimeInterval)duration
            degrees:(CGFloat)degrees {
    [dandelionImage.layer setAnchorPoint:CGPointMake(0.0, 1.0)];

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, -15, 590, 1, DEGREES_TO_RADIANS(80),DEGREES_TO_RADIANS(84), NO);

    CAKeyframeAnimation *dandyAnimation;
    dandyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    dandyAnimation.path = path;
    CGPathRelease(path);
    dandyAnimation.duration = duration;
    dandyAnimation.removedOnCompletion = NO;
    dandyAnimation.autoreverses = YES;
    dandyAnimation.rotationMode = kCAAnimationRotateAutoReverse;
    dandyAnimation.speed = .2f;
    dandyAnimation.repeatCount = INFINITY;
//    dandyAnimation.fillMode = kCAFillModeForwards;

    [dandelionImage.layer addAnimation:dandyAnimation forKey:@"position"];
}

- (void)fetchPollenDataFromZip:(NSString *)zipCode {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://direct.weatherbug.com/DataService/GetPollen.ashx?zip=%@", zipCode]]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               location = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&connectionError];
                               cityLabel.text = [location objectForKey:@"city"];
                               descriptionTextView.text = [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"desc"];
                               predominantTypeLabel.text = [location objectForKey:@"predominantType"];
                               [allergenLevelButton setTitle:[NSString stringWithFormat:@"%@", [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"level"]] forState:UIControlStateNormal];
                               [locationManager stopUpdatingLocation];
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               if (isCurrentLocation) {
                                   isCurrentLocation = NO;
                                   currentLocation = location;
                               }
                               if (isAddingLocation) {
                                   currentLocationIndex++;
                                   pageControl.numberOfPages++;
                                   [locations addObject:location];
                                   [self savePList];
                               }
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
    dandelionGifImage.image = [UIImage imageNamed:@"skyBackRound2.png"];
    dandelionImage.image = [UIImage imageNamed:@"testDandyDan.png"];
    [dandelionImage setAlpha:.30];
    tabBarGrass.image = [UIImage imageNamed:@"grass.png"];
    tabBarGrass.alpha = .60;

}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    currentLocationIndex++;
//    location = locations[currentLocationIndex];
//    cityLabel.text = [location objectForKey:@"city"];
//    descriptionTextView.text = [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"desc"];
//    predominantTypeLabel.text = [location objectForKey:@"predominantType"];
//    [allergenLevelButton setTitle:[NSString stringWithFormat:@"%@", [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"level"]] forState:UIControlStateNormal];
//    if ([segue.identifier isEqualToString:@"forecastSegue"]) {
//        WeeklyForecastVC *wfvc = segue.destinationViewController;
//        wfvc.location = location;
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customTabBarColors];
    [self buttonBorder];
    lineBar.backgroundColor = [UIColor veryDarkGreenColor];
    lineBar.alpha = 0.4f;

    lineBarBottom.backgroundColor = [UIColor darkGreenColor];
    lineBarBottom.alpha = 0.4f;

    lineBarTop.backgroundColor = [UIColor darkGreenColor];
    lineBarTop.alpha = 0.4f;


    isCurrentLocation = YES;
//    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftDetected:)];
//    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:swipeRecognizer];

    [self swipeLeftGesture];

//    cityLabel.text = [location objectForKey:@"city"];
//    descriptionTextView.text = [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"desc"];
//    predominantTypeLabel.text = [location objectForKey:@"predominantType"];
//    [allergenLevelButton setTitle:[NSString stringWithFormat:@"%@", [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"level"]] forState:UIControlStateNormal];

    //NSString *defaultLocation = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLocation"];
    locationManager = [[CLLocationManager alloc] init];
    [self getCurrentLocationZip];
    [self fetchPollenDataFromZip:zip];

}
- (void) swipeLeftGesture {
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *swipeRecognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftDetected:)];
    swipeRecognizer2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    [self.view addGestureRecognizer:swipeRecognizer2];
    geocoder = [[CLGeocoder alloc] init];
    currentLocationIndex = 0;
//    [self showGifImage];
    isShown = NO;
    //location = [locations firstObject];
}

//- (void) rightSwipeActions {
//    if (pageControl.numberOfPages !=1) {
//        if (pageControl.currentPage == 0) { //&& sender == _swipeRightRecognizer) {
//            currentLocationIndex++;
//            location = locations[currentLocationIndex];
//            cityLabel.text = [location objectForKey:@"city"];
//            descriptionTextView.text = [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"desc"];
//            predominantTypeLabel.text = [location objectForKey:@"predominantType"];
//            [allergenLevelButton setTitle:[NSString stringWithFormat:@"%@", [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"level"]] forState:UIControlStateNormal];        }
//    }
//}


- (void)viewDidAppear:(BOOL)animated {
    isAddingLocation = NO;
    [self loadPList];
//    cityLabel.text = [location objectForKey:@"city"];
//    descriptionTextView.text = [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"desc"];
//    predominantTypeLabel.text = [location objectForKey:@"predominantType"];
//    [allergenLevelButton setTitle:[NSString stringWithFormat:@"%@", [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"level"]] forState:UIControlStateNormal];

    //[pageControl sizeForNumberOfPages:locations.count];
    pageControl.numberOfPages = locations.count;
    [self customTabBarColors];
    [self rotateDandy:dandelionImage duration:1 degrees:2];
    [self showGifImage];
    [self makeShadowsOnButton];
}

- (void) makeShadowsOnButton {
    allergenLevelButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    allergenLevelButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    allergenLevelButton.layer.shadowOpacity = .85f;
    allergenLevelButton.layer.shadowRadius = 2.0f;
}

- (void) buttonBorder {
    float corner = 25.0f;
    float alpha = 0.7f;

    [[allergenLevelButton layer] setCornerRadius:40.0f];
    [[allergenLevelButton layer] setOpacity:0.85f];
    [[allergenLevelButton layer] setBorderWidth:4.0f];
    [[allergenLevelButton layer] setBorderColor:[UIColor whiteColor].CGColor];

    [[rxListVCActiveButton layer] setCornerRadius:corner];
    [[rxListVCActiveButton layer] setBorderWidth:10.0f];
    [[rxListVCActiveButton layer] setOpacity:alpha];
    [[rxListVCActiveButton layer] setBorderColor:[UIColor veryDarkGreenColor].CGColor];
    rxListVCActiveButton.backgroundColor = [UIColor darkGreenColor];

    [[weeklyForecastVCActiveButton layer] setCornerRadius:corner];
    [[weeklyForecastVCActiveButton layer] setBorderWidth:10.0f];
    [[weeklyForecastVCActiveButton layer] setOpacity:alpha];
    [[weeklyForecastVCActiveButton layer] setBorderColor:[UIColor veryDarkGreenColor].CGColor];
    weeklyForecastVCActiveButton.backgroundColor = [UIColor darkGreenColor];

    [[rootVCDisabledButton layer] setCornerRadius:corner];
    [[rootVCDisabledButton layer] setBorderWidth:10.0f];
    [[rootVCDisabledButton layer] setOpacity:.6f];
    [[rootVCDisabledButton layer] setBorderColor:[UIColor darkGreenColor].CGColor];
    rootVCDisabledButton.backgroundColor = [UIColor veryDarkGreenColor];
    [rootVCDisabledButton setTitleColor:[UIColor veryDarkGreenColor] forState:UIControlStateNormal];
    rootVCDisabledButton.layer.shadowColor = [[UIColor darkGreenColor] CGColor];
    rootVCDisabledButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    rootVCDisabledButton.layer.shadowOpacity = .85f;
    rootVCDisabledButton.layer.shadowRadius = 5.0f;

    [[goButton layer] setCornerRadius:15.0f];
    [[goButton layer] setBorderWidth:1.0];
    [[goButton layer] setBorderColor:[UIColor blueColor].CGColor];

}

// ??????????????????????????????

//- (BOOL)canBecomeFirstResponder {
//    return true;
//}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        FavoriteLocationsVC *flvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoriteLocationsVC"];
        [self presentViewController:flvc animated:NO completion:nil];
    }
    [super motionEnded:motion withEvent:event];
}

#pragma mark CLLocationManagerDelegate

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

- (IBAction)onTapGoGoRxListVC:(id)sender {
    RxListVC *rlvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RxListVC"];
    rlvc.city = [location objectForKey:@"city"];
    rlvc.state = [location objectForKey:@"state"];
    [self presentViewController:rlvc animated:NO completion:nil];
}

- (void)swipeLeftDetected:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    if (swipeGestureRecognizer == _swipeLeftRecognizer) {
        if (currentLocationIndex != locations.count)
            currentLocationIndex++;
        else currentLocationIndex = -1;
    } else { //swipe right detected
        if (currentLocationIndex == -1)
            currentLocationIndex = locations.count - 1;
        else
            currentLocationIndex--;
    }
    if (currentLocationIndex != -1) {
        location = locations[currentLocationIndex];
        pageControl.currentPage = currentLocationIndex;
    } else { // location == current location
        location = currentLocation;
    }
    cityLabel.text = [location objectForKey:@"city"];
    descriptionTextView.text = [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"desc"];
    predominantTypeLabel.text = [location objectForKey:@"predominantType"];
    [allergenLevelButton setTitle:[NSString stringWithFormat:@"%@", [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"level"]] forState:UIControlStateNormal];
}

- (IBAction)onTapGoGoWeeklyForecastVC:(id)sender {
    WeeklyForecastVC *wfvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WeeklyForecastVC"];
    wfvc.location = location;
    [self presentViewController:wfvc
                       animated:NO
                     completion:nil];
}

- (IBAction)onChangeDefaultCityButtonTap:(id)sender {
    changeDefaultCityButton.hidden = YES;
    enterZipTextField.hidden = NO;
    [enterZipTextField becomeFirstResponder];
    goButton.hidden = NO;
}

- (IBAction)onGoButtonTap:(id)sender {
    [enterZipTextField resignFirstResponder];
    enterZipTextField.hidden = YES;
    goButton.hidden = YES;
    changeDefaultCityButton.hidden = NO;
    isAddingLocation = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (enterZipTextField.text.length == 5) {
        [[NSUserDefaults standardUserDefaults] setObject: enterZipTextField.text forKey:@"defaultLocation"];
        [self fetchPollenDataFromZip:enterZipTextField.text];
    }
}

@end
