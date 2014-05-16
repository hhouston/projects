//
//  AppDelegate.h
//  assignment3
//
//  Created by Hunter Houston on 2/24/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@class StepViewController, MotionViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    CMMotionManager *motionManager;
    CMMotionActivityManager *activityManager;
}

@property (readonly) CMMotionManager *motionManager;
@property (readonly) CMMotionActivityManager *activityManager;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) StepViewController *svc;
@property (strong, nonatomic) MotionViewController *mvc;
@end
