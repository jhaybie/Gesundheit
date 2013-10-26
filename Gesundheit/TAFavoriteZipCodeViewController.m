//
//  TAFavoriteZipCodeViewController.m
//  Gesundheit
//
//  Created by Daniel Bostjancic on 10/26/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "TAFavoriteZipCodeViewController.h"

@interface TAFavoriteZipCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UITableView *zipTableView;
- (IBAction)onTouchSaveZipToTable:(id)sender;
@end

@implementation TAFavoriteZipCodeViewController
@synthesize city, state, zip, zipTextField, zipTableView;


- (void)viewDidLoad
{
    [super viewDidLoad];


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myID"];

    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"myID"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"hello"];

    return cell;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTouchSaveZipToTable:(id)sender {

}
@end
