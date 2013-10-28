//
//  TAFavoriteZipCodeViewController.m
//  Gesundheit
//
//  Created by Daniel Bostjancic on 10/26/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "FavoriteLocationsVC.h"


@interface FavoriteLocationsVC ()

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *cityAndStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *closestStationLabel;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UITableView *zipTableView;
- (IBAction)onAddButtonPress:(id)sender;
- (IBAction)onBackButtonTap:(id)sender;
- (IBAction)onSearchButtonTap:(id)sender;

@end


@implementation FavoriteLocationsVC
@synthesize addButton,
            city,
            cityAndStateLabel,
            closestStationLabel,
            state,
            zip,
            zipTableView,
            zipTextField;

BOOL doesExist;
NSMutableArray *favoriteLocations;


- (void)showResults {
    for (int i = 0; i < favoriteLocations.count; i++) {
        NSString *tempCity = [[favoriteLocations[i] componentsSeparatedByString:@", "] firstObject];
        NSString *tempState = [[favoriteLocations[i] componentsSeparatedByString:@", "] lastObject];
        if ([city isEqualToString:tempCity] && [state isEqualToString:tempState]) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:favoriteLocations[i]
                                                              message:@"Location already saved in Favorites"
                                                             delegate:self
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles:nil];
            [message show];
            doesExist = YES;
            break;
        }
    }
    if (!doesExist) {
        addButton.hidden = NO;
        cityAndStateLabel.hidden = NO;
        cityAndStateLabel.text = [NSString stringWithFormat:@"%@, %@", city, state];
        closestStationLabel.hidden = NO;
    }
}

- (void)fetchPollenDataFromZip:(NSString *)zipCode {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://direct.weatherbug.com/DataService/GetPollen.ashx?zip=%@", zip]]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary *initialDump = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:0
                                                                                             error:&connectionError];
                               city = [initialDump objectForKey:@"city"];
                               state = [initialDump objectForKey:@"state"];
                               [self showResults];
                           }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // initializes array with dummy data for testing purposes only
    favoriteLocations = [[NSMutableArray alloc] init];
    favoriteLocations[0] = @"Newark, NJ";
    favoriteLocations[1] = @"New York, NY";
    favoriteLocations[2] = @"Bridgeport, CT";
    favoriteLocations[3] = @"Austin, TX";
    favoriteLocations[4] = @"Redmond, WA";
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
    [favoriteLocations addObject:[NSString stringWithFormat:@"%@, %@",city, state]];

    NSLog(@"the array = %@", favoriteLocations);
    NSLog(@"zip = %@", zip);

    // Write this array to a URL
    NSURL *arrayURL = [NSURL URLWithString:safeString
                             relativeToURL:documentDirectoryURL];
    [favoriteLocations writeToURL:arrayURL
                       atomically:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    addButton.hidden = YES;
    cityAndStateLabel.hidden = YES;
    closestStationLabel.hidden = YES;
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
    [self.view endEditing:YES];
    if (![zipTextField.text isEqualToString:@""]) {
        zip = zipTextField.text;
        zipTextField.text = @"";
        [self fetchPollenDataFromZip:zip];
    }
}

- (IBAction)onAddButtonPress:(id)sender {
    addButton.hidden = YES;
    cityAndStateLabel.hidden = YES;
    closestStationLabel.hidden = YES;
    [favoriteLocations addObject:cityAndStateLabel.text];
    [zipTableView reloadData];
}

- (IBAction)onBackButtonTap:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end