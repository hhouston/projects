//
//  MotionViewController.m
//  MotionDemoSMU
//
//  Created by Eric Larson on 2/19/14.
//  Copyright (c) 2014 Eric Larson. All rights reserved.
//

#import "MotionViewController.h"
#import "APLGraphView.h"
#import <CoreMotion/CoreMotion.h>

@interface MotionViewController ()

@property (weak, nonatomic) IBOutlet APLGraphView *graphView;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation MotionViewController

- (CMMotionManager *)motionManager
{
    CMMotionManager *motionManager = nil;
    
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    if ([appDelegate respondsToSelector:@selector(motionManager)]) {
        motionManager = [appDelegate motionManager];
    }
    
    return motionManager;
}

-(CMMotionActivityManager*) activityManager
{
    CMMotionActivityManager *activityManager = nil;
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    if([appDelegate respondsToSelector:@selector(activityManager)]) {
        activityManager = [appDelegate activityManager];
    }
    
    return activityManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image1 = [UIImage imageNamed: @"standing.png"];
    UIImage *image2 = [UIImage imageNamed: @"walking.png"];
    UIImage *image3 = [UIImage imageNamed: @"running.png"];
    UIImage *image4 = [UIImage imageNamed: @"driving.png"];
    
    [self.activityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue]
            withHandler:^(CMMotionActivity *activity) {

                if (activity.running) {
                    [self.imageView setImage:image3];
                    self.activityLabel.text = [NSString stringWithFormat:@"Running"];
                } else if (activity.walking) {
                    [self.imageView setImage:image2];
                    self.activityLabel.text = [NSString stringWithFormat:@"Walking"];

                } else if (activity.automotive) {
                    [self.imageView setImage:image4];
                    self.activityLabel.text = [NSString stringWithFormat:@"Driving"];

                } else if (activity.stationary) {
                    [self.imageView setImage:image1];
                    self.activityLabel.text = [NSString stringWithFormat:@"Standing"];

                }
                
                //self.labelIsConfident.text = [NSString stringWithFormat:@"Is Confident : %d",activity.confidence];

            }];
    [self startMotionUpdates];
}

-(void) startMotionUpdates{
    if(self.motionManager){
        NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
        myQueue.maxConcurrentOperationCount = 1;
        [self.motionManager setDeviceMotionUpdateInterval:1.0/100.0];
        [self.motionManager
         startDeviceMotionUpdatesToQueue:myQueue
            withHandler:^(CMDeviceMotion *motion, NSError *error) {
                
                float dotProduct =
                motion.gravity.x*motion.userAcceleration.x +
                motion.gravity.y*motion.userAcceleration.y +
                motion.gravity.z*motion.userAcceleration.z;

                dotProduct /= motion.gravity.x*motion.gravity.x +
                motion.gravity.y*motion.gravity.y +
                motion.gravity.z*motion.gravity.z;
                
                if(abs(dotProduct) > 0.8){
                    dispatch_async(dispatch_get_main_queue(),^{
                        [self.graphView addX:motion.userAcceleration.x
                                           y:motion.userAcceleration.y
                                           z:motion.userAcceleration.z];
                    });
                }
            }];
    }
}

@end
