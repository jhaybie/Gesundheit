//
//  UIColor+ColorCategory.m
//  Gesundheit
//
//  Created by Daniel Bostjancic on 10/30/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "UIColor+ColorCategory.h"

@implementation UIColor (ColorCategory)

+ (UIColor *) lowColor {
    return [UIColor colorWithRed:2.0f/255.0f green:255.0f/255.0f blue:238.0f/255.0f alpha:1];
}

+ (UIColor *) lowMedColor {
    return [UIColor colorWithRed:0.0f/255.0f green:178.0f/255.0f blue:167.0f alpha:1];
}

+ (UIColor *) mediumColor {
    return [UIColor colorWithRed:255.0f/255.0f green:87.0f/255.0f blue:2.0f/255.0f alpha:1];
}

+ (UIColor *) medHighColor {
    return [UIColor colorWithRed:255.0f/255.0f green:104.0f/255.0f blue:27.0f/255.0f alpha:1];
}

+ (UIColor *) highColor {
    return [UIColor colorWithRed:178.0f/255.0f green:65.0f/255.0f blue:7.0f/255.0f alpha:1];
}

+ (UIColor *) darkGreenColor {
    return [UIColor colorWithRed:35.0f/255.0f green:142.0f/255.0f blue:35.0f/255.0f alpha:1];
}

+ (UIColor *) veryDarkGreenColor {
    return [UIColor colorWithRed:47.0f/255.0f green:79.0f/255.0f blue:47.0f/255.0f alpha:1];
}
@end

