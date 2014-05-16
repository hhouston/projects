//
//  HELLOWORLD ViewController.m
//  assignment1
//
//  Created by Hunter Houston on 1/27/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *myLabelFromStoryboard;
@end

@implementation ViewController

- (IBAction)changeLabelToHelloWorld:(UIButton *)sender {
    self.myLabelFromStoryboard.text = @"Hello World!";
    [_changeLabel setHidden:YES];
}

- (IBAction)changeBackgroundColorToBlue:(UIButton*)sender {
    self.view.backgroundColor = [UIColor blueColor];
}

- (IBAction)changeBackgroundColorToGreen:(UIButton*)sender {
    self.view.backgroundColor = [UIColor greenColor];
    
}

- (IBAction)changeBackgroundColorToRed:(UIButton*)sender {
    self.view.backgroundColor = [UIColor redColor];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _blueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_blueButton addTarget:self
                    action:@selector(changeBackgroundColorToBlue:)
          forControlEvents:UIControlEventTouchDown];
    [_blueButton setTitle:@"Blue" forState:UIControlStateNormal];
    //blueButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    //blueButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_blueButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_blueButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_blueButton sizeToFit];
    [self.view addSubview:_blueButton];
    
    
    _greenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_greenButton addTarget:self
                     action:@selector(changeBackgroundColorToGreen:)
           forControlEvents:UIControlEventTouchDown];
    [_greenButton setTitle:@"Green" forState:UIControlStateNormal];
    //greenButton.frame = CGRectMake(80.0, 240.0, 160.0, 40.0);
    [_greenButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_greenButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_greenButton sizeToFit];
    [self.view addSubview:_greenButton];
    
    
    _redButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_redButton addTarget:self
                   action:@selector(changeBackgroundColorToRed:)
         forControlEvents:UIControlEventTouchDown];
    [_redButton setTitle:@"Red" forState:UIControlStateNormal];
    //redButton.frame = CGRectMake(80.0, 270.0, 160.0, 40.0);
    [_redButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_redButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_redButton sizeToFit];
    [self.view addSubview:_redButton];
    
    
    // dictionary name spacing, variables halfwidth and halfheight, values of variables to the right
//    NSDictionary *spacing = @{
//                              @"halfwidth" : @(self.view.frame.size.width/2), // @() contains NSNumber
//                              @"eigthheight" : @(self.view.frame.size.height/8),
//                              @"bottom" : @(self.view.frame.size.height-50)
//                              };
//    
//    [self.view addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_redButton]-eigthheight-|"
//                                             options:0 // vertically aligning buttons
//                                             metrics:spacing
//                                               views:NSDictionaryOfVariableBindings(_redButton)]];
//    
//    [self.view addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_redButton(==_blueButton)]-[_greenButton(==_blueButton)]-[_blueButton]-|"
//                                             options:NSLayoutFormatAlignAllCenterY
//                                             metrics:spacing
//                                               views:NSDictionaryOfVariableBindings(_redButton, _greenButton, _blueButton)]];
//    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
