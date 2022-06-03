//
//  UIAppearance+Swift.m
//  Chameleon
//
//  Created by Vicc Alexander on 11/26/15.
//  Copyright © 2015 Vicc Alexander. All rights reserved.
//

#import "UIAppearance+Swift.h"

@implementation UIView (UIViewAppearance_Swift)

+ (_Nonnull instancetype)appearanceWhenContainedWithin: (nonnull NSArray<Class<UIAppearanceContainer>> *) containers {
    
    NSAssert(containers.count <= 10,
                 @"The count of containers greater than 10 is not supported.");
    
    return [self
                appearanceWhenContainedInInstancesOfClasses:containers];
}

@end
