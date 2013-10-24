//
//  TAAppDelegate.h
//  Gesundheit
//
//  Created by Jhaybie on 10/23/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSManagedObjectContext *moc;
@end



// convenience categories

@interface NSFileManager (mxcl)
- (NSURL *)documentURLForFilename:(id)filename;
@end

@interface UIApplication (mxcl)
+ (NSManagedObjectContext *)moc;
@end
