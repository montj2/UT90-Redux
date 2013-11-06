//
//  ExerciseDetailViewController.h
//  UltiTrackPro
//
//  Created by James Montgomery on 8/13/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "NotesViewController.h"

@class Day;

@interface ExerciseDetailViewController : UIViewController <UITextViewDelegate, GADBannerViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, NotesViewControllerDelegate> {
    GADBannerView *_bannerView;
}
@property (nonatomic, copy) NSArray *exercises;
@property (nonatomic, strong) Day *day; //this is used to reference the rowID of the day when marking complete
@property (nonatomic, assign) NSInteger programID;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exerciseCounterButton;
@property (weak, nonatomic) IBOutlet UIView *slideView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *repsTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIView *adBannerView;
@property (weak, nonatomic) IBOutlet UITextView *timeNotesTextView;
@property (weak, nonatomic) IBOutlet UIButton *bandsButton;
@property (weak, nonatomic) IBOutlet UIStepper *repStepper;
@property (weak, nonatomic) IBOutlet UIStepper *weightStepper;

- (IBAction)historyButton:(id)sender;
- (IBAction)chooseBands:(id)sender;
- (IBAction)repsEditingDidEnd:(id)sender;
- (IBAction)weightEditingDidEnd:(id)sender;

@end
