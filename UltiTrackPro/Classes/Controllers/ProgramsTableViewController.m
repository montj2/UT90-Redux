//
//  ProgramsTableViewController.m
//  UltiTrackPro
//
//  Created by James Montgomery on 7/26/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "ProgramsTableViewController.h"
#import "DataHelper.h"
#import "Program.h"
#import "DaysTableViewController.h"

@interface ProgramsTableViewController () {
    //Program *program;
    NSMutableDictionary *settingsDict;
    BOOL hasBeenUpdated;
}
@property (nonatomic, weak) Program *program;
@end

@implementation ProgramsTableViewController

- (id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }

    return self;
}


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


- (void) viewDidLoad
{
    [super viewDidLoad];

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

    //Add observer to watch for plist changes
    [settingsDict addObserver:self forKeyPath:@"activeProgram" options:NSKeyValueObservingOptionNew context:NULL];

    //BG conf info
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    [self.tableView.backgroundView setContentMode:UIViewContentModeScaleAspectFill];
    [self.tableView.backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //if the ProgramSettings.plist has been modified, reload tableData and reset flag
    if (hasBeenUpdated)
    {
        hasBeenUpdated = NO;
    }

    [self.tableView reloadData];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    self.program = [self.tableDataSource objectAtIndex:indexPath.row];
    // Configure the cell...
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    label.text = self.program.programName;
    UILabel *subtextLabel = (UILabel *)[cell viewWithTag:102];
    UILabel *completedLabel = (UILabel *)[cell viewWithTag:103];

    //Set subtitle text to active
    if ([[settingsDict valueForKey:@"activeProgram"] intValue] == self.program.programID)
    {
        subtextLabel.text = @"Active";
        label.font = [UIFont boldSystemFontOfSize:label.font.pointSize];
        subtextLabel.font = [UIFont boldSystemFontOfSize:subtextLabel.font.pointSize];
        completedLabel.font = [UIFont boldSystemFontOfSize:completedLabel.font.pointSize];

        UIImageView *imgView = (UIImageView *)[cell viewWithTag:123];
        imgView.hidden = NO;
    }
    else
    {
        subtextLabel.text = @"";
        label.font = [UIFont systemFontOfSize:label.font.pointSize];
        subtextLabel.font = [UIFont systemFontOfSize:subtextLabel.font.pointSize];
        completedLabel.font = [UIFont systemFontOfSize:completedLabel.font.pointSize];

        UIImageView *imgView = (UIImageView *)[cell viewWithTag:123];
        imgView.hidden = YES;
    }

    //Set label for "Completed ##/##
    NSArray *daysCompletedCount = [[DataHelper sharedManager] daysCompletedCountForProgram:self.program.programID];
    completedLabel.text = [NSString stringWithFormat:@"Completed: %@/%@", [daysCompletedCount objectAtIndex:0], [daysCompletedCount objectAtIndex:1]];

    return cell;
}


- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor colorWithRed:218.0f / 255.0f green:218.0f / 255.0f blue:218.0f / 255.0f alpha:.5] : [UIColor colorWithRed:201.0f / 255.0f green:201.0f / 255.0f blue:201.0f / 255.0f alpha:.5];
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Set the selected program to active in ProgramSettings.plist if different from current value
    if ( [[settingsDict valueForKey:@"activeProgram"] intValue] != (indexPath.row + 1) )
    {
        [settingsDict setValue:[NSNumber numberWithInt:(indexPath.row + 1)] forKey:@"activeProgram"];
    }

    //Perform Segue
    [self performSegueWithIdentifier:@"pushToDays" sender:[self.tableDataSource objectAtIndex:indexPath.row]];
}


#pragma mark - Seuge
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Programs" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    DaysTableViewController *controller = segue.destinationViewController;
    Program *p = (Program *)sender;
    controller.tableDataSource = [[DataHelper sharedManager] daysForProgram:p.programID];
}


#pragma mark KVO
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //Write the settings dictionary to disk
    [settingsDict writeToFile:[self dataFilePath] atomically:YES];
    //Trip the flag for hasBeenUpdated so tableData will be reloaded on viewWillAppear
    hasBeenUpdated = YES;
}


@end
