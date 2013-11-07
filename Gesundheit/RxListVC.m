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
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *citynStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *openSearchButton;
@property (weak, nonatomic) IBOutlet UIImageView *grassPNG;
@property (weak, nonatomic) IBOutlet UIImageView *dirtBottomPNG;

- (IBAction)onTapGoGoOpenSearch:(id)sender;
- (IBAction)onSegmentedControlTap:(id)sender;
- (IBAction)onSearchButtonTap:(id)sender;
- (IBAction)onTapGoGoRootVC:(id)sender;
- (IBAction)onTapGoGoFiveDayForecastVC:(id)sender;
- (IBAction)goGoPageControlSwipe:(id)sender;
@end

@implementation RxListVC
@synthesize  oneDayActiveButton,
             grassPNG,
             dirtBottomPNG,
             openSearchButton,
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
             zipCodeTextField,
             segmentedControl;


CLLocationCoordinate2D coord;
NSArray                *searchResults;
NSMutableArray         *drugstores,
                       *doctors;
NSString               *name,
                       *address;

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
    location = locations[currentLocationIndex];
    city = [location objectForKey:@"city"];
    state = [location objectForKey:@"state"];
    pageControl.currentPage = currentLocationIndex;
    citynStateLabel.text = [NSString stringWithFormat:@"%@, %@", [location objectForKey:@"city"], [location objectForKey:@"state"]];
    [self fetchSearchResults];
    [self fetchSearchResultsForDoctors];
}

- (void)buttonBorders {
    oneDayActiveButton.backgroundColor = [UIColor clearColor];
    UIBezierPath *onePath = [UIBezierPath bezierPathWithRoundedRect:oneDayActiveButton.bounds
                                                  byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                        cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *oneDayLayer = [CAShapeLayer layer];
    oneDayLayer.frame = oneDayActiveButton.bounds;
    oneDayLayer.path = onePath.CGPath;
    oneDayLayer.lineWidth = 1.0f;
    oneDayLayer.fillColor = [UIColor clearColor].CGColor;
    oneDayLayer.strokeColor = [UIColor whiteColor].CGColor;
    [oneDayActiveButton.layer addSublayer:oneDayLayer];

    fiveDayActiveButton.backgroundColor = [UIColor clearColor];
    UIBezierPath *fiveDayPath =[UIBezierPath bezierPathWithRoundedRect:fiveDayActiveButton.bounds
                                                     byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                           cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CAShapeLayer *fiveDayLayer = [CAShapeLayer layer];
    fiveDayLayer.frame = fiveDayActiveButton.bounds;
    fiveDayLayer.path = fiveDayPath.CGPath;
    fiveDayLayer.lineWidth = 1.0f;
    fiveDayLayer.fillColor = [UIColor clearColor].CGColor;
    fiveDayLayer.strokeColor = [UIColor whiteColor].CGColor;
    [fiveDayActiveButton.layer addSublayer:fiveDayLayer];

    rxListDisabledButton.backgroundColor = [UIColor clearColor];
    UIBezierPath *rxPath = [UIBezierPath bezierPathWithRoundedRect:rxListDisabledButton.bounds
                                                 byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                       cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *rxLayer = [CAShapeLayer layer];
    rxLayer.frame = rxListDisabledButton.bounds;
    rxLayer.path = rxPath.CGPath;
    rxLayer.fillColor = [UIColor whiteColor].CGColor;
    rxLayer.strokeColor = [UIColor whiteColor].CGColor;
    rxLayer.lineWidth = 1.0f;
    [rxListDisabledButton.layer addSublayer:rxLayer];
    [rxListDisabledButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    searchButton.backgroundColor = [UIColor whiteColor];
    [[searchButton layer] setBorderWidth:1.0f];
    [[searchButton layer] setBorderColor:[UIColor blueColor].CGColor];

}

- (void) roundTheCorners {
    drugstoresTableView.layer.cornerRadius = 20.0f;
    openSearchButton.layer.cornerRadius = 20.0f;
    segmentedControl.layer.cornerRadius = 20.0f;
    openSearchButton.layer.borderColor = [UIColor whiteColor].CGColor;
    openSearchButton.layer.borderWidth = 1.0f;
    openSearchButton.backgroundColor = [UIColor lightTextColor];


}
- (void)fetchSearchResultsForDoctors {
    doctors = [[NSMutableArray alloc] init];
    city = [city stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    state = [state stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=allergy+doctors+in+%@+%@&sensor=true&key=AIzaSyCo6eD4I4gCm3oDl19-YyRJfi1NLxmMzRc", city, state]]]
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
                                   [doctors addObject:tempRx];
                                   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               }
                               [drugstoresTableView reloadData];
                           }];
    if (searchResults.count == 0) { // use different Google API Key
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=allergy+doctors+in+%@+%@&sensor=true&key=AIzaSyCnEjkf4LfOZAo8wMcyAsbFyuAvuPF0CVE", city, state]]]
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
                                       [doctors addObject:tempRx];
                                       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                   }
                                   [drugstoresTableView reloadData];
                               }];

    }
}

- (void)fetchSearchResults {
    drugstores = [[NSMutableArray alloc] init];
    city = [city stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    state = [state stringByReplacingOccurrencesOfString:@" " withString:@"+"];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=pharmacies+in+%@+%@&sensor=true&key=AIzaSyCo6eD4I4gCm3oDl19-YyRJfi1NLxmMzRc", city, state]]]
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
    if (searchResults.count == 0) { // use different Google API Key
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=pharmacies+in+%@+%@&sensor=true&key=AIzaSyCnEjkf4LfOZAo8wMcyAsbFyuAvuPF0CVE", city, state]]]
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
}

- (void)rotateDandy:(UIImageView *)image
           duration:(NSTimeInterval)duration
            degrees:(CGFloat)degrees {
    [dandyImagePng.layer setAnchorPoint:CGPointMake(0.0, 1.0)];

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
    [dandyImagePng.layer addAnimation:dandyAnimation forKey:@"position"];
}

- (void)viewDidAppear:(BOOL)animated {
    [openSearchButton becomeFirstResponder];
    [self roundTheCorners];
    segmentedControl.selectedSegmentIndex = 0;
    pageControl.numberOfPages = locations.count;
    pageControl.currentPage = currentLocationIndex;
    citynStateLabel.text = [NSString stringWithFormat:@"%@, %@", [location objectForKey:@"city"], [location objectForKey:@"state"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    searchButton.hidden = YES;
    zipCodeTextField.hidden = YES;
    [self buttonBorders];
    [self showBackgroundImages];
    [self rotateDandy:dandyImagePng duration:1 degrees:2];
    [self fetchSearchResults];
    [self fetchSearchResultsForDoctors];
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
    grassPNG.image = [UIImage imageNamed:@"grass.png"];
    grassPNG.alpha = .60;
    [dandyImagePng setAlpha:.5];
    [drugstoresTableView setAlpha:.75];

    dirtBottomPNG.image = [UIImage imageNamed:@"dirtMcGurt.png"];
    dirtBottomPNG.alpha = 0.65f;
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
    Drugstore *tempDrugstore;
    if (segmentedControl.selectedSegmentIndex == 0)
        tempDrugstore = drugstores[indexPath.row];
    else
        tempDrugstore = doctors[indexPath.row];
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
    Drugstore *tempDrugstore;
    if (segmentedControl.selectedSegmentIndex == 0) {
        tempDrugstore = drugstores[indexPath.row];
    }
    else {
        tempDrugstore = doctors[indexPath.row];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = tempDrugstore.name;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    cell.detailTextLabel.numberOfLines = 2;
    NSString *tempAddress1 = [[tempDrugstore.address componentsSeparatedByString:@", "] firstObject];
    NSString *tempCity = [[tempDrugstore.address componentsSeparatedByString:@", "] objectAtIndex:1];
    NSString *tempState = [[tempDrugstore.address componentsSeparatedByString:@", "] objectAtIndex:2];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@, %@", tempAddress1, tempCity, tempState];
    return cell;
}

- (IBAction)onTapGoGoOpenSearch:(id)sender {
    searchButton.hidden = NO;
    zipCodeTextField.hidden = NO;
    openSearchButton.hidden = YES;
    zipCodeTextField.frame = CGRectMake(self.view.frame.origin.x / 2, self.view.frame.origin.y + 750, self.view.frame.size.width - 20, zipCodeTextField.frame.size.height);
    searchButton.frame = CGRectMake(openSearchButton.frame.origin.x + 200, openSearchButton.frame.origin.y + 400, openSearchButton.frame.size.width, openSearchButton.frame.size.height);
    [zipCodeTextField becomeFirstResponder];
    [UIView animateWithDuration:0.25f animations:^{
        zipCodeTextField.frame = CGRectMake( 0, 324, self.view.frame.size.width - 34, zipCodeTextField.frame.size.height);
        searchButton.frame = CGRectMake(280 , 324, openSearchButton.frame.size.width, searchButton.frame.size.height);
    }];
}

- (IBAction)onSegmentedControlTap:(id)sender {
    [drugstoresTableView reloadData];
}

- (IBAction)onSearchButtonTap:(id)sender {
    [zipCodeTextField resignFirstResponder];
    zipCodeTextField.hidden = YES;
    searchButton.hidden = YES;
    openSearchButton.hidden = NO;
    if (![zipCodeTextField.text isEqualToString:@""]) {
        city = zipCodeTextField.text;
        state = @"";
        [self fetchSearchResults];
        [self fetchSearchResultsForDoctors];
        zipCodeTextField.text = @"";
    }
}

- (IBAction)onTapGoGoRootVC:(id)sender {
    NSMutableDictionary *tempLocations = [[NSMutableDictionary alloc] init];;
    [tempLocations setObject:locations forKey:@"locations"];
    [tempLocations setObject:[NSString stringWithFormat:@"%i", currentLocationIndex] forKey:@"index"];    [[NSNotificationCenter defaultCenter] postNotificationName:@"Go To RootVC" object:tempLocations];
}

- (IBAction)onTapGoGoFiveDayForecastVC:(id)sender {
    NSMutableDictionary *tempLocations = [[NSMutableDictionary alloc] init];;
    [tempLocations setObject:locations forKey:@"locations"];
    [tempLocations setObject:[NSString stringWithFormat:@"%i", currentLocationIndex] forKey:@"index"];    [[NSNotificationCenter defaultCenter] postNotificationName:@"Go To WeeklyForecastVC" object:tempLocations];
}

- (IBAction)goGoPageControlSwipe:(id)sender {
}

@end
