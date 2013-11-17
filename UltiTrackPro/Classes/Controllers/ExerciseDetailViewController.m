//
//  ExerciseDetailViewController.m
//  UltiTrackPro
//
//  Created by James Montgomery on 8/13/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "ExerciseDetailViewController.h"
#import "DataHelper.h"
#import "Exercise.h"
#import "Stat.h"
#import "Day.h"
#import "DaysTableViewController.h"
#import "HistoryTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Band.h"
#import "AdViewController.h"

@interface ExerciseDetailViewController ()
@property (nonatomic, strong) Exercise *currentExercise;
@property (nonatomic, assign) NSInteger indexCounter;
@property (nonatomic, strong) UIDatePicker *picker;
@property (nonatomic, assign) BOOL exerciseFlag;
@property (nonatomic, strong) NSTimer *stopWatchTimer;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) BOOL timerRunning;
@property (nonatomic, assign) NSTimeInterval timePassed;
@property (nonatomic, strong) Stat *lastStat;
@property (nonatomic, copy) NSArray *bandsArray;
@property (nonatomic, assign) NSInteger lbsOrKgPreference;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) Band *bandForStat;
@property (nonatomic, copy) NSString *imageNameForBand;
@end

@implementation ExerciseDetailViewController
@synthesize exerciseCounterButton;
@synthesize slideView;
@synthesize nextButton;
@synthesize previousButton;
@synthesize weightTextField;
@synthesize repsTextField;
@synthesize dateTextField;
@synthesize notesTextView;
@synthesize timeView;
@synthesize startButton;
@synthesize resetButton;
@synthesize stopButton;
@synthesize timerLabel;

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

    // Do any additional setup after loading the view
    self.currentExercise = [self.exercises objectAtIndex:self.indexCounter];
    //Navbar Title
    self.title = self.currentExercise.exerciseName;
    //Title for 00 of 99 button]
    self.exerciseCounterButton.title = [NSString stringWithFormat:@"%d of %d", (self.indexCounter + 1), [self.exercises count]];

    //Offload some heavy lifting
    [self performSelectorInBackground:@selector(initialSetup) withObject:nil];

    //Default Date for cycling through dates
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateTextField.text = [dateFormatter stringFromDate:[NSDate date]];

    //Set the Reps UITextField properties
    self.notesTextView.layer.borderWidth = 1.0f;
    self.notesTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.notesTextView.delegate = self;
    self.notesTextView.returnKeyType = UIReturnKeyDone;
    self.notesTextView.textColor = [UIColor darkGrayColor];

    //Set the time UITextField properties
    self.timeNotesTextView.layer.borderWidth = 1.0f;
    self.timeNotesTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.timeNotesTextView.delegate = self;
    self.timeNotesTextView.returnKeyType = UIReturnKeyDone;
    self.timeNotesTextView.textColor = [UIColor darkGrayColor];

    //Initial View hiding based upon rep or time
    if (self.currentExercise.exerciseType == 1)
    {
        self.timeView.hidden = YES;
    }
    else
    {
        self.timeView.hidden = NO;
    }

    self.stopButton.hidden = YES;
    self.stopButton.alpha = 0.0;


    //Create the adView and ad setup
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    _bannerView.adUnitID = @"ca-app-pub-2915168992422718/5093482585";
    _bannerView.rootViewController = self;
    _bannerView.delegate = self;
    [self refreshAd];
    [self.adBannerView addSubview:_bannerView];
    _bannerView.hidden = YES;

    //background image
    self.timeView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    self.slideView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    self.repsTextField.backgroundColor = [UIColor clearColor];
    self.weightTextField.backgroundColor = [UIColor clearColor];
    self.dateTextField.backgroundColor = [UIColor clearColor];
    self.notesTextView.backgroundColor = [UIColor colorWithRed:218.0f / 255.0f green:218.0f / 255.0f blue:218.0f / 255.0f alpha:.5];
    self.timeNotesTextView.backgroundColor = [UIColor colorWithRed:218.0f / 255.0f green:218.0f / 255.0f blue:218.0f / 255.0f alpha:.5];

    //View setup
    if (self.currentExercise.exerciseType == 2)
    {
        self.previousButton.enabled = NO;
    }

    [self.view bringSubviewToFront:(self.currentExercise.exerciseType == 2) ? self.timeView:self.slideView ];


    //UIDatePicker Configuration
    self.picker = [[UIDatePicker alloc] init];
    self.picker.datePickerMode = UIDatePickerModeDate;
    [self.picker setDate:[NSDate date]];
    self.dateTextField.inputView = self.picker;
    
    //Swipe Gestures
    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:swipeLeftGestureRecognizer];
    [self.view addGestureRecognizer:swipeRightGestureRecognizer];
    
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //get the lbs or kg pref
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    self.lbsOrKgPreference = standardUserDefaults ? [[standardUserDefaults valueForKey:@"weight_preference"] integerValue] : 0;
    
    //Stop screen dimming (re-enabled in viewWillDissappear)
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //Re-enable the screen timeout that was disabled in viewWillAppear
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}
- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewDidUnload
{
    self.exercises = nil;
    self.stopWatchTimer = nil;
    self.startDate = nil;
    [self setExerciseCounterButton:nil];
    [self setSlideView:nil];
    [self setNextButton:nil];
    [self setPreviousButton:nil];
    [self setWeightTextField:nil];
    [self setRepsTextField:nil];
    [self setDateTextField:nil];
    [self setPicker:nil];
    [self setNotesTextView:nil];
    [self setTimeView:nil];
    [self setStartButton:nil];
    [self setResetButton:nil];
    [self setStopButton:nil];
    [self setTimerLabel:nil];
    _bannerView = nil;
    [self setAdBannerView:nil];
    [self setTimeNotesTextView:nil];
    [self setBandsButton:nil];
    [self setBandsArray:nil];
    [self setActionSheet:nil];
    [self setRepStepper:nil];
    [self setWeightStepper:nil];
    [super viewDidUnload];
}


- (void) refreshAd
{
    GADRequest *request = [[GADRequest alloc] init];
    [request addKeyword:@"health"];
    [request addKeyword:@"fitness"];
    [request addKeyword:@"exercise"];
    [request addKeyword:@"weight loss"];
    request.testing = YES;
    request.testDevices = @[GAD_SIMULATOR_ID];
    [_bannerView loadRequest:request];
}


- (IBAction) previousExerciseButton:(UIBarButtonItem *)sender
{
    if (self.indexCounter >= 1)
    {
        self.indexCounter--; //decrement
        //set current exercise to the counter
        self.currentExercise = [self.exercises objectAtIndex:self.indexCounter];
        //update the title and counterButton text
        self.title = self.currentExercise.exerciseName;
        self.exerciseCounterButton.title = [NSString stringWithFormat:@"%d of %d", (self.indexCounter + 1), [self.exercises count]];
    }
    else     //you are at the first exercise, go to the last one
    {
        self.indexCounter = ([self.exercises count] - 1);
        //set current exercise to the counter
        self.currentExercise = [self.exercises objectAtIndex:self.indexCounter];
        //update the title and counterButton text
        self.title = self.currentExercise.exerciseName;
        self.exerciseCounterButton.title = [NSString stringWithFormat:@"%d of %d", (self.indexCounter + 1), [self.exercises count]];
    }

    //Get the stat object for the current exercise.
    //[self getLastStatForExercise:self.currentExercise];
    [self performSelectorInBackground:@selector(getLastStatForExercise:) withObject:self.currentExercise];

    //Determine if we are animaiting a slideview or timeview
    if (self.currentExercise.exerciseType == 1)
    {
        CATransition *transition = [CATransition animation];
        self.timeView.hidden = YES;
        self.slideView.hidden = NO;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        transition.delegate = self;
        [self.slideView.layer addAnimation:transition forKey:nil];
        self.nextButton.enabled = NO;
        self.previousButton.enabled = NO;

        [self resetUI];
    }
    else
    {
        CATransition *transition = [CATransition animation];
        self.slideView.hidden = YES;
        self.timeView.hidden = NO;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        transition.delegate = self;
        [self.timeView.layer addAnimation:transition forKey:nil];
        self.nextButton.enabled = NO;
        self.previousButton.enabled = NO;

        [self resetUI];
    }
}


- (IBAction) nextExerciseButton:(UIBarButtonItem *)sender
{
    if (self.indexCounter < [self.exercises count] - 1)
    {
        self.indexCounter++; //increment
        //save the exercise that is "leaving" the view
        [self saveExerciseStat];
        //set the current exercise based on counter
        self.currentExercise = [self.exercises objectAtIndex:self.indexCounter];
        //update the title and the counterbutton text
        self.title = self.currentExercise.exerciseName;
        self.exerciseCounterButton.title = [NSString stringWithFormat:@"%d of %d", (self.indexCounter + 1), [self.exercises count]];
        //[self getLastStatForExercise:self.currentExercise];
        [self performSelectorInBackground:@selector(getLastStatForExercise:) withObject:self.currentExercise];
    }
    else     //you're at the last exercise
    {
        [self saveExerciseStat];
        [self markDayComplete];
    }

    //Determine if we are animaiting a slideview or timeview
    if (self.currentExercise.exerciseType == 1)
    {
        CATransition *transition = [CATransition animation];
        self.timeView.hidden = YES;
        self.slideView.hidden = NO;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [self.slideView.layer addAnimation:transition forKey:nil];
        self.nextButton.enabled = NO;

        [self resetUI];
    }
    else
    {
        CATransition *transition = [CATransition animation];
        self.slideView.hidden = YES;
        self.timeView.hidden = NO;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [self.timeView.layer addAnimation:transition forKey:nil];
        self.nextButton.enabled = NO;

        [self resetUI];
    }
}


- (void) toolbarAction:(UIBarButtonItem *)sender
{
    if (self.dateTextField.isEditing)
    {
        if (sender.tag == 101)
        {
            [self.dateTextField resignFirstResponder];
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterShortStyle;
            self.dateTextField.text = [dateFormatter stringFromDate:self.picker.date];
            [self.dateTextField resignFirstResponder];
        }
    }
    else if (self.weightTextField.isEditing)
    {
        [self.weightTextField resignFirstResponder];
    }
    else
    {
        [self.repsTextField resignFirstResponder];
    }

    //Put it back how you found it if no changes were made.
    if (sender.tag == 101)
    {
        [self resetUI];
    }
}


- (IBAction) stepperValueChanged:(UIStepper *)sender
{
    if (sender.tag == 101)
    {
        NSInteger data = (NSInteger)self.repStepper.value;
        self.repsTextField.text = [NSString stringWithFormat:@"%d", data];
    }
    else
    {
        NSInteger data = (NSInteger)self.weightStepper.value;
        self.weightTextField.text = [NSString stringWithFormat:@"%d", data];
    }
}


- (void) resetUI
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateTextField.text = [dateFormatter stringFromDate:[NSDate date]];

    self.repsTextField.text = [NSString stringWithFormat:@"%d",self.lastStat.reps];
    self.weightTextField.text = [NSString stringWithFormat:@"%d", self.lastStat.weight];
    if (![self.lastStat.notes isEqualToString:@""])
    {
        if (self.currentExercise.exerciseType == 1)
        {
            self.notesTextView.text = self.lastStat.notes;
        }
        else
        {
            self.timeNotesTextView.text = self.lastStat.notes;
        }
    }
    else
    {
        self.timeNotesTextView.text = @"Notes";
        self.notesTextView.text = @"Notes";
    }

    //adjust the stepper with stat values
    self.repStepper.value = [self.repsTextField.text intValue];
    self.weightStepper.value = [self.weightTextField.text intValue];

    //refresh the ad if hidden
    if (_bannerView.hidden)
    {
        [self refreshAd];
    }

    //[self refreshAd];
}


#pragma mark CoreAnimation Delegate
- (void) animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    self.nextButton.enabled = YES;
    self.previousButton.enabled = YES;
}


#pragma mark UITextView Delegate
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if (textView.tag == 100)
        {
            [self.notesTextView resignFirstResponder];
            self.notesTextView.textColor = [UIColor darkGrayColor];
            return NO;
        }
        else
        {
            [self.timeNotesTextView resignFirstResponder];
            self.timeNotesTextView.textColor = [UIColor darkGrayColor];
            return NO;
        }
    }

    return YES;
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.tag == 111)
    {
        [self performSegueWithIdentifier:@"NotesModal" sender:textView];
    }
    else
    {
        [self performSegueWithIdentifier:@"NotesModal" sender:nil];
    }

    return NO;
}


#pragma mark Stopawatch methods
- (IBAction) startButtonPressed
{
    if (!_timerRunning)
    {
        self.startDate = [NSDate date];
        self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 10.0
                                                               target:self
                                                             selector:@selector(updateTimer)
                                                             userInfo:nil
                                                              repeats:YES];
    }

    //UI Stuff
    self.stopButton.hidden = NO;

    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveLinear animations: ^{
         self.stopButton.alpha = 1.0;
         self.startButton.alpha = 0.0;
         self.resetButton.alpha = 0.0;
     }
                     completion: ^(BOOL finished) {
         self.startButton.hidden = YES;
         self.resetButton.hidden = YES;
     }
    ];
}
- (IBAction) resetButtonPressed
{
    self.timerLabel.text = @"00:00:00";
    self.timerRunning = NO;
    self.timePassed = 0;
}


- (IBAction) stopButtonPressed:(id)sender
{
    [self.stopWatchTimer invalidate];

    [self updateTimer];
    self.stopWatchTimer = nil;
    self.timePassed += [[NSDate date] timeIntervalSinceDate:self.startDate];

    //UI Stuff
    self.startButton.hidden = NO;
    self.resetButton.hidden = NO;

    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveLinear animations: ^{
         self.startButton.alpha = 1.0;
         self.resetButton.alpha = 1.0;
         self.stopButton.alpha = 0.0;
     }
                     completion: ^(BOOL finished) {
         self.stopButton.hidden = YES;
     }
    ];
}

#pragma mark Band Selection
- (void) updateTimer
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = ([currentDate timeIntervalSinceDate:self.startDate] + self.timePassed);
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    self.timerLabel.text = [dateFormatter stringFromDate:timerDate];
    dateFormatter = nil;
}


#pragma mark Offloading setup
- (void) initialSetup
{
    //Date Toolbar UIBarButtonItem configuration
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(toolbarAction:)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(toolbarAction:)];
    cancelButton.tag = 101;

    //Toolbar configuration
    UIToolbar *inputAccessoryView = [[UIToolbar alloc] init];
    inputAccessoryView.barStyle = UIBarStyleDefault;
    inputAccessoryView.translucent = YES;
    inputAccessoryView.tintColor = nil;
    [inputAccessoryView sizeToFit];
    [inputAccessoryView setItems:[NSArray arrayWithObjects:cancelButton, spacer, doneButton, nil]];

    //textfield setup
    self.dateTextField.inputAccessoryView = inputAccessoryView;
    self.repsTextField.inputAccessoryView = inputAccessoryView;
    self.weightTextField.inputAccessoryView = inputAccessoryView;

    //get stat for last exercise
    [self getLastStatForExercise:self.currentExercise];
}


#pragma mark save user stat for current exercise
- (void) saveExerciseStat
{
    Stat *stat = [[Stat alloc] init];
    stat.userID = 1;
    stat.exerID = self.currentExercise.exerciseID;
    stat.weight = (self.bandForStat.weight == 0) ? [self.weightTextField.text intValue] : self.bandForStat.weight;
    stat.reps = [self.repsTextField.text intValue];
    stat.bandID = self.bandForStat.colorID; //actually saving the colorID for now to accomodate the history view.
    stat.time = self.timerLabel.text;
    stat.date = self.dateTextField.text;
    if (self.currentExercise.exerciseType == 1)
    {
        stat.notes = ([self.notesTextView.text isEqualToString:@"Notes"]) ? @"" : self.notesTextView.text;
    }
    else
    {
        stat.notes = ([self.timeNotesTextView.text isEqualToString:@"Notes"]) ? @"" : self.timeNotesTextView.text;
    }

    [self commitStat:stat];
}


- (void) commitStat:(Stat *)stat
{
    [[DataHelper sharedManager] saveStat:stat];
}


#pragma mark get lastStat
- (void) getLastStatForExercise:(Exercise *)exercise
{
    Stat *stat = [[DataHelper sharedManager] statForLastExercise:self.currentExercise];
    [self performSelectorOnMainThread:@selector(updateLastStat:) withObject:stat waitUntilDone:NO];
}


- (void) updateLastStat:(Stat *)stat   //updates the UI with your last stat
{
    self.lastStat = stat;
    [self resetUI];
}


- (void) markDayComplete
{
    [[DataHelper sharedManager] markDayCompleteOrSkipped:0 forDay:self.day];
    DaysTableViewController *controller = [[self.navigationController viewControllers] objectAtIndex:1];
    controller.tableDataSource = [[DataHelper sharedManager] daysForProgram:self.programID];
    //testing fullpage ad
    //[self.navigationController popViewControllerAnimated:YES];
    AdViewController * adView = [self.storyboard instantiateViewControllerWithIdentifier:@"fullPageAd"];
    adView.completionMessage = [NSString stringWithFormat:@"Day %d: %@ Completed!", self.day.dayNumber, self.day.dayName];
    
    [self.navigationController pushViewController:adView animated:YES];
    
    
}


#pragma mark GADBannerView Delegate
- (void) adViewDidReceiveAd:(GADBannerView *)bannerView
{
    //Bring the ad to the front if it is not there
    if ([[self.view subviews] lastObject] != self.adBannerView)
    {
        [self.view bringSubviewToFront:self.adBannerView];
    }

    _bannerView.hidden = NO;
}


#pragma mark AdMob
- (void)                 adView:(GADBannerView *)bannerView
    didFailToReceiveAdWithError:(GADRequestError *)error
{
}


- (IBAction) historyButton:(id)sender
{
}


- (IBAction) chooseBands:(id)sender
{
    //settings Dictionary
    NSMutableDictionary *settingsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:[self dataFilePath]];

    //Get bands for the picker datasource
    self.bandsArray = [[DataHelper sharedManager] bandsForSet:[[settingsDict valueForKey:@"activeBandSet"] intValue]];

    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"Done"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];

    [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];

    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);

    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;

    [self.actionSheet addSubview:pickerView];

    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    //closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
    //Turning off the close button.
    //[self.actionSheet addSubview:closeButton];

    [self.actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];

    [self.actionSheet setBounds:CGRectMake(0, 0, 320, 485)];

    [pickerView selectRow:self.bandForStat.bandID inComponent:0 animated:YES];
}


//These fire from textFields to set stepper values
- (IBAction) repsEditingDidEnd:(id)sender
{
    self.repStepper.value = [self.repsTextField.text intValue];
}


- (IBAction) weightEditingDidEnd:(id)sender
{
    self.weightStepper.value = [self.weightTextField.text intValue];
}


- (void) dismissActionSheet
{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"history_segue"] )
    {
        UINavigationController *navigationController = segue.destinationViewController;
        HistoryTableViewController *controller = (HistoryTableViewController *)navigationController.topViewController;
        controller.dataSource = [[DataHelper sharedManager] historyForExerciseID:self.currentExercise.exerciseID];
        controller.title = self.currentExercise.exerciseName;
        controller.exerciseType = self.currentExercise.exerciseType;
    }
    else
    {
        NotesViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        UITextView *tv = (UITextView *)sender;
        if (tv.tag == 111)
        {
            vc.whoSentMe = 0;
            vc.textFromParent = ([self.notesTextView.text isEqualToString:@"Notes"]) ? @"" : self.notesTextView.text;
        }
        else
        {
            vc.whoSentMe = 1;
            vc.textFromParent = ([self.timeNotesTextView.text isEqualToString:@"Notes"]) ? @"" : self.timeNotesTextView.text;
        }
    }
}


#pragma mark UIPickerViewDataSource
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.bandsArray count];
}


#pragma mark UIPickerView Delegate
- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //get the band from the bandArray
    Band *band = [self.bandsArray objectAtIndex:row];

    UILabel *testRow = view ? (UILabel *)view : [[UILabel alloc] initWithFrame:CGRectMake(0,0, 280, 40)];
    testRow.font = [UIFont boldSystemFontOfSize:25.0f];
    testRow.textAlignment = NSTextAlignmentCenter;
    testRow.text = (band.weight == 0) ? testRow.text = @"None" : (self.lbsOrKgPreference != 0) ? [NSString stringWithFormat:@"%.1f Kg.",band.weight / 2.2f ] : [NSString stringWithFormat:@"%d Lbs.", band.weight];
    testRow.backgroundColor = [self colorForBandColorID:band.colorID];
    (band.colorID == 5 || band.colorID == 6) ? testRow.textColor = [UIColor lightGrayColor] : nil;
    testRow.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    testRow.layer.borderWidth = 1.0f;
    [testRow.layer setMasksToBounds:YES];
    [testRow.layer setCornerRadius:8.0f];

    return testRow;
}


- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.bandForStat = [self.bandsArray objectAtIndex:row];
    if (self.bandForStat.weight != 0)
    {
        self.weightTextField.text = [NSString stringWithFormat:@"%d", self.bandForStat.weight];
        self.bandsButton.backgroundColor = [self colorForBandColorID:self.bandForStat.colorID];
        
        [self.bandsButton setTitleColor:((self.bandForStat.colorID == 5 || self.bandForStat.colorID == 6) ? [UIColor lightTextColor] : [UIColor darkTextColor]) forState:UIControlStateNormal];
    }
    
    else
    {
        self.weightTextField.text = @"0";
        self.bandsButton.backgroundColor = [UIColor lightGrayColor];
        [self.bandsButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    }
}


#pragma mark FilePath
- (NSString *) documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    return documentsDirectory;
}


- (NSString *) dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"ProgramSettings.plist"];
}


//GetColorMethod called by the picker delegate
- (UIColor *) colorForBandColorID:(NSInteger)bandColorID
{
    switch (bandColorID)
    {
        case 0 : //nothing/clear
            return [UIColor clearColor];
            break;
        case 1: //255-192-203	Pink
            return [UIColor colorWithRed:255.0f / 255.0f green:192.0f / 255.0f blue:203.0f / 255.0f alpha:1.0f];
            break;
        case 2: //magenta
            return [UIColor magentaColor];
            break;
        case 3: //red
            return [UIColor redColor];
            break;
        case 4: //green
            return [UIColor greenColor];
            break;
        case 5: //blue
            return [UIColor blueColor];
            break;
        case 6: //black
            return [UIColor blackColor];
            break;
        case 7: //orange
            return [UIColor orangeColor];
            break;
        case 8: //yellow
            return [UIColor yellowColor];
            break;
        case 9: //purple
            return [UIColor purpleColor];
            break;
        default:
            return [UIColor whiteColor];
            break;
    } /* switch */
}


- (NSString *) imageNameForBandColorID:(NSInteger)bandColorID
{
    switch (bandColorID)
    {
        case 0: //nothing/clear
            return @"metal";
            break;
        case 1: //255-192-203	Pink
            return @"pink";
            break;
        case 2: //magenta
            return @"magenta";
            break;
        case 3: //red
            return @"red";
            break;
        case 4: //green
            return @"green";
            break;
        case 5: //blue
            return @"blue";
            break;
        case 6: //black
            return @"black";
            break;
        case 7: //orange
            return @"orange";
            break;
        case 8: //yellow
            return @"yellow";
            break;
        case 9: //purple
            return @"purple";
            break;
        default:
            return @"white";
            break;
    } /* switch */
}


#pragma mark NotesViewController Delegate
- (void) notesTextViewDidFinishEditingText:(NSString *)text forSender:(NSInteger)myInt
{
    if (myInt == 0)   //reps textView
    {
        self.notesTextView.text = text;
    }
    else
    {
        self.timeNotesTextView.text = text;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Swipe Gestures
- (void)swipeRight {
    if (self.previousButton.enabled) {
        [self previousExerciseButton:nil];
    }
    
}

- (void)swipeLeft {
    [self nextExerciseButton:nil];
}
@end
