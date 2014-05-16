//
//  ViewController.m
//  FlickrRocket
//
//  Created by Hunter Houston on 3/18/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loadingPicture.hidesWhenStopped = YES;
    _titleArray = [[NSMutableArray alloc] init];
    _photoURLArray = [[NSMutableArray alloc] init];
    _imageQueue = [[NSOperationQueue alloc]init];
    _dictionary = [[NSDictionary alloc]init];
    _photos = [[NSArray alloc]init];
    _imageIndex = 0;
    _photoCounter = 0;

    [self checkNetwork];

}

- (void)checkNetwork {

    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];

    if (internetStatus != NotReachable)
    {
        [self asyncRequest];
    }

    else
    {
        [self displayConnectionFail];
        
    }
}

- (void)displayConnectionFail {
    NSLog(@"FAIL");
    
   self.imageView.image = [UIImage imageNamed:@"nowifi.png"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"Unable to load pictures." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}


- (void)asyncRequest {

    NSString *strURL = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?format=json&sort=random&method=flickr.photos.search&tags=rocket&tag_mode=all&api_key=0e2b6aaf8a6901c264acb91f151a3350&nojsoncallback=1"];

    
    NSURL *URL = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    
    
    //start
    [self.loadingPicture startAnimating];
    
    [NSURLConnection sendAsynchronousRequest:request queue:_imageQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
    
    
        NSError *error;
        _dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        _photos = [[_dictionary objectForKey:@"photos"] objectForKey:@"photo"];
        
        for(NSDictionary *photo in _photos) {
            //NSLog(@"count: %ld", (long)_photoCounter++);
            
            NSString *title = [photo objectForKey:@"title"];
            [_titleArray addObject:(title.length > 0 ? title : @"Untitled")];
            
            NSString *photoURL = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server" ], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
            
            NSLog(@"%@",photoURL);
            
            [_photoURLArray addObject:[NSURL URLWithString:photoURL]];
            
            //NSLog(@"TITLE: %@",title);
            //NSLog(@"PHOTO: %@",photo);
        }

   
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self showPic:(int)_imageIndex];
            
            self.imageView.userInteractionEnabled = YES;
            
            UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
            swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
            [self.imageView addGestureRecognizer:swipeleft];
            
            UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
            swiperight.direction=UISwipeGestureRecognizerDirectionRight;
            [self.imageView addGestureRecognizer:swiperight];
    
            [self.loadingPicture stopAnimating];
            //stop
        });
        
    }];
}

- (void)swipeRight:(UISwipeGestureRecognizer*)gestureRecognizer {

    if (_imageIndex == [_titleArray count] - 1) {
        _imageIndex = 0;
        NSNumber *number = [NSNumber numberWithInt:_imageIndex+1];
        [_picCounterLabel setText:[number stringValue]];
    } else {
        _imageIndex++;
        NSNumber *number = [NSNumber numberWithInt:_imageIndex+1];
        [_picCounterLabel setText:[number stringValue]];
    }
    NSLog(@"right swipe count: %d", _imageIndex);
    
    [self showPic:(int)_imageIndex];
    
}

- (void)swipeLeft:(UISwipeGestureRecognizer*)gestureRecognizer {
    
    if (_imageIndex == 0) {
        _imageIndex = (int)[_titleArray count] - 1;
        NSNumber *number = [NSNumber numberWithInt:_imageIndex+1];
        [_picCounterLabel setText:[number stringValue]];
    } else {
        _imageIndex--;
        NSNumber *number = [NSNumber numberWithInt:_imageIndex+1];
        [_picCounterLabel setText:[number stringValue]];
    }
    NSLog(@"left swipe count: %d", _imageIndex);
    [self showPic:(int)_imageIndex];

}

- (void)showPic:(int)index{
    //NSLog(@"INDEX: %d",index);

    NSString *title = [_titleArray objectAtIndex:index];
    self.titleLabel.text = title;
    
    NSData *imageData = [NSData dataWithContentsOfURL:[_photoURLArray objectAtIndex:index]];
    UIImage *newImage = [UIImage imageWithData:imageData];
    
    [UIView transitionWithView:self.view
                          duration:0.4f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.imageView.image = newImage;
                        } completion:NULL];



}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
