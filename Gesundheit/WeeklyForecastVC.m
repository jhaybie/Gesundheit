//
//  TAWeeklyForecastViewController.m
//  Gesundheit
//
//  Created by Jhaybie on 10/25/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "WeeklyForecastVC.h"
#import "UIImage+animatedGIF.h"

@interface WeeklyForecastVC ()
@property (weak, nonatomic) IBOutlet UILabel *cityAndStateLabel;
@property (weak, nonatomic) IBOutlet UITextView *descTextview;
@property (weak, nonatomic) IBOutlet UITableView *weeklyForecastTableView;
- (IBAction)onCloseButtonTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *gifBackRoundImage;

@end

@implementation WeeklyForecastVC
@synthesize gifBackRoundImage,
            descTextview,
            weeklyForecastTableView,
            city,
            cityAndStateLabel,
            state,
            weekDayValue,
            weeklyForecast;


NSArray *week;
UIColor *darkGreenColor,
        *greenColor,
        *yellowColor,
        *orangeColor,
        *redColor;


- (void)viewDidAppear:(BOOL)animated {
    cityAndStateLabel.text = [NSString stringWithFormat:@"%@, %@", city, state];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    week = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
    [self changeAllergenLevelColors];
    weeklyForecastTableView.alpha = .85;
    descTextview.alpha = .85;
    [self showGifImage];
}

- (void) changeAllergenLevelColors {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <= 1)
        descTextview.text = [weeklyForecast[indexPath.row] objectForKey:@"desc"];
    else descTextview.text = @"";
}

- (void)showGifImage {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dandydan"
                                         withExtension:@"gif"];
   gifBackRoundImage.image = [UIImage animatedImageWithAnimatedGIFData:[NSData
                                                                         dataWithContentsOfURL:url]];
    gifBackRoundImage.image = [UIImage animatedImageWithAnimatedGIFURL:url];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"xxx"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                      reuseIdentifier: @"xxx"];
    }
    cell.textLabel.text = week[weekDayValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [weeklyForecast[indexPath.row] objectForKey:@"level"]];
    UIColor *textColor;
    float level = cell.detailTextLabel.text.floatValue;
    if (level >= 0 && level < 2.5)
        textColor = darkGreenColor;
    else if (level >= 2.5 && level < 4.9)
        textColor = greenColor;
    else if (level >= 4.9 && level < 7.3)
        textColor = yellowColor;
    else if (level >= 7.3 && level < 9.6)
        textColor = orangeColor;
    else
        textColor = redColor;
    cell.detailTextLabel.textColor = textColor;
    if (weekDayValue == 6)
        weekDayValue = 0;
    else weekDayValue++;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (IBAction)onCloseButtonTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
