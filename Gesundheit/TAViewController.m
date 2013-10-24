//
//  TAViewController.m
//  Gesundheit
//
//  Created by Jhaybie on 10/23/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "TAViewController.h"
#import "TALocation.h"

@interface TAViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateAbbreviationLabel;
@property (weak, nonatomic) IBOutlet UILabel *allergenLevelLabel;
@property (weak, nonatomic) IBOutlet UITextView *desciptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *prodominateTypeLabel;

@end

@implementation TAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) showResults
{
    
    
    NSDictionary *tempDict;
    NSArray *tempArray;
    for (NSDictionary *dict in tempArray) {
        tempArray = [tempDict objectForKey:@"city"];
        tempArray = [tempDict objectForKey:@"desc"];
        tempArray = [tempDict objectForKey:@"predominantType"];
        tempArray = [tempDict objectForKey:@"state"];
    }
}

@end
