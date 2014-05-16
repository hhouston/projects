//
//  ShotTimerViewController2.h
//  FinalProject
//
//  Created by CONNER KNUTSON on 3/26/14.
//  Copyright (c) 2014 CONNER KNUTSON. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface ShotTimerViewController2 : GLKViewController
{
    NSTimer *timer2;
}

//@property (nonatomic) float shotMag;
//@property (nonatomic) float shotFreq;

@property (nonatomic) float magVal;
@property (nonatomic) float freqVal;


@end
