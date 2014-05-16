//
//  SliderViewController.m
//  assignment1
//
//  Created by CONNER KNUTSON on 2/6/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "SliderViewController.h"

@interface SliderViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slide;
- (IBAction)sliderValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *slideValue;
@property (weak, nonatomic) IBOutlet UILabel *slideValue2;
@property (strong, nonatomic) IBOutlet UISlider *slide2;

@end

@implementation SliderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect myFrame = CGRectMake(20.0f, 200.0f, 115.0f, 25.0f);
    self.slide2 = [[UISlider alloc] initWithFrame:myFrame];
    self.slide2.minimumValue = 0.0f;
    self.slide2.maximumValue = 10.0f;
    self.slide2.value = 0.0f;
    [self.slide2 setContinuous:false];
    [self.slide2 addTarget:self
                      action:@selector(sliderChange:)
            forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slide2];
    
}

- (void) sliderChange:(UISlider *)paramSender{
    _slideValue2.text = [NSString stringWithFormat:@"%d", (int)paramSender.value];
}

/*- (void)sliderChange:(id)send
{
    float value = [send floatValue];
    _slideValue2.text = [NSString stringWithFormat:@"%d", (int)value];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderValueChanged:(UISlider*)sender {
    _slideValue.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}
@end
