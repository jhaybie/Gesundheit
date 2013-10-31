//
//  TAFavoriteZipCodeViewController.m
//  Gesundheit
//
//  Created by Daniel Bostjancic on 10/26/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "FavoriteLocationsVC.h"
#import <QuartzCore/QuartzCore.h>


@interface FavoriteLocationsVC ()
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *cityAndStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *closestStationLabel;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UITableView *zipTableView;
- (IBAction)onAddButtonPress:(id)sender;
- (IBAction)onBackButtonTap:(id)sender;
- (IBAction)onSearchButtonTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundSkyIMG;
@property (weak, nonatomic) IBOutlet UIImageView *dandyBackgroundIMG;

@end


@implementation FavoriteLocationsVC
@synthesize addButton,
            backgroundSkyIMG,
            dandyBackgroundIMG,
            backButton,
            searchButton,
            cityAndStateLabel,
            closestStationLabel,
            zipTableView,
            zipTextField;


BOOL                isCheckingZip,
                    doesExist;
NSMutableDictionary *location;
NSURL               *documentDirectoryURL;
NSFileManager       *fileManager;
NSMutableArray      *locations;
NSString            *generatedZip,
                    *searchedCity,
                    *searchedState,
                    *searchedZip,
                    *safeString;

- (void) buttonBorders {
    [[backButton layer] setCornerRadius:15.0f];
    [[backButton layer] setBorderColor:[UIColor blueColor].CGColor];
    [[backButton layer] setBorderWidth:1.0f];

    [[searchButton layer] setCornerRadius:15.0f];
    [[searchButton layer] setBorderColor:[UIColor blueColor].CGColor];
    [[searchButton layer] setBorderWidth:1.0f];

    [[addButton layer] setCornerRadius:15.0f];
    [[addButton layer] setBorderColor:[UIColor blueColor].CGColor];
    [[addButton layer] setBorderWidth:1.0f];

}

- (void) showBackgroundImage {
    backgroundSkyIMG.image = [UIImage imageNamed:@"skyBackRound2"];
    dandyBackgroundIMG.image = [UIImage imageNamed:@"testDandyDan"];
    [dandyBackgroundIMG setAlpha:.50f];
    [zipTableView setAlpha:.75];

}
- (void)showResults {
    if (isCheckingZip) {
        for (int i = 0; i < locations.count; i++) {
            NSDictionary *tempLocation = locations[i];
            NSString *tempCity = [tempLocation objectForKey:@"city"];
            NSString *tempState = [tempLocation objectForKey:@"state"];
            if ([searchedCity isEqualToString:tempCity] && [searchedState isEqualToString:tempState]) {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@, %@", tempCity, tempState]
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
            cityAndStateLabel.text = [NSString stringWithFormat:@"%@, %@", [location objectForKey:@"city"], [location objectForKey:@"state"]];
            closestStationLabel.hidden = NO;
        }
    }
}

- (void)fetchPollenDataFromZip:(NSString *)zipCode {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://direct.weatherbug.com/DataService/GetPollen.ashx?zip=%@", zipCode]]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               location = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&connectionError];
                               searchedCity = [location objectForKey:@"city"];
                               searchedState = [location objectForKey:@"state"];

                               NSMutableArray *dayList = [[location objectForKey:@"dayList"] mutableCopy];
                               for (int i = 2; i < 5; i++) {
                                   NSMutableDictionary *tempForecast = [dayList[i] mutableCopy];
                                   [tempForecast setObject:@"" forKey:@"desc"];
                                   dayList[i] = tempForecast;
                               }
                               [location setObject:dayList forKey:@"dayList"];
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               if (!isCheckingZip)
                                   [self showWeeklyForecast];
                               else [self showResults];
                           }];
}

- (void)showWeeklyForecast {
    WeeklyForecastVC *wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WeeklyForecastVC"];
    wvc.location = location;
    [self presentViewController:wvc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buttonBorders];
    [self showBackgroundImage];
    [self loadPList];
}

- (id)path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return [documentsDirectory stringByAppendingPathComponent:@"Gesundheit.plist"];
}

- (void)loadPList {
    locations = [[[NSUserDefaults standardUserDefaults] objectForKey:@"locations"] ?: @[] mutableCopy];
}

- (void)savePList {
    [[NSUserDefaults standardUserDefaults] setObject:locations forKey:@"locations"];
}

- (void)getZipCodeFromCity:(NSString *)city andState:(NSString *)state {
    city = [city stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://zipcodedistanceapi.redline13.com/rest/2YD0hiPGAPhlUJGmuC8E2w8XyELhTlyWkbWCuLi4Bzqvj6SNJ0sLxAJ5fvm9RV5b/city-zips.json/%@/%@", city, state]]]
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   NSDictionary *initialDump = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:NSJSONReadingMutableContainers
                                                                                                 error:&connectionError];
                                   NSArray *zipCodes = [initialDump objectForKey:@"zip_codes"];
                                   generatedZip = [zipCodes firstObject];
                                   isCheckingZip = NO;
                                   [self fetchPollenDataFromZip:[zipCodes firstObject]];
                               }];
}

- (void)viewWillAppear:(BOOL)animated {
    addButton.hidden = YES;
    cityAndStateLabel.hidden = YES;
    closestStationLabel.hidden = YES;
    doesExist = NO;
    isCheckingZip = NO;
    searchedCity = [[NSString alloc] init];
    searchedState = [[NSString alloc] init];
    searchedZip = [[NSString alloc] init];
    [zipTableView reloadData];
}

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tempLocation = locations[indexPath.row];
    [self getZipCodeFromCity:[tempLocation objectForKey:@"city"] andState:[tempLocation objectForKey:@"state"]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xxx"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"xxx"];
    }
    NSDictionary *tempLocation = locations[indexPath.row];
    cell.textLabel.text = [tempLocation objectForKey:@"city"];
    cell.detailTextLabel.text = [tempLocation objectForKey:@"state"];
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView
          editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (int)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section  {
    return [locations count];
}

- (IBAction)onSearchButtonTap:(id)sender {
    [self.view endEditing:YES];
    isCheckingZip = YES;
    if (zipTextField.text.length == 5) {
        searchedZip = zipTextField.text;
        zipTextField.text = @"";
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self fetchPollenDataFromZip:searchedZip];
    }
}

- (IBAction)onAddButtonPress:(id)sender {
    addButton.hidden = YES;
    cityAndStateLabel.hidden = YES;
    closestStationLabel.hidden = YES;
    searchedCity = [location objectForKey:@"city"];
    searchedState = [location objectForKey:@"state"];
    [locations addObject:location];
    [self savePList];
    [zipTableView reloadData];
}

- (IBAction)onBackButtonTap:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end