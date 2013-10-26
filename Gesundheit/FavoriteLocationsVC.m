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
    [self startUsingPlist];
}

- (void) startUsingPlist {
    // Get the URL for the document directory
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *documentDirectoryURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0];

    // Turn the filename into a string safe for use in a URL
    NSString *safeString = [@"scores.plist" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    // Create an array for the score
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[NSString stringWithFormat:@"%@", zip]];

    NSLog(@"the array = %@", array);

    // Write this array to a URL
    NSURL *arrayURL = [NSURL URLWithString:safeString relativeToURL:documentDirectoryURL];
    [array writeToURL:arrayURL atomically:YES];
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

    return cell;
}

- (int)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (IBAction)onTouchSaveZipToTable:(id)sender {

}

@end