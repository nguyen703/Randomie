//
//  UIAppearance+Swift.h
//  Chameleon
//
//  Created by Vicc Alexander on 11/26/15.
//  Copyright © 2015 Vicc Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewAppearance_Swift)

// @param containers An array of Class < UIAppearanceContainer >
// http://stackoverflow.com/a/28765193
+ (_Nonnull instancetype)appearanceWhenContainedWithin: (nonnull NSArray<Class<UIAppearanceContainer>> *) containers;

@end
