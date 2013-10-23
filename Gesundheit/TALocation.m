//
//  TALocation.m
//  Gesundheit
//
//  Created by Jhaybie on 10/23/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "TALocation.h"

@implementation TALocation


- (NSString *) getCurrentLocationZip {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    NSDictionary *address;
    CLGeocoder *geocoder;
//    [geocoder reverseGeocodeLocation:location completionHandler:<#^(NSArray *placemarks, NSError *error)completionHandler#>]
    return @"60076";
}

//-(NSArray *) fetchPollenData {
//    NSString *zip =
//    NSString *address = [NSString stringWithFormat:@"http://direct.weatherbug.com/DataService/GetPollen.ashx?zip=", zip];
//    NSURL *url = [NSURL URLWithString:address];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
//     {
//}

@end
