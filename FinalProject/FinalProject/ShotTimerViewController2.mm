//
//  ShotTimerViewController2.m
//  FinalProject
//
//  Created by CONNER KNUTSON on 3/26/14.
//  Copyright (c) 2014 CONNER KNUTSON. All rights reserved.
//

#import "ShotTimerViewController2.h"
#import "Novocaine.h"
#import "AudioFileReader.h"
#import "RingBuffer.h"
#import "SMUGraphHelper.h"
#import "SMUFFTHelper.h"

#define kBufferLength2 4096
#define localMaxWindowSize2 7

//#define magValue 20
#define magTolerance 4
//#define freqValue 700
#define freqTolerance 100


@interface ShotTimerViewController2 ()
//@property (weak, nonatomic) IBOutlet UILabel *freqLabel;
//@property (weak, nonatomic) IBOutlet UILabel *magLabel;
//@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel2;

@property (weak, nonatomic) IBOutlet UILabel *split1;
@property (weak, nonatomic) IBOutlet UILabel *split2;
@property (weak, nonatomic) IBOutlet UILabel *split3;
@property (weak, nonatomic) IBOutlet UILabel *split4;
@property (weak, nonatomic) IBOutlet UILabel *split5;
@property (weak, nonatomic) IBOutlet UILabel *split6;
@property (weak, nonatomic) IBOutlet UILabel *split7;
@property (weak, nonatomic) IBOutlet UILabel *split8;
@property (weak, nonatomic) IBOutlet UILabel *split9;
@property (weak, nonatomic) IBOutlet UILabel *split10;
@property (weak, nonatomic) IBOutlet UILabel *split11;
@property (weak, nonatomic) IBOutlet UILabel *split12;
@property (weak, nonatomic) IBOutlet UILabel *splitTotal;

@property (nonatomic,strong) AVAudioPlayer *beep;

@end

@implementation ShotTimerViewController2

@synthesize beep;

@synthesize timerLabel2;

@synthesize split1;
@synthesize split2;
@synthesize split3;
@synthesize split4;
@synthesize split5;
@synthesize split6;
@synthesize split7;
@synthesize split8;
@synthesize split9;
@synthesize split10;
@synthesize split11;
@synthesize split12;
@synthesize splitTotal;


Novocaine *audioManager2;
AudioFileReader *fileReader2;
RingBuffer *ringBuffer2;
GraphHelper *graphHelper2;
float *audioData2;
SMUFFTHelper *fftHelper2;
float *fftMagnitudeBuffer2;
float *fftMagnitudeBufferdB2;
float *fftPhaseBuffer2;
float loudestShot2;

int milliseconds2 = 0;
int seconds2 = 0;
int minutes2 = 0;

int shotCounter = 0;
int splitMSTotal = 0;
int splitSTotal = 0;
int splitMTotal = 0;
int splitMS[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int splitS[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
int splitM[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

bool isListening = false;
bool first = true;
bool isAdding = false;


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)startTimerMethod {
    isListening = true;
    timer2 = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(ticker2:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
}

- (IBAction)stopTimer:(id)sender {
    isListening = false;
    [timer2 invalidate];
    if(isAdding)
    {
        int ms = splitMSTotal%1000;
        int s = splitMSTotal/1000 + splitSTotal%60;
        int m = splitSTotal/60 + splitMTotal;
        splitTotal.text = [NSString stringWithFormat:@"%d:%d.%d",m,s,ms];
        isAdding = false;
    }
    
}
- (IBAction)startButton:(id)sender
{
    [self stopTimer:nil];
    
    minutes2 = 0;
    seconds2 = 0;
    milliseconds2 = 0;
    
    [NSThread sleepForTimeInterval:3.0];
    
    //make beep sound?
    //AudioServicesPlaySystemSound(1005);
    
    NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-04" ofType:@"wav"]];
    beep = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
    [beep setVolume:1.0];
    [beep prepareToPlay];
    [beep play];
    
    //reset all the values
    shotCounter = 0;
    splitMSTotal = 0;
    splitSTotal = 0;
    splitMTotal = 0;
    
    split1.text = [NSString stringWithFormat:@"00.000"];
    split2.text = [NSString stringWithFormat:@"00.000"];
    split3.text = [NSString stringWithFormat:@"00.000"];
    split4.text = [NSString stringWithFormat:@"00.000"];
    split5.text = [NSString stringWithFormat:@"00.000"];
    split6.text = [NSString stringWithFormat:@"00.000"];
    split7.text = [NSString stringWithFormat:@"00.000"];
    split8.text = [NSString stringWithFormat:@"00.000"];
    split9.text = [NSString stringWithFormat:@"00.000"];
    split10.text = [NSString stringWithFormat:@"00.000"];
    split11.text = [NSString stringWithFormat:@"00.000"];
    split12.text = [NSString stringWithFormat:@"00.000"];
    
    isListening = true;
    first = true;
    
    [self startTimerMethod];
}
- (IBAction)stopButton:(id)sender
{
    isAdding = true;
    [self stopTimer:nil];
    
    minutes2 = 0;
    seconds2 = 0;
    milliseconds2 = 0;
    
    timerLabel2.text = [NSString stringWithFormat:@"00.000"];
}

//- (void)transition {
//    [self performSegueWithIdentifier:@"secondScreen" sender:self];
//}

- (void)ticker2:(NSTimer *)timer2 {
    
    //NSLog(@"Ticking...");
    
    if(first)
    {
        milliseconds2 = 250;
        first = false;
    }
    
    if(seconds2 == 59 && milliseconds2 == 999)
    {
        seconds2 = 0;
        milliseconds2 = 0;
        minutes2++;
    }
    else if(milliseconds2 == 999)
    {
        milliseconds2 = 0;
        seconds2++;
    }
    else
    {
        milliseconds2++;
    }
    
    
    //    if (seconds == 0 && minutes >= 1)
    //    {
    //        seconds = 59;
    //        minutes--;
    //
    //    }
    //    if (minutes ==0 && seconds ==0)
    //    {
    //        [self stopTimer:nil];
    //        [self transition];
    //
    //        //timerLabel.text = @"00:00";
    //    } else {
    //        seconds--;
    //    }
    
    NSString* currentTime2 = [NSString stringWithFormat:@"%02d.%03d",seconds2,milliseconds2];
    //NSLog(@"%@",currentTime2);
    timerLabel2.text = currentTime2;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //graphHelper2->tearDownGL();
    
    
    audioManager2 = [Novocaine audioManager];
    ringBuffer2 = new RingBuffer(kBufferLength2,2);
    
    audioData2 = (float*)calloc(kBufferLength2,sizeof(float));
    
    //setup the fft
    fftHelper2 = new SMUFFTHelper(kBufferLength2,kBufferLength2,WindowTypeRect);
    fftMagnitudeBuffer2 = (float *)calloc(kBufferLength2/2,sizeof(float));
    fftMagnitudeBufferdB2 = (float *)calloc(kBufferLength2/2,sizeof(float));
    fftPhaseBuffer2     = (float *)calloc(kBufferLength2/2,sizeof(float));
    
    
    // start animating the graph
    int framesPerSecond = 30;
    int numDataArraysToGraph = 2;
    graphHelper2 = new GraphHelper(self,
                                   framesPerSecond,
                                   numDataArraysToGraph,
                                   PlotStyleSeparated);//drawing starts immediately after call
    
    graphHelper2->SetBounds(-0.5,0.9,-0.9,0.9); // bottom, top, left, right, full screen==(-1,1,-1,1)
    
    [audioManager2 setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         if(ringBuffer2!=nil)
             ringBuffer2->AddNewFloatData(data, numFrames);
     }];
    
    minutes2 = 0;
    seconds2 = 0;
    milliseconds2 = 0;
    
    [self stopTimer:nil];
    
    //[self startTimerMethod];
    
    NSLog(@"\n\nPassed in values:\nMag: %.2f Freq: %.2f\n\n",_magVal,_freqVal);
    
}

#pragma mark - unloading and dealloc
-(void) viewDidDisappear:(BOOL)animated{
    // stop opengl from running
    graphHelper2->tearDownGL();
    //graphHelper2->tearDownGL();
    
    free(audioData2);
    
    free(fftMagnitudeBuffer2);
    free(fftMagnitudeBufferdB2);
    free(fftPhaseBuffer2);
    
    delete fftHelper2;
    delete ringBuffer2;
    delete graphHelper2;
    
    ringBuffer2 = nil;
    fftHelper2  = nil;
    audioManager2 = nil;
    graphHelper2 = nil;
    
    minutes2 = 0;
    seconds2 = 0;
    milliseconds2 = 0;
    
    [self stopTimer:nil];
    
}

-(void)dealloc{
    
    //graphHelper2->tearDownGL();
    
    
    // ARC handles everything else, just clean up what we used c++ for (calloc, malloc, new)
    
}

//#pragma mark - OpenGL and Update functions
//  override the GLKView draw function, from OpenGLES
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    graphHelper2->draw(); // draw the graph
}

//  override the GLKViewController update function, from OpenGLES
- (void)update{
    
    //NSLog(@"Update function");
    
    // plot the audio
    ringBuffer2->FetchFreshData2(audioData2, kBufferLength2, 0, 1);
    graphHelper2->setGraphData(0,audioData2,kBufferLength2); // set graph channel
    
    //take the FFT
    fftHelper2->forward(0,audioData2, fftMagnitudeBuffer2, fftPhaseBuffer2);
    
    //Analyze the FFT
    //get the index value of 500Hz and only look at above that
    //k(Fs/N)=500 => k=500(N/Fs) where N is buffer length and Fs 44100
    int minFreqIndexb = 500 * (kBufferLength2/audioManager2.samplingRate);
    //create variables for holding the two loudest frequencies and their indices
    float mag1b = 0;
    int ind1b = 0;
    //    float mag2 = 0;
    //    int ind2 = 0;
    float magTempb = 0;
    int indTempb = 0;
    //outer loop to go through fft
    for(int n = minFreqIndexb; n < kBufferLength2/2-localMaxWindowSize2; n++)
    {
        //reset temp variables to zero
        magTempb = 0;
        indTempb = 0;
        
        //inner loop to go through current window
        for(int m = n; m <= n+localMaxWindowSize2; m++)
        {
            //find max in current window
            if(fftMagnitudeBuffer2[m] > magTempb)
            {
                magTempb = fftMagnitudeBuffer2[m];
                indTempb = m;
            }
        }
        //is max in window the middle value?
        if(indTempb == (n+localMaxWindowSize2/2))
        {
            //loudest tone
            if(fftMagnitudeBuffer2[indTempb] > fftMagnitudeBuffer2[ind1b])
            {
                //                mag2 = mag1;
                //                ind2 = ind1;
                mag1b = fftMagnitudeBuffer2[indTempb];
                ind1b = indTempb;
                
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
    float x = 1;
    vDSP_vdbcon(fftMagnitudeBuffer2, 1, &x, fftMagnitudeBufferdB2, 1, kBufferLength2/2, 0);
    loudestShot2 = fftMagnitudeBufferdB2[ind1b];
    //NSLog(@"%.2f",loudestShot2);
    
    
    //NSLog(@"if statement");
    //NSLog(@"The loudest frequency is: %.2f Hz with magnitude %.2f dB",(ind1b*(audioManager2.samplingRate/kBufferLength2)),loudestShot2);
    //NSLog(@"%d     %.2f     %d",magValue-magTolerance,loudestShot2,magValue+magTolerance);
    //NSLog(@"%d     %.2f     %d",freqValue-freqTolerance,(ind1b*(audioManager2.samplingRate/kBufferLength2)),freqValue+freqTolerance);
    if((loudestShot2>_magVal-magTolerance && loudestShot2<_magVal+magTolerance) && ((ind1b*(audioManager2.samplingRate/kBufferLength2))>_freqVal-freqTolerance && (ind1b*(audioManager2.samplingRate/kBufferLength2))<_freqVal+freqTolerance) && isListening)
    {
        shotCounter++;
        NSLog(@"The frequency in range is: %.2f Hz with magnitude %.2f dB",(ind1b*(audioManager2.samplingRate/kBufferLength2)),loudestShot2);
        [self stopTimer:nil];
        splitMS[shotCounter-1]=milliseconds2;
        splitS[shotCounter-1]=seconds2;
        splitM[shotCounter-1]=minutes2;
        splitMSTotal += milliseconds2;
        splitSTotal += seconds2;
        splitMTotal += minutes2;
        timerLabel2.text = [NSString stringWithFormat:@"00.000"];
        minutes2 = 0;
        seconds2 = 0;
        milliseconds2 = 0;
        [self startTimerMethod];
        //set labels for 12 times
        if(shotCounter==1)
        {
            if(splitMS[shotCounter-1]<10)
                split1.text = [NSString stringWithFormat:@"%d.00%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else if(splitMS[shotCounter-1]<100)
                split1.text = [NSString stringWithFormat:@"%d.0%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else
                split1.text = [NSString stringWithFormat:@"%d.%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
        }
        if(shotCounter==2)
        {
            if(splitMS[shotCounter-1]<10)
                split2.text = [NSString stringWithFormat:@"%d.00%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else if(splitMS[shotCounter-1]<100)
                split2.text = [NSString stringWithFormat:@"%d.0%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else
                split2.text = [NSString stringWithFormat:@"%d.%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
        }
        if(shotCounter==3)
        {
            if(splitMS[shotCounter-1]<10)
                split3.text = [NSString stringWithFormat:@"%d.00%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else if(splitMS[shotCounter-1]<100)
                split3.text = [NSString stringWithFormat:@"%d.0%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else
                split3.text = [NSString stringWithFormat:@"%d.%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
        }
        if(shotCounter==4)
        {
            if(splitMS[shotCounter-1]<10)
                split4.text = [NSString stringWithFormat:@"%d.00%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else if(splitMS[shotCounter-1]<100)
                split4.text = [NSString stringWithFormat:@"%d.0%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else
                split4.text = [NSString stringWithFormat:@"%d.%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
        }
        if(shotCounter==5)
        {
            if(splitMS[shotCounter-1]<10)
                split5.text = [NSString stringWithFormat:@"%d.00%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else if(splitMS[shotCounter-1]<100)
                split5.text = [NSString stringWithFormat:@"%d.0%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else
                split5.text = [NSString stringWithFormat:@"%d.%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
        }
        if(shotCounter==6)
        {
            if(splitMS[shotCounter-1]<10)
                split6.text = [NSString stringWithFormat:@"%d.00%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else if(splitMS[shotCounter-1]<100)
                split6.text = [NSString stringWithFormat:@"%d.0%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else
                split6.text = [NSString stringWithFormat:@"%d.%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
        }
        if(shotCounter==7)
        {
            if(splitMS[shotCounter-1]<10)
                split7.text = [NSString stringWithFormat:@"%d.00%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else if(splitMS[shotCounter-1]<100)
                split7.text = [NSString stringWithFormat:@"%d.0%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else
                split7.text = [NSString stringWithFormat:@"%d.%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
        }
        if(shotCounter==8)
        {
            if(splitMS[shotCounter-1]<10)
                split8.text = [NSString stringWithFormat:@"%d.00%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else if(splitMS[shotCounter-1]<100)
                split8.text = [NSString stringWithFormat:@"%d.0%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else
                split8.text = [NSString stringWithFormat:@"%d.%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
        }
        if(shotCounter==9)
        {
            if(splitMS[shotCounter-1]<10)
                split9.text = [NSString stringWithFormat:@"%d.00%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else if(splitMS[shotCounter-1]<100)
                split9.text = [NSString stringWithFormat:@"%d.0%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else
                split9.text = [NSString stringWithFormat:@"%d.%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
        }
        if(shotCounter==10)
        {
            if(splitMS[shotCounter-1]<10)
                split10.text = [NSString stringWithFormat:@"%d.00%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else if(splitMS[shotCounter-1]<100)
                split10.text = [NSString stringWithFormat:@"%d.0%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else
                split10.text = [NSString stringWithFormat:@"%d.%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
        }
        if(shotCounter==11)
        {
            if(splitMS[shotCounter-1]<10)
                split11.text = [NSString stringWithFormat:@"%d.00%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else if(splitMS[shotCounter-1]<100)
                split11.text = [NSString stringWithFormat:@"%d.0%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else
                split11.text = [NSString stringWithFormat:@"%d.%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
        }
        if(shotCounter==12)
        {
            if(splitMS[shotCounter-1]<10)
                split12.text = [NSString stringWithFormat:@"%d.00%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else if(splitMS[shotCounter-1]<100)
                split12.text = [NSString stringWithFormat:@"%d.0%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
            else
                split12.text = [NSString stringWithFormat:@"%d.%d",splitS[shotCounter-1],splitMS[shotCounter-1]];
        }
        NSLog(@"Shot %d recorded with %d seconds and %d milliseconds",shotCounter,splitS[shotCounter-1],splitMS[shotCounter-1]);
        /*if(splitMSTotal >= 1000)
         {
         splitSTotal+=1;
         splitMSTotal-=1000;
         }
         if(splitSTotal >= 60)
         {
         splitMTotal+=1;
         splitSTotal-=60;
         }
         splitTotal.text = [NSString stringWithFormat:@"%d:%d.%d",splitMTotal,splitSTotal,splitMSTotal];*/
        [NSThread sleepForTimeInterval:0.250];//debounce... ignore next tenth
    }
    if(shotCounter==12)
    {
        isAdding = true;
        [self stopTimer:nil];
    }
    
    
    
    /*if(loudestShot2 > 20.0)
     {
     NSLog(@"The loudest frequency is: %.2f Hz with magnitude %.2f dB",(ind1b*(audioManager2.samplingRate/kBufferLength2)),loudestShot2);
     //        _freqLabel.text = [NSString stringWithFormat:@"%.2f Hz",ind1*(audioManager2.samplingRate/kBufferLength2)];
     //        _magLabel.text = [NSString stringWithFormat:@"%.2f dB",loudestShot2];
     //_firstValue.text = [NSString stringWithFormat:@"%.2f",ind1*(audioManager.samplingRate/kBufferLength)];
     
     //NSLog(@"The loudest frequency is: %.2f dB",magTemp);
     //make a label to display on screen the loudest magnitude
     
     //        NSLog(@"The second loudest frequency is: %.2f Hz",(ind2*(audioManager.samplingRate/kBufferLength)));
     //        _secondValue.text = [NSString stringWithFormat:@"%.2f",ind2*(audioManager.samplingRate/kBufferLength)];
     }*/
    
    // plot the FFT
    graphHelper2->setGraphData(1,fftMagnitudeBuffer2,kBufferLength2/2,sqrt(kBufferLength2)); // set graph channel
    
    graphHelper2->update(); // update the graph
}


#pragma mark - status bar
-(BOOL)prefersStatusBarHidden{
    return YES;
}



//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end
