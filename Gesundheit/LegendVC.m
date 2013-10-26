//
//  TALegendViewController.m
//  Gesundheit
//
//  Created by Daniel Bostjancic on 10/24/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "LegendVC.h"

@interface LegendVC ()

@property (weak, nonatomic) IBOutlet UITextView *lowDisplayTextView;
@property (weak, nonatomic) IBOutlet UITextView *lowMediumDisplayTextView;
@property (weak, nonatomic) IBOutlet UITextView *mediumDisplayTextView;
@property (weak, nonatomic) IBOutlet UITextView *mediumHighDisplayTextView;
@property (weak, nonatomic) IBOutlet UITextView *highDisplayTextView;
@property (weak, nonatomic) IBOutlet UILabel    *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel    *lowMediumLabel;
@property (weak, nonatomic) IBOutlet UILabel    *mediumLabel;
@property (weak, nonatomic) IBOutlet UILabel    *mediumHighLabel;
@property (weak, nonatomic) IBOutlet UILabel    *highLabel;

@end


@implementation LegendVC
@synthesize lowDisplayTextView,
            lowLabel,
            lowMediumDisplayTextView,
            lowMediumLabel,
            mediumDisplayTextView,
            mediumLabel,
            mediumHighDisplayTextView,
            mediumHighLabel,
            highDisplayTextView,
            highLabel;


UIColor *darkGreenColor,
        *greenColor,
        *yellowColor,
        *orangeColor,
        *redColor;


- (void)viewDidLoad {
    [super viewDidLoad];
    darkGreenColor = [UIColor colorWithRed:34.0f/255.0f
                                     green:139.0f/255.0f
                                      blue:34.0f/255.0f
                                     alpha:1];
    greenColor = [UIColor colorWithRed:124.0f/255.0f
                                 green:252.0f/255.0f
                                  blue:0.0f/255.0f
                                 alpha:1];
    yellowColor = [UIColor colorWithRed:255.0f/255.0f
                                  green:215.0f/255.0f
                                   blue:0.0f/255.0f
                                  alpha:1.0];
    orangeColor = [UIColor colorWithRed:255.0f/255.0f
                                  green:140.0f/255.0f
                                   blue:0.0f/255.0f
                                  alpha:1.0];
    redColor = [UIColor colorWithRed:255.0f/255.0f
                               green:0.0f/255.0f
                                blue:0.0f/255.0f
                               alpha:1.0];
    [self changeTextAndBackgroundColors];
}

- (void)changeTextAndBackgroundColors {
    lowDisplayTextView.backgroundColor = darkGreenColor;
    lowMediumDisplayTextView.backgroundColor = greenColor;
    mediumDisplayTextView.backgroundColor = yellowColor;
    mediumHighDisplayTextView.backgroundColor = orangeColor;
    highDisplayTextView.backgroundColor = redColor;
    lowLabel.textColor = darkGreenColor;
    lowMediumLabel.textColor = greenColor;
    mediumLabel.textColor = yellowColor;
    mediumHighLabel.textColor = orangeColor;
    highLabel.textColor = redColor;
}

- (IBAction)onViewTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
