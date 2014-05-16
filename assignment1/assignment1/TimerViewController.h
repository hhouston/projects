//
//  TimerViewController.h
//  assignment1
//
//  Created by Hunter Houston on 2/3/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerViewController : UIViewController {
    NSTimer *timer;
    int seconds;
    int minutes;
}

-(IBAction)stopTimer:(id)sender;
-(IBAction)startTimer:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIStepper *minuteStepper;
@property (weak, nonatomic) IBOutlet UIStepper *secondStepper;

@end
