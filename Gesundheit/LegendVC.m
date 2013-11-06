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

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

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
@property (weak, nonatomic) IBOutlet UIImageView *grassPng;

@end

@implementation LegendVC

@synthesize backRoundImage,
            grassPng,
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
    [self rotateDandy:dandyImagePng duration:1 degrees:2];
    [self changeColors];
}

- (void)rotateDandy:(UIImageView *)image
           duration:(NSTimeInterval)duration
            degrees:(CGFloat)degrees {
    [dandyImagePng.layer setAnchorPoint:CGPointMake(0.0, 1.0)];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, nil, 0, 570, 1, DEGREES_TO_RADIANS(90),DEGREES_TO_RADIANS(94), NO);

    CAKeyframeAnimation *dandyAnimation;
    dandyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    dandyAnimation.path = path;
    CGPathRelease(path);
    dandyAnimation.duration = duration;
    dandyAnimation.removedOnCompletion = NO;
    dandyAnimation.autoreverses = YES;
    dandyAnimation.rotationMode = kCAAnimationRotateAutoReverse;
    dandyAnimation.speed = .2f;
    dandyAnimation.repeatCount = INFINITY;
    dandyAnimation.fillMode = kCAFillModeBoth;

    [dandyImagePng.layer addAnimation:dandyAnimation forKey:@"position"];
}

- (void)showBackgroundImages {
    backRoundImage.image = [UIImage imageNamed:@"skyBackRound2.png"];
    dandyImagePng.image = [UIImage imageNamed:@"testDandyDan.png"];
    grassPng.image = [UIImage imageNamed:@"grass"];
    grassPng.alpha = 0.60;
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
