//
//  ShotTimerViewController.mm
//  FinalProject
//
//  Created by CONNER KNUTSON on 3/26/14.
//  Copyright (c) 2014 CONNER KNUTSON. All rights reserved.
//

#import "ShotTimerViewController.h"
#import "Novocaine.h"
#import "AudioFileReader.h"
#import "RingBuffer.h"
#import "SMUGraphHelper.h"
#import "SMUFFTHelper.h"

#import "ShotTimerViewController2.h"

#define kBufferLength 4096
#define localMaxWindowSize 7


@interface ShotTimerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *freqLabel;
@property (weak, nonatomic) IBOutlet UILabel *magLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@end

@implementation ShotTimerViewController

@synthesize timerLabel;

Novocaine *audioManager;
AudioFileReader *fileReader;
RingBuffer *ringBuffer;
GraphHelper *graphHelper;
float *audioData;
SMUFFTHelper *fftHelper;
float *fftMagnitudeBuffer;
float *fftMagnitudeBufferdB;
float *fftPhaseBuffer;
float loudestShot;
float loudestFreq;
float tempLoudestShot;
float tempLoudestFreq;

int seconds = 10;
int minutes = 0;


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)startTimerMethod {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ticker:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (IBAction)stopTimer:(id)sender {
    [timer invalidate];
}

- (void)transition {
    [self performSegueWithIdentifier:@"secondScreen" sender:self];
}

- (void)ticker:(NSTimer *)timer {
    
    
    //    if (seconds == 0 && minutes >= 1)
    //    {
    //        seconds = 59;
    //        minutes--;
    //
    //    }
    if (minutes ==0 && seconds ==0)
    {
        [self stopTimer:nil];
        [self transition];
        
        //timerLabel.text = @"00:00";
    } else {
        seconds--;
    }
    
    NSString* currentTime = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    timerLabel.text = currentTime;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //graphHelper->tearDownGL();
    
    loudestShot = 0;
    audioManager = [Novocaine audioManager];
    ringBuffer = new RingBuffer(kBufferLength,2);
    
    audioData = (float*)calloc(kBufferLength,sizeof(float));
    
    //setup the fft
    fftHelper = new SMUFFTHelper(kBufferLength,kBufferLength,WindowTypeRect);
    fftMagnitudeBuffer = (float *)calloc(kBufferLength/2,sizeof(float));
    fftMagnitudeBufferdB = (float *)calloc(kBufferLength/2,sizeof(float));
    fftPhaseBuffer     = (float *)calloc(kBufferLength/2,sizeof(float));
    
    
    // start animating the graph
    int framesPerSecond = 30;
    int numDataArraysToGraph = 2;
    graphHelper = new GraphHelper(self,
                                  framesPerSecond,
                                  numDataArraysToGraph,
                                  PlotStyleSeparated);//drawing starts immediately after call
    
    graphHelper->SetBounds(-0.5,0.9,-0.9,0.9); // bottom, top, left, right, full screen==(-1,1,-1,1)
    
    
    [audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         if(ringBuffer!=nil)
             ringBuffer->AddNewFloatData(data, numFrames);
     }];
    
    minutes = 0;
    seconds = 10;
    
    [self stopTimer:nil];
    
    [self startTimerMethod];
    
}

#pragma mark - unloading and dealloc
-(void) viewDidDisappear:(BOOL)animated{
    // stop opengl from running
    graphHelper->tearDownGL();
    //graphHelper->tearDownGL();
    
    free(audioData);
    
    free(fftMagnitudeBuffer);
    free(fftPhaseBuffer);
    
    delete fftHelper;
    delete ringBuffer;
    delete graphHelper;
    
    ringBuffer = nil;
    fftHelper  = nil;
    audioManager = nil;
    graphHelper = nil;
    
    minutes = 0;
    seconds = 10;
    
    [self stopTimer:nil];
    
    
}

-(void)dealloc{
    
    //graphHelper->tearDownGL();
    
    
    // ARC handles everything else, just clean up what we used c++ for (calloc, malloc, new)
    
}

//#pragma mark - OpenGL and Update functions
//  override the GLKView draw function, from OpenGLES
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    graphHelper->draw(); // draw the graph
}

//  override the GLKViewController update function, from OpenGLES
- (void)update{
    
    // plot the audio
    ringBuffer->FetchFreshData2(audioData, kBufferLength, 0, 1);
    graphHelper->setGraphData(0,audioData,kBufferLength); // set graph channel
    
    //take the FFT
    fftHelper->forward(0,audioData, fftMagnitudeBuffer, fftPhaseBuffer);
    
    //Analyze the FFT
    //get the index value of 500Hz and only look at above that
    //k(Fs/N)=500 => k=500(N/Fs) where N is buffer length and Fs 44100
    int minFreqIndex = 500 * (kBufferLength/audioManager.samplingRate);
    //create variables for holding the two loudest frequencies and their indices
    float mag1 = 0;
    int ind1 = 0;
    //    float mag2 = 0;
    //    int ind2 = 0;
    float magTemp = 0;
    int indTemp = 0;
    //outer loop to go through fft
    for(int n = minFreqIndex; n < kBufferLength/2-localMaxWindowSize; n++)
    {
        //reset temp variables to zero
        magTemp = 0;
        indTemp = 0;
        
        //inner loop to go through current window
        for(int m = n; m <= n+localMaxWindowSize; m++)
        {
            //find max in current window
            if(fftMagnitudeBuffer[m] > magTemp)
            {
                magTemp = fftMagnitudeBuffer[m];
                indTemp = m;
            }
        }
        //is max in window the middle value?
        if(indTemp == (n+localMaxWindowSize/2))
        {
            //loudest tone
            if(fftMagnitudeBuffer[indTemp] > fftMagnitudeBuffer[ind1])
            {
                //                mag2 = mag1;
                //                ind2 = ind1;
                mag1 = fftMagnitudeBuffer[indTemp];
                ind1 = indTemp;
                
            }
            //second loudest tone
            //            else if(fftMagnitudeBuffer[indTemp] > fftMagnitudeBuffer[ind2])
            //            {
            //                mag2 = fftMagnitudeBuffer[indTemp];
            //                ind2 = indTemp;
            //
            //            }
        }
    }
    
    
    
    
    
    
    //here I want to convert the magnitude into decibels!
    //tempLoudestShot = fftMagnitudeBuffer[ind1];
    float y = 1;
    vDSP_vdbcon(fftMagnitudeBuffer, 1, &y, fftMagnitudeBufferdB, 1, kBufferLength/2, 0);
    tempLoudestShot = fftMagnitudeBufferdB[ind1];
    tempLoudestFreq = ind1*(audioManager.samplingRate/kBufferLength);
    
    
    
    
    
    
    if(tempLoudestShot > loudestShot && tempLoudestShot > 10.0 /*&& fftMagnitudeBuffer[ind2] > .8*/)
    {
        loudestShot = tempLoudestShot;
        /*vDSP_vdbcon(fftMagnitudeBuffer, 1, &y, fftMagnitudeBufferdB, 1, kBufferLength/2, 0);
         loudestShot = fftMagnitudeBufferdB[ind1];
         loudestFreq = ind1*(audioManager.samplingRate/kBufferLength);*/
        loudestFreq = tempLoudestFreq;
        NSLog(@"The loudest frequency is: %.2f Hz with magnitude %.2f dB",(ind1*(audioManager.samplingRate/kBufferLength)),loudestShot);
        _freqLabel.text = [NSString stringWithFormat:@"%.2f Hz",ind1*(audioManager.samplingRate/kBufferLength)];
        _magLabel.text = [NSString stringWithFormat:@"%.2f dB",loudestShot];
        //_firstValue.text = [NSString stringWithFormat:@"%.2f",ind1*(audioManager.samplingRate/kBufferLength)];
        
        //NSLog(@"The loudest frequency is: %.2f dB",magTemp);
        //make a label to display on screen the loudest magnitude
        
        //        NSLog(@"The second loudest frequency is: %.2f Hz",(ind2*(audioManager.samplingRate/kBufferLength)));
        //        _secondValue.text = [NSString stringWithFormat:@"%.2f",ind2*(audioManager.samplingRate/kBufferLength)];
    }
    
    // plot the FFT
    graphHelper->setGraphData(1,fftMagnitudeBuffer,kBufferLength/2,sqrt(kBufferLength)); // set graph channel
    
    graphHelper->update(); // update the graph
}


#pragma mark - status bar
-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"secondScreen"]){
        //ViewControllerB *controller = (ViewControllerB *)segue.destinationViewController;
        //        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        //ShotTimerViewController2* tmp = (ShotTimerViewController2*)[segue destinationViewController];
        ShotTimerViewController2* tmp = (ShotTimerViewController2*)segue.destinationViewController;
        NSLog(@"\n\nPassing values:\nMag: %.2f Freq: %.2f\n\n",loudestShot,loudestFreq);
        tmp.magVal = loudestShot;
        tmp.freqVal = loudestFreq;
    }
    //[segue destinationViewController];
    
    
    
    
}


//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end
