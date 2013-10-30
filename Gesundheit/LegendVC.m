//
//  LegendVC.m
//  Gesundheit
//
//  Created by Daniel Bostjancic on 10/30/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "LegendVC.h"
#import "UIColor+ColorCategory.h"

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

@end

@implementation LegendVC

@synthesize backRoundImage,
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
    backRoundImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"skyBackRoundwithClouds.png"]];
    [self changeAlpha];
    [self changeColors];
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

    float alpha = .8;

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
