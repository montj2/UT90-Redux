//
//  DaysTableViewController.m
//  UltiTrackPro
//
//  Created by James Montgomery on 7/26/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "DaysTableViewController.h"
#import "Day.h"
#import "DataHelper.h"
#import "ExerciseDetailViewController.h"

@interface DaysTableViewController () <UIActionSheetDelegate>
{
    NSMutableDictionary *settingsDict;
    NSInteger lastDayCompleted;
}

@property (nonatomic, weak) UITableViewCell *aCell;
@property (nonatomic, weak) Day *day;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, copy) NSIndexPath *tempIndexPath;
@property (nonatomic, assign) NSInteger updateStatusNumber;

@end

@implementation DaysTableViewController

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


- (id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }

    return self;
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    //set the navcontroller back button title
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //Create the longpress gesture recognizer to trigger actionsheet
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    //set the press duration in seconds
    lpgr.minimumPressDuration = 1.0;
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];

    //Get the program preference from ProgramSettings.plist
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[self dataFilePath]])
    {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"ProgramSettings" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:[self dataFilePath] error:nil];
    }

    //Set the program preferences property to the contents of the ProgramSettings plist
    settingsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:[self dataFilePath]];

    //Create Buttons
    [self configureToolbarButtons];

    //Tableview properties
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self resetUI];

    //set the updateStatusNumber
    self.updateStatusNumber = -1;

    //BG Image conf
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    [self.tableView.backgroundView setContentMode:UIViewContentModeScaleAspectFill];
    [self.tableView.backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    self.editButton = nil;
    self.cancelButton = nil;
    self.resetButton = nil;
    self.skipButton = nil;
    self.completeButton = nil;
    self.tableDataSource = nil;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getLastDayCompleted) object:nil];
    [queue addOperation:operation];
    [self resetUI];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //lastDayCompleted = [[settingsDict valueForKey:@"lastCompletedDay"] intValue];
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:lastDayCompleted inSection:0];
    [self.tableView scrollToRowAtIndexPath:myIP atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tableDataSource count];
}


- (void) configureCell:(UITableViewCell *)cell withDay:(Day *)item forRow:(NSIndexPath *)indexPath
{
    UILabel *cellTitle = (UILabel *)[cell viewWithTag:101];
    UILabel *cellSubtitle = (UILabel *)[cell viewWithTag:106];
    cellTitle.text = item.dayName;
    cellSubtitle.text = [NSString stringWithFormat:@"Day: %d", item.dayNumber];

    if (item.hasBeenCompleted)
    {
        if (item.completed == 1)
        {
            cell.imageView.image = [UIImage imageNamed:@"19-circle-check.png"];
            cellTitle.textColor = [UIColor lightGrayColor];
            [cell.imageView setAlpha:.5];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"37-circle-x.png"];
            cellTitle.textColor = [UIColor lightGrayColor];
            [cell.imageView setAlpha:.5];
        }
    }
    else
    {
        cell.imageView.image = nil;
        cellTitle.textColor = [UIColor blackColor];
    }
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Day *item = [self.tableDataSource objectAtIndex:indexPath.row];
    [self configureCell:cell withDay:item forRow:indexPath];

    // Configure the cell...

    self.day = nil;
    return cell;
}


- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor colorWithRed:218.0f / 255.0f green:218.0f / 255.0f blue:218.0f / 255.0f alpha:.5] : [UIColor colorWithRed:201.0f / 255.0f green:201.0f / 255.0f blue:201.0f / 255.0f alpha:.5];

    UILabel *cellTitle = (UILabel *)[cell viewWithTag:101];
    UILabel *cellSubtitle = (UILabel *)[cell viewWithTag:106];
    cellSubtitle.backgroundColor = [UIColor clearColor];
    cellTitle.backgroundColor = [UIColor clearColor];
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableView.isEditing)
    {
        [self performSegueWithIdentifier:@"SHIT" sender:[self.tableDataSource objectAtIndex:indexPath.row]];
        //Update the tempIndexPath member variable for use in the ExerciseViewController
        self.tempIndexPath = indexPath;
    }
    else
    {
        [self setToolbarButtonTitles:[self.tableView indexPathsForSelectedRows]];
    }
}


- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing)
    {
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        if (selectedRows.count == 0)
        {
            [self configureToolbarButtons];
        }
        else
        {
            [self setToolbarButtonTitles:[self.tableView indexPathsForSelectedRows]];
        }
    }
}


- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.isEditing)
    {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }

    //return nil; //per the docs if you do not want the row selected
    return indexPath;
}


#pragma mark handleLongPress
- (void) handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];

    if (indexPath)
    {
        //Check the gesture state to avoid responding to multiple firings of displayActionSheet
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
        {
            //Set the day property to the cell so we can set the title of the UIAcitonSheet
            self.day = [self.tableDataSource objectAtIndex:indexPath.row];
            self.tempIndexPath = indexPath;
            [self displayActionSheet];
            self.aCell = [self.tableView cellForRowAtIndexPath:indexPath];
        }
    }
}


- (void) displayActionSheet
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:self.day.dayName delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Mark Complete", @"Skip Day", @"Clear",nil];

    self.actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [self.actionSheet showInView:self.tabBarController.view];
}


#pragma  mark UIActionSheet Delegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    Day *tempDay;
    switch (buttonIndex)
    {
        case 0:
            [temp addObject:[NSNumber numberWithInt:buttonIndex]];
            [temp addObject:self.day];
            [self performSelectorInBackground:@selector(updateDayStatusWithArgs:) withObject:temp];
            tempDay = [self.tableDataSource objectAtIndex:self.tempIndexPath.row];
            tempDay.hasBeenCompleted = YES;
            tempDay.completed = 1;
            [self.tableView reloadData];
            break;
        case 1:
            [temp addObject:[NSNumber numberWithInt:buttonIndex]];
            [temp addObject:self.day];
            [self performSelectorInBackground:@selector(updateDayStatusWithArgs:) withObject:temp];
            tempDay = [self.tableDataSource objectAtIndex:self.tempIndexPath.row];
            tempDay.hasBeenCompleted = YES;
            tempDay.completed = 2;
            [self.tableView reloadData];
            break;
        case 2:
            [temp addObject:[NSNumber numberWithInt:-1]];
            [temp addObject:self.day];
            [self performSelectorInBackground:@selector(updateDayStatusWithArgs:) withObject:temp];
            tempDay = [self.tableDataSource objectAtIndex:self.tempIndexPath.row];
            tempDay.hasBeenCompleted = NO;
            tempDay.completed = 0;
            [self.tableView reloadData];
            break;
        default:
            break;
    } /* switch */
}


- (void) updateDayStatusWithArgs:(NSArray *)args
{
    [[DataHelper sharedManager] markDayCompleteOrSkipped:[[args objectAtIndex:0] intValue] forDay:[args objectAtIndex:1]];
}


#pragma mark Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Days" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    ExerciseDetailViewController *controller = segue.destinationViewController;
    self.day = (Day *)sender;
    controller.exercises = [[DataHelper sharedManager] exercisesForDay:self.day.dayID];
    controller.day = self.day;
    controller.programID = self.day.programID;
}


#pragma mark Editing Toolbar Actions
- (IBAction) editAction:(id)sender
{
    self.navigationItem.rightBarButtonItem = self.cancelButton;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self hideTabBar:self.tabBarController];
    [self.tableView setEditing:YES animated:YES];
}


- (IBAction) cancelAction:(id)sender
{
    [self resetUI];
}


- (IBAction) resetAction:(id)sender
{
    self.updateStatusNumber = -1;
    NSOperationQueue *queue = [NSOperationQueue new];
    if ([self.tableView indexPathsForSelectedRows] > 0)
    {
        NSMutableArray *updateArray = [NSMutableArray array];
        for (NSIndexPath *selectionIndex in [self.tableView indexPathsForSelectedRows])
        {
            self.day = [self.tableDataSource objectAtIndex:selectionIndex.row];
            self.day.hasBeenCompleted = NO;
            [updateArray addObject:[self.tableDataSource objectAtIndex:selectionIndex.row]];
        }

        //Go do the DB updates in the background
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                selector:@selector(operationBackground:)
                                                                                  object:updateArray];
        [queue addOperation:operation];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops..." message:@"No days were selected" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}


- (IBAction) skipAction:(id)sender
{
    self.updateStatusNumber = 1;

    NSOperationQueue *queue = [NSOperationQueue new];

    if ([self.tableView indexPathsForSelectedRows] > 0)
    {
        NSMutableArray *updateArray = [NSMutableArray array];
        for (NSIndexPath *selectionIndex in [self.tableView indexPathsForSelectedRows])
        {
            self.day = [self.tableDataSource objectAtIndex:selectionIndex.row];
            self.day.hasBeenCompleted = YES;
            self.day.completed = 2;
            [updateArray addObject:[self.tableDataSource objectAtIndex:selectionIndex.row]];
        }

        //Go do the DB updates in the background
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                selector:@selector(operationBackground:)
                                                                                  object:updateArray];
        [queue addOperation:operation];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops..." message:@"No days were selected" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}


- (IBAction) completeAction:(id)sender
{
    self.updateStatusNumber = 0;
    NSOperationQueue *queue = [NSOperationQueue new];

    if ([self.tableView indexPathsForSelectedRows] > 0)
    {
        NSMutableArray *updateArray = [NSMutableArray array];
        for (NSIndexPath *selectionIndex in [self.tableView indexPathsForSelectedRows])
        {
            self.day = [self.tableDataSource objectAtIndex:selectionIndex.row];
            self.day.hasBeenCompleted = YES;
            self.day.completed = 1;

            [updateArray addObject:[self.tableDataSource objectAtIndex:selectionIndex.row]];
        }

        //Go do the DB updates in the background
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                selector:@selector(operationBackground:)
                                                                                  object:updateArray];
        [queue addOperation:operation];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops..." message:@"No days were selected" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}


- (void) operationBackground:(NSArray *)updateArray
{
    for (Day *d in updateArray)
    {
        NSMutableArray *temp = [NSMutableArray array];
        [temp addObject:[NSNumber numberWithInt:self.updateStatusNumber]];
        [temp addObject:d];
        [self updateDayStatusWithArgs:temp];
    }

    [self performSelectorOnMainThread:@selector(resetUI) withObject:nil waitUntilDone:YES];
}


- (void) resetUI
{
    self.navigationItem.rightBarButtonItem = self.editButton;
    [self.tableView setEditing:NO animated:YES];
    [self showTabBar:self.tabBarController];
    [self configureToolbarButtons];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self.tableView reloadData];
}


- (void) configureToolbarButtons
{
    [self.resetButton setTintColor:[UIColor redColor]];
    self.resetButton.title = @"Reset";
    self.resetButton.width = 80.0;
    self.skipButton.title = @"Skip";
    self.skipButton.width = 80.0;
    self.completeButton.title = @"Complete";
    self.completeButton.width = 80.0;
}


- (void) setToolbarButtonTitles:(NSArray *)selectedRows
{
    NSString *resetButtonTitle = [NSString stringWithFormat:@"Reset(%d)", selectedRows.count];
    NSString *skipButtonTitle = [NSString stringWithFormat:@"Skip(%d)", selectedRows.count];
    NSString *completedButtonTitle = [NSString stringWithFormat:@"Mark(%d)", selectedRows.count];
    self.resetButton.title = resetButtonTitle;
    self.skipButton.title = skipButtonTitle;
    self.completeButton.title = completedButtonTitle;
}


- (void) hideTabBar:(UITabBarController *)tabbarcontroller
{
}


- (void) showTabBar:(UITabBarController *)tabbarcontroller
{
    [self.navigationController setToolbarHidden:YES animated:NO];
}


- (void) getLastDayCompleted
{
    NSInteger count = 0;
    for (Day *d in self.tableDataSource)
    {
        if (d.hasBeenCompleted)
        {
            lastDayCompleted = count;
        }

        count++;
    }
}


@end
