//
//  TALocation.m
//  Gesundheit
//
//  Created by Jhaybie on 10/23/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "TALocation.h"

@implementation TALocation


//- (NSString *) getCurrentLocationZip {
//    NSString *zip = @"60076";
//    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
//    [locationManager startUpdatingLocation];
//    CLLocation *location = [locationManager location];
//    CLLocationCoordinate2D coordinate = [location coordinate];
//    NSDictionary *address;
//    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (error){
//            NSLog(@"Geocode failed with error: %@", error);
//            NSLog(@"Error acquiring location.");
//        return;
//        }
//        NSLog(@"Received placemarks: %@", placemarks);
//        
//    }];
//    return zip;
//}

-(NSArray *) fetchPollenData {
    NSMutableArray *weeklyForecast;
    NSString *zip = @"60654";// [self getCurrentLocationZip];
    NSString *address = [NSString stringWithFormat:@"http://direct.weatherbug.com/DataService/GetPollen.ashx?zip=%@", zip];
    NSURL *url = [NSURL URLWithString:address];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *initialDump = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:&connectionError];
        NSArray *forecastArray = [initialDump objectForKey:@"dayList"];
        NSLog(@"%@, %@", [initialDump objectForKey:@"city"], [initialDump objectForKey:@"state"]);
        NSLog(@"%@", [forecastArray[0] desc]);
        //return forecastArray;
    }];
    return weeklyForecast;
}

@end
