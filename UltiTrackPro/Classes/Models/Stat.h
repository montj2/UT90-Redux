//
//  Stat.h
//  UltiTrackPro
//
//  Created by James Montgomery on 8/16/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stat : NSObject

@property (nonatomic, assign) NSInteger sID;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger exerID;
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, assign) NSInteger reps;
@property (nonatomic, assign) NSInteger bandID;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *notes;

- (id)initWithStat:(NSInteger)sID userID:(NSInteger)userID exerID:(NSInteger)exerID weight:(NSInteger)weight reps:(NSInteger)reps bandID:(NSInteger)bandID time:(NSString *)time date:(NSString *)date notes:(NSString *)notes;

@end
