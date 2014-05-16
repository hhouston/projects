//
//  PageDataSourceViewController.m
//  assignment1
//
//  Created by Hunter Houston on 2/5/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "PageDataSourceViewController.h"

@interface PageDataSourceViewController ()

@end

@implementation PageDataSourceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)changeSeg{
	if(_segControl.selectedSegmentIndex == 0){
        self.view.backgroundColor = [UIColor whiteColor];
	}
	if(_segControl.selectedSegmentIndex == 1){
        self.view.backgroundColor = [UIColor blackColor];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 300, 30)];
    pageLabel.text = self.titleText;
    pageLabel.textColor = [UIColor redColor];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:pageLabel];
    
    //self.pageLabel.text = self.titleText;

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
