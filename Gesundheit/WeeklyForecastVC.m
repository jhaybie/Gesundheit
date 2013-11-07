//
//  TAWeeklyForecastViewController.m
//  Gesundheit
//
//  Created by Jhaybie on 10/25/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "WeeklyForecastVC.h"
#import "RxListVC.h"
#import "RootVC.h"
#import "UIColor+ColorCategory.h"

#import <QuartzCore/QuartzCore.h>

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)


@interface WeeklyForecastVC ()
@property (weak, nonatomic) IBOutlet UILabel *cityAndStateLabel;
@property (weak, nonatomic) IBOutlet UITextView *descTextview;
@property (weak, nonatomic) IBOutlet UITableView *weeklyForecastTableView;
@property (weak, nonatomic) IBOutlet UIButton *oneDayTabButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveDayTabButton;
@property (weak, nonatomic) IBOutlet UIButton *rxListTabButton;
@property (weak, nonatomic) IBOutlet UIPageControl *fiveDayPageControl;
@property (weak, nonatomic) IBOutlet UIImageView *grassPng;
@property (weak, nonatomic) IBOutlet UIImageView *gifBackRoundImage;
@property (weak, nonatomic) IBOutlet UIImageView *dandyPng;
- (IBAction)onTapGoGoRxListVC:(id)sender;
- (IBAction)onTapGoGoRootVC:(id)sender;
- (IBAction)onSwipeChangePageSelected:(id)sender;


@end


@implementation WeeklyForecastVC
@synthesize gifBackRoundImage,
            grassPng,
            oneDayTabButton,
            rxListTabButton,
            fiveDayTabButton,
            fiveDayPageControl,
            currentLocationIndex,
            dandyPng,
            descTextview,
            location,
            locations,
            weeklyForecastTableView,
            cityAndStateLabel;


int     weekDayValue;
NSArray *week;


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
    fiveDayPageControl.currentPage = currentLocationIndex;
    cityAndStateLabel.text = [NSString stringWithFormat:@"%@, %@", [location objectForKey:@"city"], [location objectForKey:@"state"]];
    [weeklyForecastTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    cityAndStateLabel.text = [NSString stringWithFormat:@"%@, %@", [location objectForKey:@"city"], [location objectForKey:@"state"]];
    descTextview.hidden = YES;
    fiveDayPageControl.numberOfPages = locations.count;
    fiveDayPageControl.currentPage = currentLocationIndex;
    [self roundedStuffs];
    [self getCurrentDate];
}

- (void) buttonBorder {
    oneDayTabButton.backgroundColor = [UIColor clearColor];
    UIBezierPath *oneDayPath = [UIBezierPath bezierPathWithRoundedRect:oneDayTabButton.bounds
                                                     byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                           cornerRadii:CGSizeMake(10.0,10.0)];
    CAShapeLayer *oneDayLayer = [CAShapeLayer layer];
    oneDayLayer.frame = oneDayTabButton.bounds;
    oneDayLayer.path = oneDayPath.CGPath;
    oneDayLayer.fillColor = [UIColor clearColor].CGColor;
    oneDayLayer.strokeColor = [UIColor whiteColor].CGColor;
    oneDayLayer.lineWidth = 1;
    [oneDayTabButton.layer addSublayer:oneDayLayer];



    rxListTabButton.backgroundColor = [UIColor clearColor];
    UIBezierPath *rxListPath = [UIBezierPath bezierPathWithRoundedRect:rxListTabButton.bounds
                                                     byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                           cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *rxListLayer = [CAShapeLayer layer];
    rxListLayer.frame = rxListTabButton.bounds;
    rxListLayer.path = rxListPath.CGPath;
    rxListLayer.fillColor = [UIColor clearColor].CGColor;
    rxListLayer.strokeColor = [UIColor whiteColor].CGColor;
    rxListLayer.lineWidth = 1;
    [rxListTabButton.layer addSublayer:rxListLayer];

    fiveDayTabButton.backgroundColor = [UIColor clearColor];
    [fiveDayTabButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    UIBezierPath *shapePath = [UIBezierPath bezierPathWithRoundedRect:fiveDayTabButton.bounds
                                                    byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                          cornerRadii:CGSizeMake(10.0,10.0)];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = fiveDayTabButton.bounds;
    shapeLayer.path = shapePath.CGPath;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineWidth = 1;
    [fiveDayTabButton.layer addSublayer:shapeLayer];
    [fiveDayTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    week = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
    weeklyForecastTableView.alpha = .75;
    [descTextview setAlpha:.50];
    [self showGifImage];
    [self rotateDandy:dandyPng duration:1 degrees:2];
    [self buttonBorder];
    [self setUpBackgroundImages];
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftDetected:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *swipeRecognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftDetected:)];
    swipeRecognizer2.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRecognizer];
    [self.view addGestureRecognizer:swipeRecognizer2];
}

- (void)showGifImage {
    gifBackRoundImage.image = [UIImage imageNamed:@"skyBackRound2.png"];
    dandyPng.image = [UIImage imageNamed:@"testDandyDan.png"];
    dandyPng.alpha = .50;
    grassPng.image = [UIImage imageNamed:@"grass.png"];
    grassPng.alpha = .60;
}

- (void)setUpBackgroundImages {
    [UIView animateWithDuration:0.1f animations:^{
    grassPng.frame = CGRectMake(grassPng.frame.origin.x, grassPng.frame.origin.y + 500, grassPng.frame.size.width, grassPng.frame.size.width);

    }];
}

- (void)getCurrentDate {
    NSDate *today = [NSDate date];
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"EEEE"];
    NSString *day = [myFormatter stringFromDate:today];
    if ([day isEqualToString:@"Sunday"])
        weekDayValue = 0;
    else if ([day isEqualToString:@"Monday"])
        weekDayValue = 1;
    else if ([day isEqualToString:@"Tuesday"])
        weekDayValue = 2;
    else if ([day isEqualToString:@"Wednesday"])
        weekDayValue = 3;
    else if ([day isEqualToString:@"Thursday"])
        weekDayValue = 4;
    else if ([day isEqualToString:@"Friday"])
        weekDayValue = 5;
    else if ([day isEqualToString:@"Saturday"])
        weekDayValue = 6;
}

- (void)rotateDandy:(UIImageView *)image
           duration:(NSTimeInterval)duration
            degrees:(CGFloat)degrees {
    [dandyPng.layer setAnchorPoint:CGPointMake(0.0, 1.0)];

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
    [dandyPng.layer addAnimation:dandyAnimation forKey:@"position"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <= 1) {
        descTextview.hidden = NO;
        descTextview.text = [[[location objectForKey:@"dayList"] objectAtIndex:indexPath.row] objectForKey:@"desc"];
    } else {
        descTextview.text = @"";
        descTextview.hidden = YES;
    }
}

- (void)roundedStuffs {
    weeklyForecastTableView.layer.cornerRadius = 20.0f;
    descTextview.layer.cornerRadius = 20.0f;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RxListVC *rvc = segue.destinationViewController;
    rvc.city = [location objectForKey:@"city"];
    rvc.state = [location objectForKey:@"state"];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"xxx"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                      reuseIdentifier: @"xxx"];
    }
    cell.textLabel.text = week[weekDayValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[[location objectForKey:@"dayList"] objectAtIndex:indexPath.row] objectForKey:@"level"]];
    UIColor *textColor;
    float level = cell.detailTextLabel.text.floatValue;
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
    cell.detailTextLabel.textColor = textColor;
    if (weekDayValue == 6)
        weekDayValue = 0;
    else weekDayValue++;
    return cell;
}

- (IBAction)onTapGoGoRxListVC:(id)sender {
    NSMutableDictionary *tempLocations = [[NSMutableDictionary alloc] init];;
    [tempLocations setObject:locations forKey:@"locations"];
    [tempLocations setObject:[NSString stringWithFormat:@"%i", currentLocationIndex] forKey:@"index"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Go To RXListVC" object:tempLocations];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)onTapGoGoRootVC:(id)sender {
    NSMutableDictionary *tempLocations = [[NSMutableDictionary alloc] init];;
    [tempLocations setObject:locations forKey:@"locations"];
    [tempLocations setObject:[NSString stringWithFormat:@"%i", currentLocationIndex] forKey:@"index"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Go To RootVC" object:tempLocations];
}

- (IBAction)onSwipeChangePageSelected:(id)sender {
}

@end
