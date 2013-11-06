//
//  Day.m
//  UltiTrackPro
//
//  Created by James Montgomery on 7/23/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "Day.h"

@implementation Day

@synthesize completed = _completed;
@synthesize dayNumber = _dayNumber;
@synthesize programID = _programID;
@synthesize dayID = _dayID;
@synthesize weekNumber = _weekNumber;
@synthesize dayName = _dayName;
@synthesize hasBeenCompleted = _hasBeenCompleted;

- (id) initWithDay:(NSInteger)dayID dayName:(NSString *)dayName dayNumber:(NSInteger)dayNumber weekNumber:(NSInteger)weekNumber completed:(NSInteger)completed hasBeenCompleted:(BOOL)hasBeenCompleted programID:(NSInteger)programID
{
    if (self = [super init])
    {
        _completed = completed;
        _dayNumber = dayNumber;
        _programID = programID;
        _dayID = dayID;
        _weekNumber = weekNumber;
        _dayName = dayName;
        _hasBeenCompleted = hasBeenCompleted;
    }

    return self;
}


- (id) init
{
    return [self initWithDay:-1 dayName:@"default" dayNumber:-1 weekNumber:-1 completed:-1 hasBeenCompleted:NO programID:-1];
}


- (NSString *) description
{
    return [NSString stringWithFormat:@"dayID:%d dayName:%@ dayNumber:%d weekNumber:%d completed:%d hasBeenCompleted:%d programID:%d",
            self.dayID, self.dayName, self.dayNumber, self.weekNumber, self.completed, self.hasBeenCompleted, self.programID];
}


@end
