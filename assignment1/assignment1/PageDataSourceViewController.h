//
//  PageDataSourceViewController.h
//  assignment1
//
//  Created by Hunter Houston on 2/5/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageDataSourceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property NSUInteger pageIndex;
@property NSString *titleText;
-(IBAction)changeSeg;
@end
