//
//  ImageViewController.m
//  assignment1
//
//  Created by Hunter Houston on 1/29/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "CoreViewController.h"
#import "Record.h"
#import "AppDelegate.h"

@interface CoreViewController () <UITextFieldDelegate>
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end

@implementation CoreViewController
- (IBAction)viewNames:(id)sender {
}
- (IBAction)addNames:(id)sender {
    //  1
    Record * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Record"
                                                      inManagedObjectContext:self.managedObjectContext];
    //  2
    newEntry.firstName = self.nameField.text;

    //  3
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    //  4
    self.nameField.text = @"";
    //  5
    [self.view endEditing:YES];
}

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
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.nameField]) {
        [self.nameField becomeFirstResponder];
    }
        [self addNames:Nil];
    return YES;
}
@end
