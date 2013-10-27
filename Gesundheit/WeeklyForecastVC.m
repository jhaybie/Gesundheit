//
//  TAWeeklyForecastViewController.m
//  Gesundheit
//
//  Created by Jhaybie on 10/25/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "WeeklyForecastVC.h"

@interface WeeklyForecastVC ()
@property (weak, nonatomic) IBOutlet UILabel *cityAndStateLabel;
@property (weak, nonatomic) IBOutlet UITextView *descTextview;
@property (weak, nonatomic) IBOutlet UITableView *weeklyForecastTableView;
- (IBAction)onCloseButtonTap:(id)sender;

@end

@implementation WeeklyForecastVC
@synthesize city,
            cityAndStateLabel,
            descTextview,
            state,
            weekDayValue,
            weeklyForecast;


NSArray *week;


- (void)viewDidAppear:(BOOL)animated {
    cityAndStateLabel.text = [NSString stringWithFormat:@"%@, %@", city, state];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    week = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <= 1)
        descTextview.text = [weeklyForecast[indexPath.row] objectForKey:@"desc"];
    else descTextview.text = @"";
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
