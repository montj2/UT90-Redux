//
//  Stat.m
//  UltiTrackPro
//
//  Created by James Montgomery on 8/16/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "Stat.h"

@implementation Stat

- (id) init
{
    return [self initWithStat:0 userID:0 exerID:0 weight:0 reps:0 bandID:0 time:@"" date:@"" notes:@""];
}


- (id) initWithStat:(NSInteger)sID userID:(NSInteger)userID exerID:(NSInteger)exerID weight:(NSInteger)weight reps:(NSInteger)reps bandID:(NSInteger)bandID time:(NSString *)time date:(NSString *)date notes:(NSString *)notes
{
    if (self = [super init])
    {
        _sID = sID;
        _userID = userID;
        _exerID = exerID;
        _weight = weight;
        _reps = reps;
        _bandID = bandID;
        _time = time;
        _date = date;
        _notes = notes;
    }

    return self;
}


- (NSString *) description
{
    return [NSString stringWithFormat:@"sID:%d userID:%d exerID:%d weight:%d reps:%d bandId:%d time:%@ date:%@ notes:%@", _sID, _userID, _exerID, _weight, _reps, _bandID, _time, _date, _notes ];
}


@end
