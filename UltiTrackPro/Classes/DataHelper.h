//
//  DataHelper.h
//  UltiTrackPro
//
//  Created by James Montgomery on 7/23/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@class Stat;
@class Exercise;
@class Day;

@interface DataHelper : NSObject
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) FMResultSet *queryResults;

+ (id)sharedManager;
- (NSArray *)programsList;
- (NSArray *)bandSets;
- (NSArray *)bandSetInfoForSet:(NSInteger)setNumber;
- (NSArray *)daysForProgram:(NSInteger)programID;
- (NSArray *)exercisesForDay:(NSInteger)dayID;
- (NSArray *)daysCompletedCountForProgram:(NSInteger)programID;
- (NSArray *)bandsForSet:(NSInteger)setID;
- (NSMutableArray *)historyForExerciseID:(NSInteger)exerciseID;
- (void)markDayCompleteOrSkipped:(NSInteger)status forDay:(Day *)day;
- (void)resetProgress;
- (void)saveStat:(Stat *)stat;
- (void)deleteHistoryItem:(Stat *)stat;
- (Stat *)statForLastExercise:(Exercise *)exercise;

@end
