//
//  ViewController.h
//  FlickrRocket
//
//  Created by Hunter Houston on 3/18/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class Reachability;

@interface ViewController : UIViewController
@property NSOperationQueue* imageQueue;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingPicture;
@property (weak, nonatomic) IBOutlet UILabel *totalPicLabel;
@property (weak, nonatomic) IBOutlet UILabel *picCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSDictionary *dictionary;
@property (strong, nonatomic) NSArray *photos;


@property (nonatomic, retain) NSMutableArray *titleArray;
@property (nonatomic, retain) NSMutableArray *photoURLArray;
@property (nonatomic) int imageIndex;
@property (nonatomic) NSInteger *photoCounter;
@property (nonatomic) int totalPics;

- (void)checkNetwork;



@end
