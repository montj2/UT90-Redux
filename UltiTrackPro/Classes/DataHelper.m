//
//  DataHelper.m
//  UltiTrackPro
//
//  Created by James Montgomery on 7/23/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "DataHelper.h"
#import "Program.h"
#import "Day.h"
#import "Exercise.h"
#import "Models/Stat.h"
#import "BandSet.h"
#import "Band.h"

static DataHelper *sharedManager = nil;

@implementation DataHelper

@synthesize db = _db;
@synthesize queryResults = _queryResults;

#pragma mark Singleton Methods
+ (id) sharedManager
{
    @synchronized(self)
    {
        if (sharedManager == nil)
        {
            sharedManager = [[self alloc] init];
        }
    }
    return sharedManager;
}


- (id) init
{
    if (self = [super init])
    {
        //Copy the DB to docs if it doesn't exist
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"UT90.sqlite"];
        NSFileManager *fileManager = [NSFileManager defaultManager];

        if (![fileManager fileExistsAtPath:filePath])
        {
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"UT90" ofType:@"sqlite"];
            [fileManager copyItemAtPath:sourcePath toPath:filePath error:nil];
        }

        self.db = [FMDatabase databaseWithPath:filePath];
    }

    return self;
}


#pragma mark Database Query Methods

- (NSArray *) programsList
{
    //Array used to rerturn Program objects to the ProgramsTableViewController
    NSMutableArray *return_values = [[NSMutableArray alloc] initWithCapacity:3];
    //Compose the query and execute
    [self.db open];
    self.queryResults = [self.db executeQuery:@"SELECT ProgramID, ProgramName, isEditable FROM Programs"];

    //Loop through query results and create Program model objects
    while ([self.queryResults next])
    {
        Program *model = [[Program alloc] init];

        model.programID = [self.queryResults intForColumnIndex:0];
        model.programName = [self.queryResults stringForColumnIndex:1];
        model.isEditable = [self.queryResults intForColumnIndex:2];

        [return_values addObject:model];
    }

    //Close the db and return the results
    [self.db close];
    return return_values;
}


- (NSArray *) daysForProgram:(NSInteger)programID
{
    //Array used to return Day objects to the DaysTableViewController
    NSMutableArray *return_values = [[NSMutableArray alloc] initWithCapacity:121];
    //Compose the query and execute
    [self.db open];

    self.queryResults = [self.db executeQueryWithFormat:@"SELECT DayOrderDetails.DayID, Days.DayName, DayOrderDetails.DayNumber, DayOrderDetails.WeekNumber, DayOrderDetails.DayCompleted FROM DayOrderDetails JOIN Days ON DayOrderDetails.DayID=Days.DayID WHERE ProgramID = (%d)", programID];

    //Loop through query results and create Day model objects
    while ([self.queryResults next])
    {
        Day *model = [[Day alloc] init];

        model.dayID = [self.queryResults intForColumnIndex:0];
        model.dayName = [self.queryResults stringForColumnIndex:1];
        model.dayNumber = [self.queryResults intForColumnIndex:2];
        model.weekNumber = [self.queryResults intForColumnIndex:3];
        model.completed = [self.queryResults intForColumnIndex:4];
        model.hasBeenCompleted = NO;
        model.programID = programID;

        if (model.completed > 0)
        {
            model.hasBeenCompleted = YES;
        }

        [return_values addObject:model];
    }

    //Close the db and return the results
    [self.db close];
    return return_values;
}


- (NSArray *) exercisesForDay:(NSInteger)dayID
{
    //Array used to return the Exercise objects to the ExerciseDetailViewController*
    NSMutableArray *return_values = [[NSMutableArray alloc] init];
    //Compose the query and execute
    [self.db open];
    NSLog(@"You called exercisesForDay: with dayID %d", dayID);
    self.queryResults = [self.db executeQueryWithFormat:@"SELECT ExerciseOrderDetails.dayID, ExerciseOrderDetails.ExerciseOrder, ExerciseOrderDetails.ExerciseID, ExerciseOrderDetails.ExerciseCompleted, Exercises.ExerciseName, Exercises.ExerciseType FROM ExerciseOrderDetails JOIN Exercises ON Exercises.ExerciseID = ExerciseOrderDetails.ExerciseID WHERE ExerciseOrderDetails.DayID = (%d)", dayID];

    //Loop through the query and execute
    while ([self.queryResults next])
    {
        Exercise *model = [[Exercise alloc] init];
        model.dayID = [self.queryResults intForColumnIndex:0];
        model.exerciseOrder = [self.queryResults intForColumnIndex:1];
        model.exerciseID = [self.queryResults intForColumnIndex:2];
        model.exerciseCompleted = [self.queryResults intForColumnIndex:3];
        model.exerciseName = [self.queryResults stringForColumnIndex:4];
        model.exerciseType = [self.queryResults intForColumnIndex:5];
        [return_values addObject:model];
    }

    //Close the db and return the results
    [self.db close];
    return return_values;
}


- (NSArray *) daysCompletedCountForProgram:(NSInteger)programID
{
    //Array used to return the completed/total progam numbers
    NSMutableArray *return_values = [[NSMutableArray alloc] initWithCapacity:2];
    //Compose the first query to get number of days completed and execute
    [self.db open];
    self.queryResults = [self.db executeQueryWithFormat:@"SELECT COUNT(*)  FROM DayOrderDetails WHERE ProgramID = (%d) AND DayCompleted != 0 OR NULL", programID];
    //Add query result to the return_values
    while ([self.queryResults next])
    {
        [return_values addObject:[NSNumber numberWithInt:[self.queryResults intForColumnIndex:0]]];
    }

    //Compose second query to get total number of days in program and execute
    self.queryResults = [self.db executeQueryWithFormat:@"SELECT COUNT(*)  FROM DayOrderDetails WHERE ProgramID = (%d)", programID];
    //Add query result to the return_values
    while ([self.queryResults next])
    {
        [return_values addObject:[NSNumber numberWithInt:[self.queryResults intForColumnIndex:0]]];
    }

    //Close the db and return the results
    [self.db close];
    return return_values;
}


- (void) markDayCompleteOrSkipped:(NSInteger)status forDay:(Day *)day
{
    //db_table has non-zero index, so we "must" add 1
    status = status + 1;
    [self.db open];
    [self.db executeUpdateWithFormat:@"UPDATE DayOrderDetails SET DayCompleted = (%d) WHERE DayID = (%d) AND DayNumber = (%d) AND ProgramID = (%d)", status, day.dayID, day.dayNumber, day.programID];
    [self.db close];
}


- (void) resetProgress
{
    //db_table has non-zero index, so we "must" add 1
    [self.db open];
    [self.db executeUpdateWithFormat:@"UPDATE DayOrderDetails SET DayCompleted = (%d) ",0];
    [self.db close];
}


- (void) saveStat:(Stat *)stat
{
    [self.db open];
    [self.db executeUpdate:@"insert into UserStats(UserID, ExerciseID, StatWeight, StatReps, BandID, StatTime, StatDate, StatNotes) values(?,?,?,?,?,?,?,?)",
     [NSString stringWithFormat:@"%d", stat
      .userID],
     [NSString stringWithFormat:@"%d",stat.exerID],
     [NSString stringWithFormat:@"%d",stat.weight],
     [NSString stringWithFormat:@"%d",stat.reps],
     [NSString stringWithFormat:@"%d",stat.bandID],
     [NSString stringWithFormat:@"%@", stat.time],
     [NSString stringWithFormat:@"%@",stat.date],
     [NSString stringWithFormat:@"%@",stat.notes],
     nil];
    [self.db close];
}


- (Stat *) statForLastExercise:(Exercise *)exercise
{
    Stat *stat = [[Stat alloc] init];
    [self.db open];
    self.queryResults = [self.db executeQueryWithFormat:@"SELECT UserStats._id, UserStats.UserID, UserStats.ExerciseID, UserStats.StatWeight, UserStats.StatReps, UserStats.BandID, UserStats.StatTime, UserStats.StatDate, UserStats.StatNotes, Exercises.ExerciseType FROM UserStats JOIN Exercises ON Exercises.ExerciseID = UserStats.ExerciseID WHERE UserStats.ExerciseID = %d ORDER BY UserStats._id DESC LIMIT 1", exercise.exerciseID];

    //Assign the results to the stat
    while ([self.queryResults next])
    {
        stat.sID = [self.queryResults intForColumnIndex:0];
        stat.userID = [self.queryResults intForColumnIndex:1];
        stat.exerID = [self.queryResults intForColumnIndex:2];
        stat.weight = [self.queryResults intForColumnIndex:3];
        stat.reps = [self.queryResults intForColumnIndex:4];
        stat.bandID = [self.queryResults intForColumnIndex:5];
        stat.time = [self.queryResults stringForColumnIndex:6];
        stat.date = [self.queryResults stringForColumnIndex:7];
        stat.notes = [self.queryResults stringForColumnIndex:8];
    }

    [self.db close];
    return stat;
}


- (NSArray *) historyForExerciseID:(NSInteger)exerciseID
{
    NSMutableArray *return_results = [[NSMutableArray alloc] initWithCapacity:100];
    [self.db open];
    self.queryResults = [self.db executeQueryWithFormat:@"SELECT UserStats._id, UserStats.UserID, UserStats.ExerciseID, UserStats.StatWeight, UserStats.StatReps, UserStats.BandID, UserStats.StatTime, UserStats.StatDate, UserStats.StatNotes, Exercises.ExerciseType FROM UserStats JOIN Exercises ON Exercises.ExerciseID = UserStats.ExerciseID WHERE UserStats.ExerciseID = %d ORDER BY UserStats._id DESC", exerciseID];

    //Assign the results to the stat
    while ([self.queryResults next])
    {
        Stat *stat = [[Stat alloc] init];

        stat.sID = [self.queryResults intForColumnIndex:0];
        stat.userID = [self.queryResults intForColumnIndex:1];
        stat.exerID = [self.queryResults intForColumnIndex:2];
        stat.weight = [self.queryResults intForColumnIndex:3];
        stat.reps = [self.queryResults intForColumnIndex:4];
        stat.bandID = [self.queryResults intForColumnIndex:5];
        stat.time = [self.queryResults stringForColumnIndex:6];
        stat.date = [self.queryResults stringForColumnIndex:7];
        stat.notes = [self.queryResults stringForColumnIndex:8];

        [return_results addObject:stat];
    }

    [self.db close];
    return return_results;
}


- (NSArray *) bandSets
{
    NSMutableArray *return_results = [[NSMutableArray alloc] initWithCapacity:10];

    [self.db open];
    self.queryResults = [self.db executeQuery:@"SELECT * FROM BandSets ORDER BY BandSetName"];

    while ([self.queryResults next])
    {
        BandSet *model = [[BandSet alloc] init];
        model._id = [self.queryResults intForColumnIndex:0];
        model.setID = [self.queryResults intForColumnIndex:1];
        model.setName = [self.queryResults stringForColumnIndex:2];
        model.isEditable = [self.queryResults intForColumnIndex:3];

        [return_results addObject:model];
    }

    [self.db close];

    return return_results;
}


- (NSArray *) bandSetInfoForSet:(NSInteger)setNumber
{
    NSMutableArray *return_results = [[NSMutableArray alloc] init];
    [self.db open];
    //count
    self.queryResults = [self.db executeQueryWithFormat:@"SELECT COUNT (*) FROM BandDetails JOIN BandColors ON BandDetails.BandColorID = BandColors.BandColorID WHERE BandSetID = (%d)", setNumber];
    while ([self.queryResults next])
    {
        NSNumber *count = [NSNumber numberWithInt:[self.queryResults intForColumnIndex:0] - 1 ];
        [return_results addObject:count];
    }

    //low weight
    self.queryResults = [self.db executeQueryWithFormat:@"SELECT BandDetails._id, BandDetails.BandID, BandDetails.BandWeight, BandDetails.BandColorID, BandColors.BandColorName FROM BandDetails JOIN BandColors ON BandDetails.BandColorID = BandColors.BandColorID WHERE BandSetID = (%d) AND BandID = 1", setNumber];
    while ([self.queryResults next])
    {
        NSNumber *lowWeight = [NSNumber numberWithInt:[self.queryResults intForColumnIndex:2]];
        [return_results addObject:lowWeight];
    }

    //high weight
    self.queryResults = [self.db executeQueryWithFormat:@"SELECT BandDetails._id, BandDetails.BandID, BandDetails.BandWeight, BandDetails.BandColorID, BandColors.BandColorName FROM BandDetails JOIN BandColors ON BandDetails.BandColorID = BandColors.BandColorID WHERE BandSetID = (%d) ORDER BY BandDetails._id DESC LIMIT 1", setNumber];
    while ([self.queryResults next])
    {
        NSNumber *highWeight = [NSNumber numberWithInt:[self.queryResults intForColumnIndex:2]];
        [return_results addObject:highWeight];
    }

    [self.db close];
    return return_results;
}


- (NSArray *) bandsForSet:(NSInteger)setID
{
    NSMutableArray *return_results = [[NSMutableArray alloc] initWithCapacity:10];
    [self.db open];
    self.queryResults = [self.db executeQueryWithFormat:@"SELECT BandDetails._id, BandDetails.BandID, BandDetails.BandWeight, BandDetails.BandColorID, BandColors.BandColorName FROM BandDetails JOIN BandColors ON BandDetails.BandColorID = BandColors.BandColorID WHERE BandSetID = (%d)", setID];

    while ([self.queryResults next])
    {
        Band *model = [[Band alloc] init];
        model._id = [self.queryResults intForColumnIndex:0];
        model.bandID = [self.queryResults intForColumnIndex:1];
        model.weight = [self.queryResults intForColumnIndex:2];
        model.colorID = [self.queryResults intForColumnIndex:3];
        model.color = [self.queryResults stringForColumnIndex:4];
        model.isEditable = NO;

        [return_results addObject:model];
    }

    [self.db close];
    return return_results;
}


@end
