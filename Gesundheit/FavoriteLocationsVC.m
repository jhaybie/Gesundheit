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
            cityAndStateLabel,
            closestStationLabel,
            zipTableView,
            zipTextField;

BOOL doesExist;
NSMutableArray *favoriteLocations,
                *plistFavLocations;
NSURL *documentDirectoryURL;
NSFileManager *fileManager;
NSString *searchedCity,
         *searchedState,
         *searchedZip,
         *safeString;


- (void)showResults {
    for (int i = 0; i < favoriteLocations.count; i++) {
        NSString *tempCity = [[favoriteLocations[i] componentsSeparatedByString:@", "] firstObject];
        NSString *tempState = [[favoriteLocations[i] componentsSeparatedByString:@", "] lastObject];
        if ([searchedCity isEqualToString:tempCity] && [searchedState isEqualToString:tempState]) {
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
        cityAndStateLabel.text = [NSString stringWithFormat:@"%@, %@", searchedCity, searchedState];
        closestStationLabel.hidden = NO;
    }
}

- (void)fetchPollenDataFromZip:(NSString *)zipCode {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://direct.weatherbug.com/DataService/GetPollen.ashx?zip=%@", searchedZip]]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary *initialDump = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:0
                                                                                             error:&connectionError];
                               searchedCity = [initialDump objectForKey:@"city"];
                               searchedState = [initialDump objectForKey:@"state"];
                               [self showResults];
                           }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    favoriteLocations = [[NSMutableArray alloc] init];
    plistFavLocations = [[NSMutableArray alloc] initWithContentsOfFile:@"favorites.plist"];
    [self loadPList];
}

- (void)loadPList {
    // Get the URL for the document directory
    fileManager = [[NSFileManager alloc] init];
    documentDirectoryURL = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                inDomains:NSUserDomainMask] firstObject];

    // Turn the filename into a string safe for use in a URL
    safeString = [@"favorites.plist" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    // Create an array for the score
    [favoriteLocations addObject:[NSString stringWithFormat:@"%@, %@", searchedCity, searchedState]];

//    NSLog(@"the array = %@", favoriteLocations);
//    NSLog(@"zip = %@", zip);

    // Write this array to a URL

}

- (void)savePList{
    NSURL *arrayURL = [NSURL URLWithString:safeString
                             relativeToURL:documentDirectoryURL];
    [favoriteLocations writeToURL:arrayURL
                       atomically:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    addButton.hidden = YES;
    cityAndStateLabel.hidden = YES;
    closestStationLabel.hidden = YES;
    searchedCity = [[NSString alloc] init];
    searchedState = [[NSString alloc] init];
    searchedZip = [[NSString alloc] init];
    [zipTableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xxx"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"xxx"];
    }
    searchedCity = [[favoriteLocations[indexPath.row] componentsSeparatedByString:@"," ] firstObject];
    searchedState = [[favoriteLocations[indexPath.row] componentsSeparatedByString:@"," ] lastObject];
    cell.textLabel.text = searchedCity;
    cell.detailTextLabel.text = searchedState;
    return cell;
}

- (int)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section  {
    return [favoriteLocations count];
}

- (IBAction)onSearchButtonTap:(id)sender {
    [self.view endEditing:YES];
    if (![zipTextField.text isEqualToString:@""]) {
        searchedZip = zipTextField.text;
        zipTextField.text = @"";
        [self fetchPollenDataFromZip:searchedZip];
    }
}

- (IBAction)onAddButtonPress:(id)sender {
    addButton.hidden = YES;
    cityAndStateLabel.hidden = YES;
    closestStationLabel.hidden = YES;
    [favoriteLocations addObject:cityAndStateLabel.text];
    [self savePList];
    [zipTableView reloadData];
}

- (IBAction)onBackButtonTap:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end