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
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)onTapDeleteLocation:(id)sender;

- (IBAction)onTapGoGoRxListVC:(id)sender;

- (IBAction)onTapGoGoWeeklyForecastVC:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *allergenLevel;
@property (weak, nonatomic) IBOutlet UILabel *predTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (retain) UISwipeGestureRecognizer * swipeLeftRecognizer;
@property (retain) UISwipeGestureRecognizer * swipeRightRecognizer;



- (IBAction)onChangeDefaultCityButtonTap:(id)sender;
- (IBAction)onGoButtonTap:(id)sender;
@end


@implementation RootVC
@synthesize cityLabel,
            deleteButton,
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
id                rootObserver,
                  rxListObserver,
                  weeklyForecastObserver;
int               currentLocationIndex,
                  weekDayValue;
NSArray           *week;
NSMutableDictionary *currentLocation,
                  *tempLocation,
                  *location;
NSMutableArray    *locations;
NSString          *city,
                  *state,
                  *tempZip,
                  *zip,
                  *predominantType;
RxListVC          *rvc;
WeeklyForecastVC  *wvc;


- (void)fetchFavorites {
    for (int i = 1; i < locations.count; i ++) {
        tempLocation = [[NSMutableDictionary alloc] init];
        tempLocation = locations[i];
        tempZip = [tempLocation objectForKey:@"zip"];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://direct.weatherbug.com/DataService/GetPollen.ashx?zip=%@", tempZip]]]
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   tempLocation = [NSJSONSerialization JSONObjectWithData:data
                                                                              options:NSJSONReadingMutableContainers
                                                                                error:&connectionError];
                                   [tempLocation setObject:tempZip forKey:@"zip"];
                                   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                   NSMutableArray *dayList = [[tempLocation objectForKey:@"dayList"] mutableCopy];
                                   for (int x = 2; x < 5; x++) {
                                       NSMutableDictionary *tempForecast = [dayList[x] mutableCopy];
                                       [tempForecast setObject:@"" forKey:@"desc"];
                                       dayList[x] = tempForecast;
                                   }
                                   [tempLocation setObject:dayList forKey:@"dayList"];
                                   [tempLocation setObject:tempZip forKey:@"zip"];
                                   [locations replaceObjectAtIndex:i withObject:tempLocation];
                                   [self savePList];
                               }];
    }
}

- (void) getTheDayOfTheWeek {
    NSDate *today = [NSDate date];
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"EEEE"];
    NSString *dayOfWeek = [myFormatter stringFromDate:today];
    currentDateLabel.text = [NSString stringWithFormat:@"%@", dayOfWeek];

    
}

- (void)loadPList {
    locations = [[NSUserDefaults standardUserDefaults] objectForKey:@"locations"];
    if (!locations) {
        locations = [[NSMutableArray alloc] init];
    }
    cityLabel.text = [location objectForKey:@"city"];
    descriptionTextView.text = [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"desc"];
    predominantTypeLabel.text = [location objectForKey:@"predominantType"];
}

- (void)savePList {
    [[NSUserDefaults standardUserDefaults] setObject:locations forKey:@"locations"];
}

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

- (void)fetchPollenDataFromZip:(NSString *)zipCode {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://direct.weatherbug.com/DataService/GetPollen.ashx?zip=%@", zipCode]]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               location = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&connectionError];
                               if (connectionError) {
                                   UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Please wait" message:@"Refreshing pollen data." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                                   [message show];
                                   cityLabel.text = @"";
                                   descriptionTextView.text = @"";
                                   predominantTypeLabel.text = @"";
                                   [allergenLevelButton setTitle:@"" forState:UIControlStateNormal];
                                   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                   [self performSelector:@selector(dismissAlert:) withObject:message afterDelay:2.0f];
                               } else {
                               cityLabel.text = [location objectForKey:@"city"];
                               descriptionTextView.text = [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"desc"];
                               predominantTypeLabel.text = [location objectForKey:@"predominantType"];
                               [allergenLevelButton setTitle:[NSString stringWithFormat:@"%@", [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"level"]] forState:UIControlStateNormal];
                               [locationManager stopUpdatingLocation];
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               NSMutableArray *dayList = [[location objectForKey:@"dayList"] mutableCopy];
                               for (int i = 2; i < 5; i++) {
                                   NSMutableDictionary *tempForecast = [dayList[i] mutableCopy];
                                   [tempForecast setObject:@"" forKey:@"desc"];
                                   dayList[i] = tempForecast;
                               }
                               [location setObject:dayList forKey:@"dayList"];
                               [location setObject:zipCode forKey:@"zip"];
                               if (currentLocationIndex == 0) {
                                   isCurrentLocation = NO;
                                   currentLocation = location;
                                   if (locations.count  > 0)
                                       [locations replaceObjectAtIndex:0 withObject:currentLocation];
                                   else {
                                       [locations addObject:currentLocation];
                                   }
                               }
                               if (isAddingLocation) {
                                   currentLocationIndex++;
                                   pageControl.numberOfPages++;
                                   [locations addObject:location];
                                   pageControl.currentPage = locations.count;
                                   [self savePList];
                               }
                               [self allergenLevelChangeFontColor];
                               }
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

- (void)viewDidLoad {
    [super viewDidLoad];

    wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WeeklyForecastVC"];
    rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RxListVC"];
    [self loadPList];
    [self buttonBorder];
    [self getTheDayOfTheWeek];
    deleteButton.hidden = YES;
    isCurrentLocation = YES;

    [self swipeLeftGesture];
    locationManager = [[CLLocationManager alloc] init];
    [self getCurrentLocationZip];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    rootObserver = [nc addObserverForName:@"Go To RootVC"
                               object:nil
                                queue:[NSOperationQueue mainQueue]
                           usingBlock:^(NSNotification *note) {
                               [rvc dismissViewControllerAnimated:NO completion:nil];
                               [wvc dismissViewControllerAnimated:NO completion:nil];
                               NSMutableDictionary *tempLocations = [[NSMutableDictionary alloc] init];;
                               tempLocations = (NSMutableDictionary *) note.object;
                               int index = [[tempLocations objectForKey:@"index"] intValue];
                               currentLocationIndex = index;
                               location = [[tempLocations objectForKey:@"locations"] objectAtIndex:index];
                               pageControl.currentPage = index;

                               cityLabel.text = [location objectForKey:@"city"];
                               descriptionTextView.text = [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"desc"];
                               predominantTypeLabel.text = [location objectForKey:@"predominantType"];
                               [allergenLevelButton setTitle:[NSString stringWithFormat:@"%@", [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"level"]] forState:UIControlStateNormal];
    }];
    rxListObserver = [nc addObserverForName:@"Go To RXListVC"
                                     object:nil
                                      queue:[NSOperationQueue mainQueue]
                                 usingBlock:^(NSNotification *note) {
                                     NSMutableDictionary *tempLocations = [[NSMutableDictionary alloc] init];;
                                     tempLocations = (NSMutableDictionary *) note.object;
                                     int index = [[tempLocations objectForKey:@"index"] intValue];
                                     location = [[tempLocations objectForKey:@"locations"] objectAtIndex:index];
                                     rvc.location = location;
                                     rvc.locations = [tempLocations objectForKey:@"locations"];
                                     rvc.currentLocationIndex = index;
                                     rvc.city = [location objectForKey:@"city"];
                                     rvc.state = [location objectForKey:@"state"];
                                     [wvc dismissViewControllerAnimated:NO completion:nil];
                                     [self presentViewController:rvc animated:NO completion:nil];
                                     NSLog(@"Rx touch");
    }];
    weeklyForecastObserver = [nc addObserverForName:@"Go To WeeklyForecastVC"
                                             object:nil
                                              queue:[NSOperationQueue mainQueue]
                                         usingBlock:^(NSNotification *note) {
                                             NSMutableDictionary *tempLocations = [[NSMutableDictionary alloc] init];;
                                             tempLocations = (NSMutableDictionary *) note.object;
                                             int index = [[tempLocations objectForKey:@"index"] intValue];
                                             location = [[tempLocations objectForKey:@"locations"] objectAtIndex:index];
                                             wvc.currentLocationIndex = index;
                                             wvc.location = location;
                                             wvc.locations = [tempLocations objectForKey:@"locations"];
                                             [self dismissViewControllerAnimated:NO completion:nil];
                                             [rvc dismissViewControllerAnimated:NO completion:nil];
                                             [self presentViewController:wvc animated:NO completion:nil];
                                             NSLog(@"5-Day touch");
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self fetchFavorites];
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
    isShown = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    if (currentLocationIndex == 0)
        deleteButton.hidden = YES;
    else deleteButton.hidden = NO;
    isAddingLocation = NO;
    pageControl.numberOfPages = locations.count;
    //pageControl.currentPage = currentLocationIndex;
    cityLabel.text = [location objectForKey:@"city"];
    descriptionTextView.text = [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"desc"];
    predominantTypeLabel.text = [location objectForKey:@"predominantType"];
    [allergenLevelButton setTitle:[NSString stringWithFormat:@"%@", [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"level"]] forState:UIControlStateNormal];

    [self showGifImage];
    [self rotateDandy:dandelionImage duration:1 degrees:2];
    [self makeShadowsOnButton];
}

- (void) makeShadowsOnButton {
    allergenLevelButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    allergenLevelButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    allergenLevelButton.layer.shadowOpacity = .85f;
    allergenLevelButton.layer.shadowRadius = 2.0f;

    allergenLevelButton.layer.cornerRadius = 40.0f;
    allergenLevelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    allergenLevelButton.layer.borderWidth = 2.0f;

    descriptionTextView.layer.cornerRadius = 20.0f;
}

- (void) buttonBorder {
    rootVCDisabledButton.backgroundColor = [UIColor clearColor];
    UIBezierPath *rootVcPath = [UIBezierPath bezierPathWithRoundedRect:rootVCDisabledButton.bounds
                                                     byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                           cornerRadii:CGSizeMake(10.0,10.0)];
    CAShapeLayer *oneDayLayer = [CAShapeLayer layer];
    oneDayLayer.frame = rootVCDisabledButton.bounds;
    oneDayLayer.path = rootVcPath.CGPath;
    oneDayLayer.fillColor = [UIColor veryDarkGreenColor].CGColor;
    oneDayLayer.strokeColor = [UIColor veryDarkGreenColor].CGColor;
    oneDayLayer.lineWidth = 2;
    [rootVCDisabledButton.layer addSublayer:oneDayLayer];

    weeklyForecastVCActiveButton.backgroundColor = [UIColor clearColor];
    UIBezierPath *weeklyPath = [UIBezierPath bezierPathWithRoundedRect:weeklyForecastVCActiveButton.bounds
                                                     byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                           cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *weeklyLayer = [CAShapeLayer layer];
    weeklyLayer.frame = weeklyForecastVCActiveButton.bounds;
    weeklyLayer.path = weeklyPath.CGPath;
    weeklyLayer.fillColor = [UIColor darkGreenColor].CGColor;
    weeklyLayer.strokeColor = [UIColor veryDarkGreenColor].CGColor;
    weeklyLayer.lineWidth = 2;
    [weeklyForecastVCActiveButton.layer addSublayer:weeklyLayer];

    rxListVCActiveButton.backgroundColor = [UIColor clearColor];
    UIBezierPath *rxPath = [UIBezierPath bezierPathWithRoundedRect:rxListVCActiveButton.bounds
                                                 byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                       cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *rxLayer = [ CAShapeLayer layer];
    rxLayer.frame = rxListVCActiveButton.bounds;
    rxLayer.path = rxPath.CGPath;
    rxLayer.fillColor = [UIColor darkGreenColor].CGColor;
    rxLayer.strokeColor = [UIColor veryDarkGreenColor].CGColor;
    rxLayer.lineWidth = 2;
    [rxListVCActiveButton.layer addSublayer:rxLayer];

    [[goButton layer] setBorderWidth:2.0];
    [[goButton layer] setBorderColor:[UIColor blueColor].CGColor];
    [goButton setBackgroundColor:[UIColor whiteColor]];
    [goButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    deleteButton.layer.cornerRadius = 15.0f;
    deleteButton.layer.borderColor = [UIColor whiteColor].CGColor;
    deleteButton.layer.borderWidth = 1.0f;
    deleteButton.layer.shadowColor = [UIColor blackColor].CGColor;
    deleteButton.layer.shadowOpacity = 0.70f;
    deleteButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    deleteButton.layer.shadowRadius = 2.0f;

    changeDefaultCityButton.layer.cornerRadius = 15.0f;
    changeDefaultCityButton.layer.borderColor = [UIColor whiteColor].CGColor;
    changeDefaultCityButton.layer.borderWidth = 1.0f;
    changeDefaultCityButton.layer.shadowRadius = 2.0f;
    changeDefaultCityButton.layer.shadowOpacity = 0.70f;
    changeDefaultCityButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    changeDefaultCityButton.layer.shadowColor = [UIColor blackColor].CGColor;
}

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

- (IBAction)onTapDeleteLocation:(id)sender {
    [locations removeObjectAtIndex:currentLocationIndex];
    currentLocationIndex--;
    location = locations[currentLocationIndex];
    [self viewDidAppear: NO];
    [self savePList];
    if (currentLocationIndex == 0)
        deleteButton.hidden = YES;
}

- (IBAction)onTapGoGoRxListVC:(id)sender {
    NSMutableDictionary *tempLocations = [[NSMutableDictionary alloc] init];;


    [tempLocations setObject:locations forKey:@"locations"];
    [tempLocations setObject:[NSString stringWithFormat:@"%i", currentLocationIndex] forKey:@"index"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Go To RXListVC" object:tempLocations];
}

- (void)swipeLeftDetected:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        // animation Left goes here






        if (currentLocationIndex < locations.count - 1) {
            currentLocationIndex++;
        } else currentLocationIndex = 0;
    } else if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        // animation Right goes here





        if (currentLocationIndex == 0) {
            currentLocationIndex = locations.count - 1;
        } else
            currentLocationIndex--;
    }
    if (currentLocationIndex == 0) {
        location = currentLocation;
    } else {
        location = locations[currentLocationIndex];
    }
    pageControl.currentPage = currentLocationIndex;
    cityLabel.text = [location objectForKey:@"city"];
    descriptionTextView.text = [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"desc"];
    predominantTypeLabel.text = [location objectForKey:@"predominantType"];
    [allergenLevelButton setTitle:[NSString stringWithFormat:@"%@", [[[location objectForKey:@"dayList"] objectAtIndex:0] objectForKey:@"level"]] forState:UIControlStateNormal];
    if (currentLocationIndex == 0)
        deleteButton.hidden = YES;
    else deleteButton.hidden = NO;
}

- (IBAction)onTapGoGoWeeklyForecastVC:(id)sender {

    NSMutableDictionary *tempLocations = [[NSMutableDictionary alloc] init];;
    [tempLocations setObject:locations forKey:@"locations"];
    [tempLocations setObject:[NSString stringWithFormat:@"%i", currentLocationIndex] forKey:@"index"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Go To WeeklyForecastVC" object:tempLocations];
}

- (IBAction)onChangeDefaultCityButtonTap:(id)sender {
    changeDefaultCityButton.hidden = YES;
    enterZipTextField.hidden = NO;
    goButton.frame = CGRectMake(self.view.frame.origin.x + 320, 1000, goButton.frame.size.width, goButton.frame.size.width);
    enterZipTextField.frame = CGRectMake(self.view.frame.origin.x, 1000, self.view.frame.size.width, enterZipTextField.frame.size.height);
    [UIView animateWithDuration:0.25f animations:^{
            enterZipTextField.frame = CGRectMake(self.view.frame.origin.x / 2, descriptionTextView.frame.origin.y + 2, self.view.frame.size.width - 40, enterZipTextField.frame.size.height);
                goButton.frame = CGRectMake(self.view.frame.origin.x + 281, descriptionTextView.frame.origin.y + 2, goButton.frame.size.width, goButton.frame.size.height );
    }];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:rootObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:rxListObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:weeklyForecastObserver];
}

@end
