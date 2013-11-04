//
//  RxListVC.m
//  Gesundheit
//
//  Created by Jhaybie on 10/28/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "RxListVC.h"
#import "RootVC.h"
#import "WeeklyForecastVC.h"
#import "FavoriteLocationsVC.h"
#import "UIColor+ColorCategory.h"
#import <QuartzCore/QuartzCore.h>

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)


@interface Drugstore : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (nonatomic) CLLocationCoordinate2D coord;
@property (nonatomic) BOOL openNow;
@end

@implementation Drugstore
@end


@interface RxListVC ()
@property (weak, nonatomic) IBOutlet UITableView *drugstoresTableView;
@property (strong, nonatomic) IBOutlet UIImageView *backroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *dandyImagePng;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *oneDayActiveButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveDayActiveButton;
@property (weak, nonatomic) IBOutlet UIButton *rxListDisabledButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *citynStateLabel;

- (IBAction)onSearchButtonTap:(id)sender;
- (IBAction)onTapGoGoRootVC:(id)sender;
- (IBAction)onTapGoGoFiveDayForecastVC:(id)sender;
- (IBAction)goGoPageControlSwipe:(id)sender;
@end

@implementation RxListVC
@synthesize  oneDayActiveButton,
             citynStateLabel,
             currentLocationIndex,
             location,
             fiveDayActiveButton,
             rxListDisabledButton,
             backroundImage,
             dandyImagePng,
             city,
             locations,
             pageControl,
             searchButton,
             state,
             drugstoresTableView,
             zipCodeTextField;


CLLocationCoordinate2D coord;
NSArray                *searchResults;
NSMutableArray         *drugstores;
NSString               *name,
                       *address;
//- (BOOL)canBecomeFirstResponder {
//    return true;
//}

//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//    if (motion == UIEventSubtypeMotionShake) {
//        FavoriteLocationsVC *flvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoriteLocationsVC"];
//        [self presentViewController:flvc animated:NO completion:nil];
//    }
//    [super motionEnded:motion withEvent:event];
//}

- (void)swipeLeftDetected:(UISwipeGestureRecognizer *)swipeGestureRecognizer {

    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (currentLocationIndex < locations.count - 1)
            currentLocationIndex++;
        else currentLocationIndex = 0;
    } else if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if (currentLocationIndex == 0)
            currentLocationIndex = locations.count - 1;
        else
            currentLocationIndex--;
    }
//    if (currentLocationIndex != 0) {
//        location = locations[currentLocationIndex];
//        pageControl.currentPage = currentLocationIndex;
//    } else { // location == current location
//        location = currentLocation;
//    }

    location = locations[currentLocationIndex];
    city = [location objectForKey:@"city"];
    state = [location objectForKey:@"state"];
    pageControl.currentPage = currentLocationIndex;
    citynStateLabel.text = [NSString stringWithFormat:@"%@, %@", [location objectForKey:@"city"], [location objectForKey:@"state"]];
    [self fetchSearchResults];
}

- (void)buttonBorders {
    oneDayActiveButton.backgroundColor = [UIColor clearColor];
    UIBezierPath *onePath = [UIBezierPath bezierPathWithRoundedRect:oneDayActiveButton.bounds
                                                  byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                        cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *oneDayLayer = [CAShapeLayer layer];
    oneDayLayer.frame = oneDayActiveButton.bounds;
    oneDayLayer.path = onePath.CGPath;
    oneDayLayer.lineWidth = 2.0f;
    oneDayLayer.fillColor = [UIColor darkGreenColor].CGColor;
    oneDayLayer.strokeColor = [UIColor veryDarkGreenColor].CGColor;
    [oneDayActiveButton.layer addSublayer:oneDayLayer];

    fiveDayActiveButton.backgroundColor = [UIColor clearColor];
    UIBezierPath *fiveDayPath =[UIBezierPath bezierPathWithRoundedRect:fiveDayActiveButton.bounds
                                                     byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                           cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CAShapeLayer *fiveDayLayer = [CAShapeLayer layer];
    fiveDayLayer.frame = fiveDayActiveButton.bounds;
    fiveDayLayer.path = fiveDayPath.CGPath;
    fiveDayLayer.lineWidth = 2.0f;
    fiveDayLayer.fillColor = [UIColor darkGreenColor].CGColor;
    fiveDayLayer.strokeColor = [UIColor veryDarkGreenColor].CGColor;
    [fiveDayActiveButton.layer addSublayer:fiveDayLayer];

    rxListDisabledButton.backgroundColor = [UIColor clearColor];
    UIBezierPath *rxPath = [UIBezierPath bezierPathWithRoundedRect:rxListDisabledButton.bounds
                                                 byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                       cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *rxLayer = [CAShapeLayer layer];
    rxLayer.frame = rxListDisabledButton.bounds;
    rxLayer.path = rxPath.CGPath;
    rxLayer.fillColor = [UIColor veryDarkGreenColor].CGColor;
    rxLayer.strokeColor = [UIColor veryDarkGreenColor].CGColor;
    rxLayer.lineWidth = 2.0f;
    [rxListDisabledButton.layer addSublayer:rxLayer];
    [[searchButton layer] setCornerRadius:15.0f];
    [[searchButton layer] setBorderWidth:1.0f];
    [[searchButton layer] setBorderColor:[UIColor blueColor].CGColor];
}

- (void)fetchSearchResults {
    drugstores = [[NSMutableArray alloc] init];
    city = [city stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    state = [state stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=pharmacies+in+%@+%@&sensor=true&key=AIzaSyChk-7Q-sBiibQi8sUHWb7g3bHc2U1WdPQ", city, state]]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary *initialDump = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:0
                                                                                             error:&connectionError];
                               searchResults = [initialDump objectForKey:@"results"];
                               for (int i = 0; i < searchResults.count; i++) {
                                   NSDictionary *tempDict = [searchResults[i] objectForKey:@"geometry"];
                                   Drugstore *tempRx = [[Drugstore alloc] init];
                                   tempRx.name = [searchResults[i] objectForKey:@"name"];
                                   tempRx.address = [searchResults[i] objectForKey:@"formatted_address"];
                                   tempRx.coord = CLLocationCoordinate2DMake([[[tempDict objectForKey:@"location"] objectForKey:@"lat"] floatValue], [[[tempDict objectForKey:@"location"] objectForKey:@"lng"] floatValue]);
                                   tempRx.openNow = (BOOL)[[searchResults[i] objectForKey:@"opening_hours"] objectForKey:@"open_now"];
                                   [drugstores addObject:tempRx];
                                   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               }
                               [drugstoresTableView reloadData];
                           }];
}

- (void)rotateDandy:(UIImageView *)image
           duration:(NSTimeInterval)duration
            degrees:(CGFloat)degrees {
    [dandyImagePng.layer setAnchorPoint:CGPointMake(0.0, 1.0)];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, nil, -15, 525, 1, DEGREES_TO_RADIANS(90),DEGREES_TO_RADIANS(94), NO);

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
    dandyAnimation.fillMode = kCAFillModeBoth;

    [dandyImagePng.layer addAnimation:dandyAnimation forKey:@"position"];
}

- (void)viewDidAppear:(BOOL)animated {
    pageControl.numberOfPages = locations.count;
    pageControl.currentPage = currentLocationIndex;
    citynStateLabel.text = [NSString stringWithFormat:@"%@, %@", [location objectForKey:@"city"], [location objectForKey:@"state"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buttonBorders];
    [self showBackgroundImages];
    [self rotateDandy:dandyImagePng duration:1 degrees:2];
    [self fetchSearchResults];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *swipeRecognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftDetected:)];
    swipeRecognizer2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    [self.view addGestureRecognizer:swipeRecognizer2];
}

- (void) showBackgroundImages {
    backroundImage.image = [UIImage imageNamed:@"skyBackRound2.png"];
    dandyImagePng.image = [UIImage imageNamed:@"testDandyDan.png"];
    [dandyImagePng setAlpha:.5];
    [drugstoresTableView setAlpha:.75];

}

- (IBAction)onBackButtonTap:(id)sender {
    [self dismissViewControllerAnimated:NO
                             completion:nil];
}

#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
    return drugstores.count;
}

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Drugstore *tempDrugstore = drugstores[indexPath.row];
    name = tempDrugstore.name;
    address = [[tempDrugstore.address componentsSeparatedByString:@", "] firstObject];
    city = [[tempDrugstore.address componentsSeparatedByString:@", "] objectAtIndex:1];
    state = [[tempDrugstore.address componentsSeparatedByString:@", "] objectAtIndex:2];
    coord = tempDrugstore.coord;

    MapVC *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
    mvc.name = name;
    mvc.address1 = address;
    mvc.city = city;
    mvc.state = state;
    mvc.coord = coord;
    [self presentViewController:mvc animated:NO completion:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xxx"];
    Drugstore *tempDrugstore = drugstores[indexPath.row];
    cell.textLabel.text = tempDrugstore.name;
    cell.detailTextLabel.numberOfLines = 2;
    NSString *tempAddress1 = [[tempDrugstore.address componentsSeparatedByString:@", "] firstObject];
    NSString *tempCity = [[tempDrugstore.address componentsSeparatedByString:@", "] objectAtIndex:1];
    NSString *tempState = [[tempDrugstore.address componentsSeparatedByString:@", "] objectAtIndex:2];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@, %@", tempAddress1, tempCity, tempState];
    return cell;
}

- (IBAction)onSearchButtonTap:(id)sender {
    [zipCodeTextField resignFirstResponder];
    city = zipCodeTextField.text;
    state = @"";
    [self fetchSearchResults];
    zipCodeTextField.text = @"";
}

- (IBAction)onTapGoGoRootVC:(id)sender {
    RootVC *rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RootVC"];
    [self presentViewController:rvc
                       animated:NO
                     completion:nil];
}

- (IBAction)onTapGoGoFiveDayForecastVC:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];

    WeeklyForecastVC *wfvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WeeklyForecastVC"];
    wfvc.locations = locations;
    wfvc.location = location;
    [self presentViewController:wfvc
                       animated:NO
                     completion:nil];
}

- (IBAction)goGoPageControlSwipe:(id)sender {
}
@end
