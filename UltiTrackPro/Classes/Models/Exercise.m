//
//  Exercise.m
//  UltiTrackPro
//
//  Created by James Montgomery on 7/25/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "Exercise.h"

@implementation Exercise

@synthesize exerciseCompleted = _exerciseCompleted;
@synthesize dayID = _dayID;
@synthesize exerciseOrder = _exerciseOrder;
@synthesize exerciseID = _exerciseID;
@synthesize exerciseType = _exerciseType;
@synthesize exerciseName = _exerciseName;

- (id) initWithExerciseID:(NSInteger)exerciseID exerciseName:(NSString *)exerciseName exerciseType:(NSInteger)exerciseType exerciseCompleted:(NSInteger)exerciseCompleted dayID:(NSInteger)dayID exerciseOrder:(NSInteger)exerciseOrder
{
    if (self = [super init])
    {
        self.exerciseName = exerciseName;
        self.exerciseType = exerciseType;
        self.exerciseCompleted = exerciseCompleted;
        self.exerciseID = exerciseID;
        self.dayID = dayID;
        self.exerciseOrder = exerciseOrder;
    }

    return self;
}


- (id) init
{
    return [self initWithExerciseID:-1 exerciseName:@"Default" exerciseType:-1 exerciseCompleted:-1 dayID:-1 exerciseOrder:-1];
}


- (NSString *) description
{
    return [NSString stringWithFormat:@"ExerciseName: %@ ExerciseType: %d ExerciseCompleted: %d ExerciseID: %d DayID: %d ExerciseOrder: %d", _exerciseName, _exerciseType, _exerciseCompleted, _exerciseID, _dayID, _exerciseOrder];
}


@end
