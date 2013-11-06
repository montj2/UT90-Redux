//
//  NotesViewController.m
//  UltiTrack90
//
//  Created by James Montgomery on 9/30/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "NotesViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ExerciseDetailViewController.h"

@interface NotesViewController ()

@end

@implementation NotesViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }

    return self;
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //Textview Toolbar UIBarButtonItem configuration
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(toolbarAction:)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(toolbarAction:)];
    cancelButton.tag = 109;

    //Toolbar configuration
    UIToolbar *inputAccessoryView = [[UIToolbar alloc] init];
    inputAccessoryView.barStyle = UIBarStyleBlack;
    inputAccessoryView.translucent = YES;
    inputAccessoryView.tintColor = nil;
    [inputAccessoryView sizeToFit];
    [inputAccessoryView setItems:[NSArray arrayWithObjects:cancelButton, spacer, doneButton, nil]];

    //Textview configuration
    self.notesTextView.inputAccessoryView = inputAccessoryView;
    [self.notesTextView becomeFirstResponder];
    self.notesTextView.layer.borderWidth = 1.0f;
    self.notesTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //self.notesTextView.delegate = self;
    self.notesTextView.textColor = [UIColor darkGrayColor];
    self.notesTextView.backgroundColor = [UIColor colorWithRed:218.0f / 255.0f green:218.0f / 255.0f blue:218.0f / 255.0f alpha:.5];

    //Background Configuration
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];

    self.notesTextView.text = self.textFromParent;
}


- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) toolbarAction:(UIBarButtonItem *)sender
{
    if (sender.tag == 109)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"What?");
    }
    else
    {
        [self.delegate notesTextViewDidFinishEditingText:self.notesTextView.text forSender:self.whoSentMe];
        NSLog(@"Im getting called and here is what you sent %@", self.notesTextView.text);
    }
}


@end
