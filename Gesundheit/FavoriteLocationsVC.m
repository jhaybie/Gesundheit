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
- (IBAction)onBackButtonTap:(id)sender;
- (IBAction)onSearchButtonTap:(id)sender;

@end


@implementation FavoriteLocationsVC
@synthesize city,
            delegate,
            state,
            zip,
            zipTableView,
            zipTextField;

NSMutableArray *favoriteLocations;


- (void)viewDidLoad {
    [super viewDidLoad];

    // initializes array with dummy data for testing purposes only
    favoriteLocations = [[NSMutableArray alloc] init];
    favoriteLocations[0] = @"Skokie, IL 60076";
    favoriteLocations[1] = @"New York, NY 10001";
    favoriteLocations[2] = @"Bridgeport, CT 06601";
    favoriteLocations[3] = @"Austin, TX 78759";
    favoriteLocations[4] = @"Redmond, WA 98052";
}

- (void)startUsingPlist {
    // Get the URL for the document directory
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *documentDirectoryURL = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                       inDomains:NSUserDomainMask] firstObject];

    // Turn the filename into a string safe for use in a URL
    NSString *safeString = [@"favorites.plist" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    // Create an array for the score
    //favoriteLocations = [[NSMutableArray alloc] init];
    //[favoriteLocations addObject:[NSString stringWithFormat:@"%@, %@ %@",city, state, zip]];

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xxx"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"xxx"];
    }
    city = [[favoriteLocations[indexPath.row] componentsSeparatedByString:@"," ] firstObject];
    state = [[favoriteLocations[indexPath.row] componentsSeparatedByString:@"," ] lastObject];
    cell.textLabel.text = city;
    cell.detailTextLabel.text = state;
    return cell;
}

- (int)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section  {
    return [favoriteLocations count];
}

- (IBAction)onSearchButtonTap:(id)sender {

    //replace with code using notifications
    [delegate fetchPollenDataFromZip:zipTextField.text];
}

- (IBAction)onBackButtonTap:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end