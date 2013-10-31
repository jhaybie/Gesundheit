//
//  LegendVC.m
//  Gesundheit
//
//  Created by Daniel Bostjancic on 10/30/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "LegendVC.h"
#import "UIColor+ColorCategory.h"
#import <QuartzCore/QuartzCore.h>

@interface LegendVC ()
@property (weak, nonatomic) IBOutlet UITextView *lowTextField;
@property (weak, nonatomic) IBOutlet UITextView *lowMedTextField;
@property (weak, nonatomic) IBOutlet UITextView *mediumTextField;
@property (weak, nonatomic) IBOutlet UITextView *medHighTextField;
@property (weak, nonatomic) IBOutlet UITextView *highTextField;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowMedLabel;
@property (weak, nonatomic) IBOutlet UILabel *mediumLabel;
@property (weak, nonatomic) IBOutlet UILabel *medHighLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backRoundImage;
@property (weak, nonatomic) IBOutlet UIImageView *dandyImagePng;

@end

@implementation LegendVC

@synthesize backRoundImage,
            dandyImagePng,
            lowLabel,
            lowTextField,
            lowMedLabel,
            lowMedTextField,
            mediumLabel,
            mediumTextField,
            medHighLabel,
            medHighTextField,
            highLabel,
            highTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showBackgroundImages];
    [self changeAlpha];
    [self changeColors];
}

- (void)showBackgroundImages {
    backRoundImage.image = [UIImage imageNamed:@"skyBackRound2.png"];
    dandyImagePng.image = [UIImage imageNamed:@"testDandyDan.png"];
    [dandyImagePng setAlpha:.50];


}
- (void) changeColors {
    lowLabel.textColor = [UIColor lowColor];
    lowTextField.backgroundColor =  [UIColor lowColor];
    lowMedLabel.textColor =  [UIColor lowMedColor];
    lowMedTextField.backgroundColor =  [UIColor lowMedColor];
    mediumLabel.textColor =  [UIColor mediumColor];
    mediumTextField.backgroundColor =  [UIColor mediumColor];
    medHighLabel.textColor =  [UIColor medHighColor];
    medHighTextField.backgroundColor =  [UIColor medHighColor];
    highLabel.textColor =  [UIColor highColor];
    highTextField.backgroundColor =  [UIColor highColor];
}

- (void) changeAlpha {

    float alpha = .85;

    lowTextField.alpha = alpha;
    lowMedTextField.alpha = alpha;
    mediumTextField.alpha = alpha;
    medHighTextField.alpha = alpha;
    highTextField.alpha = alpha;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
