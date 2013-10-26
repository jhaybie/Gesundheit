//
//  TAWeeklyForecastViewController.m
//  Gesundheit
//
//  Created by Jhaybie on 10/25/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "TAWeeklyForecastViewController.h"

@interface TAWeeklyForecastViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cityAndStateLabel;
@property (weak, nonatomic) IBOutlet UITextView *descTextview;

@end

@implementation TAWeeklyForecastViewController
@synthesize city,
            cityAndStateLabel,
            descTextview,
            state,
            level;


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onViewTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"xxx"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                      reuseIdentifier: @"xxx"];
    }

    cell.textLabel.text = @"Monday";
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f", level];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

@end
