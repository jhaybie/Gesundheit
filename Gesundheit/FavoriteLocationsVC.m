//
//  TAFavoriteZipCodeViewController.m
//  Gesundheit
//
//  Created by Daniel Bostjancic on 10/26/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "FavoriteLocationsVC.h"

@interface FavoriteLocationsVC ()

@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UITableView *zipTableView;
- (IBAction)onTouchSaveZipToTable:(id)sender;

@end


@implementation FavoriteLocationsVC
@synthesize city,
            state,
            zip,
            zipTableView,
            zipTextField;


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [zipTableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"myID"];
    }
    cell.textLabel.text = @"hello";
    return cell;
}

-      (int)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (IBAction)onTouchSaveZipToTable:(id)sender {

}

@end