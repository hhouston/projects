//
//  HeartRateViewController.m
//  CoreImageApp
//
//  Created by Hunter Houston on 3/24/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "HeartRateViewController.h"
#import <opencv2/highgui/cap_ios.h>

#define kHueAdjustAmount 80.0
const int kCannyLowThreshold = 300;
const int kFilterKernelSize = 5;
#define kBufferLengthA 1440
#define localMaxWindowSize 7

using namespace cv;

@interface HeartRateViewController ()<CvVideoCameraDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) CvVideoCamera* videoCamera;
@property (nonatomic) BOOL torchIsOn;
@property (strong,nonatomic) NSArray *cvExampleTypes;
@property (atomic) cv::CascadeClassifier classifier;
@property (weak, nonatomic) IBOutlet UILabel *beatCounterLabel;
@property (nonatomic) BOOL start;
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property int i;
@property (nonatomic) NSInteger heartRateCounter;
@property (nonatomic) NSInteger heartRateFinal;

@end

@implementation HeartRateViewController
float bufferA[1000];
float *fftPhaseBufferA;

-(CvVideoCamera *)videoCamera{
    if(!_videoCamera)
    {
        _videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
        _videoCamera.delegate = self;
        _videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
        _videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
        _videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        _videoCamera.defaultFPS = 24;
        _videoCamera.grayscaleMode = NO;
    }
    return _videoCamera;
}

-(BOOL)torchIsOn {
    if(!_torchIsOn)
        _torchIsOn = NO;
    
    return _torchIsOn;
}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.start = false;
    self.i = 0;
    
	// Do any additional setup after loading the view, typically from a nib.
    
}

-(void) viewDidAppear:(BOOL)animated  {
    [super viewDidAppear:animated];
    [self.videoCamera start];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.videoCamera stop];
    [super viewWillDisappear:animated];
}


#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
    // Do some OpenCV stuff with the image
    Mat image_copy;
    Mat grayFrame, output;

            //============================================
            // get average pixel intensity
            cvtColor(image, image_copy, CV_BGRA2BGR); // get rid of alpha for processing
            Scalar avgPixelIntensity = cv::mean( image_copy );
            char text[50];
            sprintf(text,"Avg. B: %.1f, G: %.1f,R: %.1f", avgPixelIntensity.val[0],avgPixelIntensity.val[1],avgPixelIntensity.val[2]);
            cv::putText(image, text, cv::Point(10, 20), FONT_HERSHEY_PLAIN, 1, Scalar::all(255), 1,2);
    
    static int arrayCounter = 0;
    float pixelTemp = 0;
    int indexTemp = 0;
    int counter = 0;
    
    if (self.start == true) {
        bufferA[_i] = avgPixelIntensity.val[2];
        _i++;
//when self.i = 1000
    }

    for(int n = 0; n < kBufferLengthA; n++)
    {
        //reset temp variables to zero
        pixelTemp = 0;
        indexTemp = 0;
        arrayCounter++;
        //inner loop to go through current window
        for(int m = n; m <= n+localMaxWindowSize; m++)
        {
            
            //find max in current window
            if(bufferA[m] > pixelTemp)
            {
                pixelTemp = bufferA[m];
                indexTemp = m;
            }
        }
        //is max in window the middle value?
        if(indexTemp == (n+localMaxWindowSize/2))
        {
            counter++;

        }
    }
    NSString *string = [NSString stringWithFormat:@"%d BPM", counter];
    self.beatCounterLabel.text = string;
                                  //NSString stringWithFormat:@"Beat counter: %@", string];
    NSLog(@"HEART RATE: %d",counter);

    if (self.i == 1440) {
        
        NSString *string2 = [NSString stringWithFormat:@"%d BPM", counter];
        self.heartRateLabel.text = string2;
        NSLog(@"DONE: %@",string2);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DONE" message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    //self.heartRateFinal = counter;
    //self.heartRateLabel.text = [NSString stringWithFormat:@"Heart Rate: %ld", (long)self.heartRateFinal];
}
#endif

- (IBAction)startHR:(UIButton *)sender {
    self.start = true;

}


#pragma mark - Flash and Torch Handling
- (IBAction)toggleTorch:(id)sender {
    if(self.videoCamera.defaultAVCaptureDevicePosition == AVCaptureDevicePositionBack){
        self.torchIsOn = !self.torchIsOn;
        [self setTorchOn:self.torchIsOn];
    }
    
}

- (void)setTorchOn: (BOOL) onOff
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        [device lockForConfiguration:nil];
        [device setTorchMode: onOff ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}


@end
