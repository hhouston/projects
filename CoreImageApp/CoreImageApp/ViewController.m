//
//  ViewController.m
//  CoreImageApp
//
//  Created by Hunter Houston on 3/23/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "ViewController.h"
#import "VideoAnalgesic.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

@interface ViewController ()

@property (strong,nonatomic) VideoAnalgesic *videoManager;
@property (nonatomic) BOOL useHighAccuracy;
@property (strong,nonatomic) CIVector *center;
@property (readonly, assign) CGPoint leftEyePosition;
@property (readonly, assign) CGPoint rightEyePosition;
@property (readonly, assign) CGPoint mouthPosition;
@property (nonatomic, strong) UIImageView *activeImageView;


@end

@implementation ViewController

float radius;

-(VideoAnalgesic*)videoManager{
    if(!_videoManager){
        _videoManager = [VideoAnalgesic captureManager];
        _videoManager.preset = AVCaptureSessionPresetMedium;
        [_videoManager setCameraPosition:AVCaptureDevicePositionFront];
    }
    return _videoManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = nil;
    
//    self.window = [[UIWindow alloc]initWithFrame:self.window.frame];
    
//    radius = 100.0;
//    self.center = [CIVector vectorWithX:self.view.bounds.size.height/2.0 - radius/2.0 Y:self.view.bounds.size.width/2.0+radius/2.0];
    
    __weak typeof(self) weakSelf = self;
    //NSString *accuracy = self.useHighAccuracy ? CIDetectorAccuracyHigh : CIDetectorAccuracyLow;// 1
//    __block CIFilter *filter = [CIFilter filterWithName:@"CIRadialGradient"];
//
//    [filter setValue:@"100f" forKey:@"inputRadius0"];
//    [filter setValue:@"300f" forKey:@"inputRadius1"];

    NSDictionary *opts1 = @{CIDetectorAccuracy:CIDetectorAccuracyHigh};
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:self.videoManager.ciContext
                                              options:opts1];
    

    [self.videoManager setProcessBlock:^(CIImage *cameraImage){
         NSDictionary *options = @{CIDetectorSmile: @(YES), CIDetectorEyeBlink: @(YES), CIDetectorImageOrientation :
                                              [VideoAnalgesic ciOrientationFromDeviceOrientation:[UIApplication sharedApplication].statusBarOrientation]};

        NSArray *features = [detector featuresInImage:cameraImage options:options];
        
        
        
        [weakSelf drawOnFace:features];
        
        return cameraImage;
    }];
    //[self detectFacialFeatures];
}

- (void) drawOnFace:(NSArray *)features {
    for (CIFaceFeature *face in features)
    {
        
        //NSLog(@"Bounds: %@", NSStringFromCGRect(face.bounds));
        [faceView removeFromSuperview];
        CGFloat faceWidth = face.bounds.size.width;
        // create a UIView using the bounds of the face
        faceView = [[UIView alloc] initWithFrame:face.bounds];
        // add a border around the newly created UIView
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        // add the new view to create a box around the face
        //[weakSelf.view addSubview:faceView];
        //[self.view addSubview:faceView];
        if(face.hasLeftEyePosition)
        {
            // create a UIView with a size based on the width of the face
            UIView* leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(face.leftEyePosition.x-faceWidth*0.15, face.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            // change the background color of the eye view
            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            // set the position of the leftEyeView based on the face
            [leftEyeView setCenter:face.leftEyePosition];
            // round the corners
            leftEyeView.layer.cornerRadius = faceWidth*0.15;
            // add the view to the window
            [self.view addSubview:leftEyeView];
        }
        
        if(face.hasRightEyePosition)
        {
            // create a UIView with a size based on the width of the face
            UIView* rightEyeView = [[UIView alloc] initWithFrame:CGRectMake(face.rightEyePosition.x-faceWidth*0.15, face.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            // change the background color of the eye view
            [rightEyeView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.3]];
            // set the position of the rightEyeView based on the face
            [rightEyeView setCenter:face.rightEyePosition];
            // round the corners
            rightEyeView.layer.cornerRadius = faceWidth*0.15;
            // add the new view to the window
            [self.view addSubview:rightEyeView];
        }
        
        CGRect modifiedFaceBounds = face.bounds;
        float xx = face.bounds.origin.x + face.bounds.size.height/2;
        float yy = face.bounds.origin.y + face.bounds.size.width/2;
        CIVector *vect = [CIVector vectorWithX:xx Y:yy];
        
        
        //NSLog(@"vect: %@",vect);
        //[filter setValue:vect forKey:@"inputCenter"];
        //cameraImage = filter.outputImage;
        
        NSString *hasSmile = face.hasSmile ? @"Yes" : @"No";
        NSString *hasLeftEye = face.hasLeftEyePosition ? @"Yes" : @"No";
        NSString *hasRightEye = face.hasRightEyePosition ? @"Yes" : @"No";
        NSString *hasLeftEyeBlink = face.leftEyeClosed ? @"Yes" : @"No";
        NSString *hasRightEyeBlink = face.rightEyeClosed ? @"Yes" : @"No";
        NSString *string = [NSString stringWithFormat:@" SMILING: %@\n LEFT EYE: %@\n LEFT EYE BLINKING: %@\n RIGHT EYE: %@\n RIGHT EYE BLINKING: %@",
                            hasSmile, hasLeftEye, hasLeftEyeBlink, hasRightEye, hasRightEyeBlink];
        
        NSLog(@"string: %@",string);
    }
}

- (IBAction)useHighAccuracy:(id)sender {
    self.useHighAccuracy = [sender isOn];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(![self.videoManager isRunning])
        [self.videoManager start];
}

-(void)viewWillDisappear:(BOOL)animated{
    if([self.videoManager isRunning])
        [self.videoManager stop];
    
    [super viewWillDisappear:animated];
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (IBAction)panFromUserWithRecognizer:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.videoManager.videoPreviewView];
    self.center = [CIVector vectorWithX:point.x-radius/2 Y:self.videoManager.videoPreviewView.bounds.size.height - point.y +radius/2];
    
}

-(void)changeColorMatching{
    [self.videoManager shouldColorMatch:YES];
}


@end
