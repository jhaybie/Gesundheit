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


NSMutableArray *favoriteLocations;

@implementation FavoriteLocationsVC
@synthesize addButton,
            cityAndStateLabel,
            closestStationLabel,
            zipTableView,
            zipTextField;


BOOL           isCheckingZip,
               doesExist;
NSDictionary   *location;
NSURL          *documentDirectoryURL;
NSFileManager  *fileManager;
NSMutableArray *locations;
NSString       *searchedCity,
               *searchedState,
               *searchedZip,
               *safeString;


- (void)showResults {
    if (!isCheckingZip) {
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
                                                                          options:0
                                                                            error:&connectionError];
//                               NSArray *arrayDump = [initialDump objectForKey:@"dayList"];
//                               searchedCity = [initialDump objectForKey:@"city"];
//                               searchedState = [initialDump objectForKey:@"state"];
//                               NSString *predominantType = [initialDump objectForKey:@"predominantType"];
//                               weeklyForecast = [[NSMutableArray alloc] init];
//                               for (int i = 0; i < arrayDump.count; i++) {
//                                   Forecast *tempForecast = [[Forecast alloc] init];
//                                   tempForecast.city = searchedCity;
//                                   tempForecast.state = searchedState;
//                                   tempForecast.zip = zipCode;
//                                   tempForecast.desc = [arrayDump[i] objectForKey:@"desc"];
//                                   tempForecast.level = [[arrayDump[i] objectForKey:@"level"] floatValue];
//                                   tempForecast.predominantType = predominantType;
//                                   [weeklyForecast addObject:tempForecast];
//                               }
                               if (isCheckingZip)
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
    doesExist = NO;
    isCheckingZip = NO;
    favoriteLocations = [[NSMutableArray alloc] init];
    [self loadPList];
}

- (void)loadPList {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Gesundheit.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: path]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Gesundheit" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    NSMutableDictionary *initialDump = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    if ([initialDump objectForKey:@"hasLocations"]) {
        favoriteLocations = [initialDump objectForKey:@"locations"];
    }
}

- (void)savePList {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Gesundheit.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    [data setObject:locations forKey:@"locations"];
    [data writeToFile: path atomically:YES];
}

//- (void)loadPList {
//    favoriteLocations = [[NSMutableArray alloc] init];
//    // Get the URL for the document directory
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLocations"]) {
//        fileManager = [[NSFileManager alloc] init];
//        documentDirectoryURL = [[fileManager URLsForDirectory:NSDocumentDirectory
//                                                    inDomains:NSUserDomainMask] firstObject];
//        safeString = [@"favorites.plist" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        favoriteLocations = [NSArray arrayWithContentsOfURL:[documentDirectoryURL URLByAppendingPathComponent:@"favorites.plist"]];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Has Data"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
////    } else {
////    }
//}

//- (void)savePList{
//    NSURL *arrayURL = [NSURL URLWithString:safeString
//                             relativeToURL:documentDirectoryURL];
//    [favoriteLocations writeToURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@favorites.plist", arrayURL]]
//                       atomically:YES];
//}

- (void)viewWillAppear:(BOOL)animated {
    addButton.hidden = YES;
    cityAndStateLabel.hidden = YES;
    closestStationLabel.hidden = YES;
    searchedCity = [[NSString alloc] init];
    searchedState = [[NSString alloc] init];
    searchedZip = [[NSString alloc] init];
    [zipTableView reloadData];
}

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tempLocation = locations[indexPath.row];
    isCheckingZip = YES;
    [self fetchPollenDataFromZip:[tempLocation objectForKey:@"zip"]];
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
    isCheckingZip = NO;
    if (zipTextField.text.length == 5) {
        searchedZip = zipTextField.text;
        zipTextField.text = @"";
        [self fetchPollenDataFromZip:searchedZip];
    }
}

- (IBAction)onAddButtonPress:(id)sender {
//    location = [[NSDictionary alloc] init];
//    tempLocation.city = searchedCity;
//    tempLocation.state = searchedState;
//    tempLocation.zip = searchedZip;
//    [favoriteLocations addObject:tempLocation];
    addButton.hidden = YES;
    cityAndStateLabel.hidden = YES;
    closestStationLabel.hidden = YES;
    searchedCity = @"";
    searchedState = @"";
    [locations addObject:location];
    [self savePList];
    [zipTableView reloadData];
}

- (IBAction)onBackButtonTap:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end