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


@implementation FavoriteLocationsVC {
    NSMutableArray *favoriteLocations;
}
@synthesize city,
            state,
            zip,
            zipTableView,
            zipTextField;


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void) startUsingPlist {
    // Get the URL for the document directory
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *documentDirectoryURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0];

    // Turn the filename into a string safe for use in a URL
    NSString *safeString = [@"favorites.plist" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    // Create an array for the score
    favoriteLocations = [[NSMutableArray alloc] init];
    [favoriteLocations addObject:[NSString stringWithFormat:@"%@ %@ %@",city, state, zip]];

    NSLog(@"the array = %@", favoriteLocations);
    NSLog(@"zip = %@", zip);

    // Write this array to a URL
    NSURL *arrayURL = [NSURL URLWithString:safeString relativeToURL:documentDirectoryURL];
    [favoriteLocations writeToURL:arrayURL atomically:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self startUsingPlist];
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
numberOfRowsInSection:(NSInteger)section  {
    return [favoriteLocations count] ;
}

- (IBAction)onTouchSaveZipToTable:(id)sender {

}

@end