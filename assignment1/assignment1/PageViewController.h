//
//  PageViewController.h
//  assignment1
//
//  Created by Hunter Houston on 2/5/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageDataSourceViewController.h"

@interface PageViewController : UIViewController <UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@end
