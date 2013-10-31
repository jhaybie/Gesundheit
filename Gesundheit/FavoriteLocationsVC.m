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


BOOL                isCheckingZip,
                    doesExist;
NSMutableDictionary *location;
NSURL               *documentDirectoryURL;
NSFileManager       *fileManager;
NSMutableArray      *locations;
NSString            *searchedCity,
                    *searchedState,
                    *searchedZip,
                    *safeString;


//- (NSDictionary *)plistCompliantObject {
//    NSMutableDictionary *dict = @{}.mutableCopy;
//    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        if ([obj respondsToSelector:@selector(plistCompliantObject)]) {
//            dict[key] = [obj plistCompliantObject];
//        } else if (obj != [NSNull null]) {
//            dict[key] = obj;
//        }
//    }];
//    return dict;
//}
//
//- (id)plistCompliantArray {
//    NSMutableArray *array = @[].mutableCopy;
//    for (id obj in self) {
//        if ([obj respondsToSelector:@selector(plistCompliantObject)])
//            [array addObject:[obj plistCompliantObject]];
//        else if (obj != [NSNull null])
//            [array addObject:obj];
//    }
//    return [NSArray arrayWithArray:array];
//}


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
                               for (int i = 2; i < 5; i++) {
                                   //[location setObject:@"" forKey:[[[location objectForKey:@"dayList"] objectAtIndex:i] objectForKey:@"desc"]];
                                   [location removeObjectForKey:[[[location objectForKey:@"dayList"] objectAtIndex:i] objectForKey:@"desc"]];
                               }
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
    [self loadPList];
}

- (id)path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return [documentsDirectory stringByAppendingPathComponent:@"Gesundheit.plist"];
}

- (void)loadPList {
    locations = [[[NSUserDefaults standardUserDefaults] objectForKey:@"mxclRULES"] ?: @[] mutableCopy];
}

- (void)savePList {
    NSString *path = [self path];
    NSMutableDictionary *data = [[NSDictionary dictionaryWithContentsOfFile:path] ?: @{} mutableCopy];
    [data setObject:locations forKey:@"locations"];
    //BAM!!!
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"mxclRULES"];
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
    isCheckingZip = NO;
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
    isCheckingZip = YES;
    if (zipTextField.text.length == 5) {
        searchedZip = zipTextField.text;
        zipTextField.text = @"";
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