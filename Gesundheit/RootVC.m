//
//  TAViewController.m
//  Gesundheit
//
//  Created by Jhaybie on 10/23/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//


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
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *dirtBottomPNG;

- (IBAction)onTapDeleteLocation:(id)sender;

- (IBAction)onTapGoGoRxListVC:(id)sender;

- (IBAction)onTapGoGoWeeklyForecastVC:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *buttonBlurr;

@property (weak, nonatomic) IBOutlet UILabel *allergenLevel;
@property (weak, nonatomic) IBOutlet UILabel *predTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (retain) UISwipeGestureRecognizer * swipeLeftRecognizer;
@property (retain) UISwipeGestureRecognizer * swipeRightRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
- (IBAction)onTapGoGoRefreshData:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *hiddenSearchView;



- (IBAction)onChangeDefaultCityButtonTap:(id)sender;
- (IBAction)onGoButtonTap:(id)sender;
@end


@implementation RootVC
@synthesize cityLabel,
            buttonBlurr,
            hiddenSearchView,
            dirtBottomPNG,
            deleteButton,
            lineBarBottom,
            lineBarTop,
            lineBar,
            refreshButton,
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
id                rootObserver,
                  rxListObserver,
                  weeklyForecastObserver;
int               currentLocationIndex,
                  weekDayValue;
NSArray           *week;
NSMutableDictionary *currentLocation,
                  *tempLocation,
                  *location;
//NSMutableArray    *locations;
NSString          *city,
                  *state,
                  *tempZip,
                  *zip,
                  *predominantType;
RxListVC          *rvc;
WeeklyForecastVC  *wvc;


//- (void)fetchFavorites {
//    for (int i = 1; i < locations.count; i ++) {
//        location = locations[i];
//        zip = [location objectForKey:@"zip"];
//        [self fetchPollenData];
//    }
//}

- (void) getTheDayOfTheWeek {
    NSDate *today = [NSDate date];
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"EEEE"];
    NSString *dayOfWeek = [myFormatter stringFromDate:today];
    currentDateLabel.text = [NSString stringWithFormat:@"%@", dayOfWeek];
}

//- (void)loadPList {
//    locations = [[NSUserDefaults standardUserDefaults] objectForKey:@"locations"];
//    if (!locations) {
//        locations = [[NSMutableArray alloc] init];
//    }
//    [self refreshDisplay];
//}
//
//- (void)savePList {
//    [[NSUserDefaults standardUserDefaults] setObject:locations forKey:@"locations"];
//}

- (void)getCurrentLocationZip {
    zip = [[NSString alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)rotateDandy:(UIImageView *)image
           duration:(NSTimeInterval)duration
            degrees:(CGFloat)degrees {
    [dandelionImage.layer setAnchorPoint:CGPointMake(0.0, 1.0)];

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, -15, 525, 1, DEGREES_TO_RADIANS(80),DEGREES_TO_RADIANS(84), NO);

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
    [dandelionImage.layer addAnimation:dandyAnimation forKey:@"position"];
}

-(void)dismissAlert:(UIAlertView *)message {
    [message dismissWithClickedButtonIndex:0 animated:YES];
}

//- (void)fetchPollenDataFromZip:(NSString *)zipCode {
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://direct.weatherbug.com/DataService/GetPollen.ashx?zip=%@", zipCode]]]
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                               if (!data) {
//                                   [self clearDisplay];
//                                   UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                                   [self disableTabs];
//                                   [message show];
//
//                                   return;
//                               }
//                               location = [NSJSONSerialization JSONObjectWithData:data
//                                                                          options:NSJSONReadingMutableContainers
//                                                                            error:&connectionError];
//                               if (connectionError) {
//                                   UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Please wait" message:@"Refreshing pollen data." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//                                   [message show];
//                                   [self clearDisplay];
//                                   [self performSelector:@selector(dismissAlert:) withObject:message afterDelay:2.0f];
//                               } else {
//                                   [self refreshDisplay];
//                                   [self cleanDictionary];
//                                   if (isAddingLocation) {
//                                       [self addLocation];
//                                   }
//                                   if (currentLocationIndex == 0) {
//                                       isCurrentLocation = NO;
//                                       currentLocation = location;
//                                       if (locations.count  > 0)
//                                           [locations replaceObjectAtIndex:0 withObject:currentLocation];
//                                       else {
//                                           deleteButton.hidden = NO;
//                                           [locations addObject:currentLocation];
//                                           pageControl.currentPage = locations.count;
//                                       }
//                                   }
//
//                                   [self allergenLevelChangeFontColor];
//                               }
//
//                           }];
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
    buttonBlurr.layer.borderColor = textColor.CGColor;
    allergenLevelButton.layer.borderColor = textColor.CGColor;

}

- (void)showGifImage {
    dandelionGifImage.image = [UIImage imageNamed:@"skyBackRound2.png"];
    dandelionImage.image = [UIImage imageNamed:@"testDandyDan.png"];
    [dandelionImage setAlpha:.30];

    tabBarGrass.image = [UIImage imageNamed:@"grass.png"];
    tabBarGrass.alpha = .60;

    dirtBottomPNG.image = [UIImage imageNamed:@"dirtMcGurt.png"];
    dirtBottomPNG.alpha = 0.65f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clearDisplay];
    descriptionTextView.textColor = [UIColor blackColor];
    refreshButton.hidden = NO;
    geocoder = [[CLGeocoder alloc] init];
    changeDefaultCityButton.hidden = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Please wait" message:@"Refreshing pollen data." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//    [message show];




    //[self clearDisplay];




    //[self performSelector:@selector(dismissAlert:) withObject:message afterDelay:2.0f];
    wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WeeklyForecastVC"];
    rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RxListVC"];
    //[self loadPList];
    [self buttonBorder];
    [self getTheDayOfTheWeek];

    pageControl.hidden = YES;
    //changeDefaultCityButton.hidden = YES;
    deleteButton.hidden = YES;
    //isCurrentLocation = YES;
    //pageControl.numberOfPages = locations.count;
    //[self swipeLeftGesture];
    locationManager = [[CLLocationManager alloc] init];
    [self getCurrentLocationZip];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    rootObserver = [nc addObserverForName:@"Go To RootVC"
                               object:nil
                                queue:[NSOperationQueue mainQueue]
                           usingBlock:^(NSNotification *note) {
                               [rvc dismissViewControllerAnimated:NO completion:nil];
                               [wvc dismissViewControllerAnimated:NO completion:nil];
                               //NSMutableDictionary *tempLocation = [[NSMutableDictionary alloc] init];;
                               //tempLocation = (NSMutableDictionary *) note.object;
                               //int index = [[tempLocation objectForKey:@"index"] intValue];
                               //currentLocationIndex = index;
                               location = note.object; //[[tempLocations objectForKey:@"locations"] objectAtIndex:index];
                               //pageControl.currentPage = index;

                               [self refreshDisplay];
    }];
    rxListObserver = [nc addObserverForName:@"Go To RXListVC"
                                     object:nil
                                      queue:[NSOperationQueue mainQueue]
                                 usingBlock:^(NSNotification *note) {
                                     //NSMutableDictionary *tempLocations = [[NSMutableDictionary alloc] init];;
                                     //tempLocations = (NSMutableDictionary *) note.object;
                                     location = note.object;
                                     //int index = [[tempLocations objectForKey:@"index"] intValue];
                                     //location = [[tempLocations objectForKey:@"locations"] objectAtIndex:index];
                                     rvc.location = location;
                                     
                                     //rvc.locations = [tempLocations objectForKey:@"locations"];
                                     //rvc.currentLocationIndex = index;
                                     rvc.city = [location objectForKey:@"city"];
                                     rvc.state = [location objectForKey:@"state"];
                                     [wvc dismissViewControllerAnimated:NO completion:nil];
                                     [self presentViewController:rvc animated:NO completion:nil];
    }];
    weeklyForecastObserver = [nc addObserverForName:@"Go To WeeklyForecastVC"
                                             object:nil
                                              queue:[NSOperationQueue mainQueue]
                                         usingBlock:^(NSNotification *note) {
                                             //NSMutableDictionary *tempLocations = [[NSMutableDictionary alloc] init];;
                                             //tempLocations = (NSMutableDictionary *) note.object;
                                             location = note.object;
                                             //int index = [[tempLocations objectForKey:@"index"] intValue];
                                             //location = [[tempLocations objectForKey:@"locations"] objectAtIndex:index];
                                             //wvc.currentLocationIndex = index;
                                             wvc.location = location;
                                             //wvc.locations = [tempLocations objectForKey:@"locations"];
                                             [self dismissViewControllerAnimated:NO completion:nil];
                                             [rvc dismissViewControllerAnimated:NO completion:nil];
                                             [self presentViewController:wvc animated:NO completion:nil];
    }];
    //[self fetchFavorites];
    //[self fetchPollenData];
}

//- (void) swipeLeftGesture {
//    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftDetected:)];
//    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    UISwipeGestureRecognizer *swipeRecognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftDetected:)];
//    swipeRecognizer2.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swipeRecognizer];
//    [self.view addGestureRecognizer:swipeRecognizer2];
//    geocoder = [[CLGeocoder alloc] init];
//    currentLocationIndex = 0;
//    isShown = NO;
//}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    descriptionTextView.layer.cornerRadius = 20.0f;
    buttonBlurr.frame = allergenLevelButton.frame;
    buttonBlurr.layer.borderWidth = 3.0f;
    buttonBlurr.layer.cornerRadius = 45.0f;

    buttonBlurr.alpha = 0.85;
    buttonBlurr.clipsToBounds = YES;
    buttonBlurr.layer.borderColor = [UIColor whiteColor].CGColor;

    allergenLevelButton.backgroundColor = [UIColor lightTextColor];




}

- (void)viewWillAppear:(BOOL)animated {
    
    hiddenSearchView.hidden = YES;
    hiddenSearchView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {
    isAddingLocation = NO;
//    if (location != nil) {
//        [self refreshDisplay];
//    }
        descriptionTextView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self showGifImage];
    [self rotateDandy:dandelionImage duration:1 degrees:2];
    [self makeShadowsOnButton];
}

- (void) makeShadowsOnButton {
    allergenLevelButton.layer.cornerRadius = 40.0f;
    allergenLevelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    allergenLevelButton.layer.borderWidth = 2.0f;

    descriptionTextView.layer.cornerRadius = 20.0f;



    goButton.titleLabel.textColor = [UIColor grayColor];
    goButton.backgroundColor = [UIColor clearColor];
    goButton.layer.borderColor = [UIColor grayColor].CGColor;
    goButton.layer.borderWidth = 1.0f;
    goButton.layer.cornerRadius = 15.0f;

}

- (void) buttonBorder {

    enterZipTextField.layer.cornerRadius = 15.0f;
    rootVCDisabledButton.backgroundColor = [UIColor clearColor];
    UIBezierPath *rootVcPath = [UIBezierPath bezierPathWithRoundedRect:rootVCDisabledButton.bounds
                                                     byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                           cornerRadii:CGSizeMake(10.0,10.0)];
    CAShapeLayer *oneDayLayer = [CAShapeLayer layer];
    oneDayLayer.frame = rootVCDisabledButton.bounds;
    oneDayLayer.path = rootVcPath.CGPath;
    oneDayLayer.fillColor = [UIColor whiteColor].CGColor;
    oneDayLayer.strokeColor = [UIColor whiteColor].CGColor;
    oneDayLayer.lineWidth = 1;
    [rootVCDisabledButton.layer addSublayer:oneDayLayer];
    [rootVCDisabledButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    weeklyForecastVCActiveButton.backgroundColor = [UIColor clearColor];
    UIBezierPath *weeklyPath = [UIBezierPath bezierPathWithRoundedRect:weeklyForecastVCActiveButton.bounds
                                                     byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                           cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *weeklyLayer = [CAShapeLayer layer];
    weeklyLayer.frame = weeklyForecastVCActiveButton.bounds;
    weeklyLayer.path = weeklyPath.CGPath;
    weeklyLayer.fillColor = [UIColor clearColor].CGColor;
    weeklyLayer.strokeColor = [UIColor whiteColor].CGColor;
    weeklyLayer.lineWidth = 1;
    [weeklyForecastVCActiveButton.layer addSublayer:weeklyLayer];

    rxListVCActiveButton.backgroundColor = [UIColor clearColor];
    UIBezierPath *rxPath = [UIBezierPath bezierPathWithRoundedRect:rxListVCActiveButton.bounds
                                                 byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                       cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *rxLayer = [ CAShapeLayer layer];
    rxLayer.frame = rxListVCActiveButton.bounds;
    rxLayer.path = rxPath.CGPath;
    rxLayer.fillColor = [UIColor clearColor].CGColor;
    rxLayer.strokeColor = [UIColor whiteColor].CGColor;
    rxLayer.lineWidth = 1;
    [rxListVCActiveButton.layer addSublayer:rxLayer];

    [[goButton layer] setBorderWidth:1.0];
    [[goButton layer] setBorderColor:[UIColor blueColor].CGColor];
    [goButton setBackgroundColor:[UIColor whiteColor]];
    [goButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    deleteButton.layer.cornerRadius = 20.0f;
    deleteButton.layer.borderColor = [UIColor whiteColor].CGColor;
    deleteButton.layer.borderWidth = 1.0f;

    changeDefaultCityButton.layer.cornerRadius = 20.0f;
    changeDefaultCityButton.layer.borderColor = [UIColor whiteColor].CGColor;
    changeDefaultCityButton.layer.borderWidth = 1.0f;

    refreshButton.layer.cornerRadius = 20.0f;
    refreshButton.layer.borderWidth = 1.0f;
    refreshButton.layer.borderColor = [UIColor whiteColor].CGColor;

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil & placemarks.count > 0) {
            [locationManager stopUpdatingLocation];
            CLPlacemark *placemark = [placemarks lastObject];
            zip = [NSString stringWithFormat:@"%@", placemark.postalCode];
            [self fetchPollenData];
        }
    }];

}


//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation {
//    CLLocation *currentLocation = newLocation;
//    [geocoder reverseGeocodeLocation:currentLocation
//                   completionHandler:^(NSArray* placemarks, NSError* error) {
//                       if (error == nil && placemarks.count > 0) {
//                           [locationManager stopUpdatingLocation];
//                           CLPlacemark *placemark = [placemarks lastObject];
//                           zip = [NSString stringWithFormat:@"%@", placemark.postalCode];
//                           [self fetchPollenData];
//                       }
//                   }];
//}

//- (IBAction)onTapDeleteLocation:(id)sender {
//    [self deleteLocation];
//}

- (IBAction)onTapGoGoRxListVC:(id)sender {
    //NSMutableDictionary *tempLocations = [[NSMutableDictionary alloc] init];;


    //[tempLocations setObject:locations forKey:@"locations"];
    //[tempLocations setObject:[NSString stringWithFormat:@"%i", currentLocationIndex] forKey:@"index"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Go To RXListVC" object:location];
}

//- (void)swipeLeftDetected:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
//    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
//        // animation Left goes here
//
//
//
//
//
//
//        if (currentLocationIndex < locations.count - 1) {
//            currentLocationIndex++;
//        } else currentLocationIndex = 0;
//    } else if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
//        // animation Right goes here
//
//
//
//
//
//        if (currentLocationIndex == 0) {
//            currentLocationIndex = locations.count - 1;
//        } else
//            currentLocationIndex--;
//    }
//    if (currentLocationIndex == 0) {
//        location = currentLocation;
//    } else {
//        location = locations[currentLocationIndex];
//    }
//    [self refreshDisplay];
//}



//        if (currentLocationIndex < locations.count - 1) {
//            currentLocationIndex++;
//        } else currentLocationIndex = 0;
//    } else if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        // animation Right goes here





//        if (currentLocationIndex == 0) {
//            currentLocationIndex = locations.count - 1;
//        } else
//            currentLocationIndex--;
//    }
//    location = locations[currentLocationIndex];
//    [self refreshDisplay];
//}

- (IBAction)onTapGoGoWeeklyForecastVC:(id)sender {

    //NSMutableDictionary *tempLocations = [[NSMutableDictionary alloc] init];;
    //[tempLocations setObject:locations forKey:@"locations"];
    //[tempLocations setObject:[NSString stringWithFormat:@"%i", currentLocationIndex] forKey:@"index"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Go To WeeklyForecastVC" object:location];
}

- (IBAction)onTapGoGoRefreshData:(id)sender {
    [self getCurrentLocationZip];
    [self fetchPollenData];
    //[self fetchFavorites];
    [self enableTabs];
}

- (IBAction)onChangeDefaultCityButtonTap:(id)sender {
    enterZipTextField.text = @"";
    allergenLevelButton.enabled = NO;
    deleteButton.hidden = YES;
    changeDefaultCityButton.hidden = YES;
    enterZipTextField.hidden = NO;
    hiddenSearchView.alpha = 0.9f;
    [UIView animateWithDuration:0.25f animations:^{
        hiddenSearchView.backgroundColor = [UIColor darkGrayColor];
        hiddenSearchView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        hiddenSearchView.layer.borderWidth = 6.0f;
        hiddenSearchView.layer.cornerRadius = 20.0f;
        hiddenSearchView.alpha = .9f;
        hiddenSearchView.hidden = NO;
    }];
    [enterZipTextField becomeFirstResponder];
    goButton.hidden = NO;
}

- (IBAction)onGoButtonTap:(id)sender {
    [enterZipTextField resignFirstResponder];
    hiddenSearchView.layer.cornerRadius = 0.0f;
    hiddenSearchView.hidden = YES;
    hiddenSearchView.backgroundColor = [UIColor clearColor];
    goButton.hidden = YES;
    allergenLevelButton.enabled = YES;
//    if (currentLocationIndex != 0)
//        deleteButton.hidden = NO;
    changeDefaultCityButton.hidden = NO;
    //isAddingLocation = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (enterZipTextField.text.length == 5) {
        zip = enterZipTextField.text;
        [self fetchPollenData];
    } else
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:rootObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:rxListObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:weeklyForecastObserver];
}




- (void)refreshDisplay {

    //call fade out/fade in method here
    
    cityLabel.text = [NSString stringWithFormat:@"%@, %@", [location objectForKey:@"city"], [location objectForKey:@"state"]];
    descriptionTextView.text = [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"desc"];
    predominantTypeLabel.text = [location objectForKey:@"predominantType"];
    [allergenLevelButton setTitle:[NSString stringWithFormat:@"%@", [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"level"]] forState:UIControlStateNormal];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    changeDefaultCityButton.hidden = NO;
    //pageControl.currentPage = currentLocationIndex;
    //pageControl.numberOfPages = locations.count;
//    if (currentLocationIndex == 0) {
//        deleteButton.hidden = YES;
//        isCurrentLocation = YES;
//    }
//    else {
//        deleteButton.hidden = NO;
//        isCurrentLocation = NO;
//    }
}

- (void)clearDisplay {
    cityLabel.text = @"";
    currentDateLabel.text = @"";
    descriptionTextView.text = @"";
    predominantTypeLabel.text = @"";
    [allergenLevelButton setTitle:@"" forState:UIControlStateNormal];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //pageControl.currentPage = currentLocationIndex;
    //pageControl.numberOfPages = locations.count;
    //if (currentLocation == 0)
    //    deleteButton.hidden = YES;
    //else
    //    deleteButton.hidden = NO;
}

- (void)disableTabs {
    weeklyForecastVCActiveButton.enabled = NO;
    rxListVCActiveButton.enabled = NO;
}

- (void)enableTabs {
    weeklyForecastVCActiveButton.enabled = YES;
    rxListVCActiveButton.enabled = YES;
}

- (void)cleanDictionary {
    NSMutableArray *dayList = [[location objectForKey:@"dayList"] mutableCopy];
    for (int i = 2; i < 5; i++) {
        NSMutableDictionary *tempForecast = [dayList[i] mutableCopy];
        [tempForecast setObject:@"" forKey:@"desc"];
        dayList[i] = tempForecast;
    }
    [location setObject:dayList forKey:@"dayList"];
    [location setObject:zip forKey:@"zip"];
}

//- (void)addLocation {
//    [locations addObject:location];
//    currentLocationIndex++;
//    pageControl.numberOfPages = locations.count;
//    pageControl.currentPage = locations.count;
//    [self refreshDisplay];
//    [self savePList];
//    isAddingLocation = NO;
//}

//- (void)deleteLocation {
//    [locations removeObjectAtIndex:currentLocationIndex];
//    currentLocationIndex--;
//    pageControl.numberOfPages = locations.count;
//    location = locations[currentLocationIndex];
//    [self savePList];
//    [self refreshDisplay];
//}

- (void)fetchPollenData {
    id url = [NSURL URLWithString:[NSString stringWithFormat:@"http://direct.weatherbug.com/DataService/GetPollen.ashx?zip=%@", zip]];
    NSLog(@"%@", url);
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
                                            queue:[NSOperationQueue mainQueue]
                                completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (!data) {




                                   //[self clearDisplay];




                                   UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                   [self disableTabs];
                                   [message show];
                                   return;
                               }
                               location = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&connectionError];
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               if (connectionError) {
                                   UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Please wait" message:@"Refreshing pollen data." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                                   [message show];




                                   //[self clearDisplay];




                                   [self performSelector:@selector(dismissAlert:) withObject:message afterDelay:2.0f];
                               } else {
                                   [self enableTabs];
                                   [location setObject:zip forKey:@"zip"];
                                   [self cleanDictionary];
                                   [self refreshDisplay];
//                                   if (isAddingLocation) {
//                                       [self addLocation];
//                                   }
//                                   if (isCurrentLocation) {
//                                       isCurrentLocation = NO;
//                                       currentLocation = location;
//                                       if (locations.count > 0)
//                                           [locations replaceObjectAtIndex:0 withObject:currentLocation];
//                                       else {
//                                           [self addLocation];
//                                       }
//                                   }
                                   [self allergenLevelChangeFontColor];
//                                   if (isAddingLocation) {
//                                       [self addLocation];
//                                   } else {
//                                       if (currentLocationIndex == 0) {
//                                           isCurrentLocation = YES;
//                                           currentLocation = location;
//                                           if (locations.count > 0) {
//                                               [locations replaceObjectAtIndex:0 withObject:currentLocation];
//                                           } else {
//                                               [self addLocation];
//                                           }
//                                       }
//                                   }
                               }
                           }];
}

@end
