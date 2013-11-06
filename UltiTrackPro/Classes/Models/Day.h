//
//  Day.h
//  UltiTrackPro
//
//  Created by James Montgomery on 7/23/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Day : NSObject

@property (nonatomic, assign) NSInteger completed;
@property (nonatomic, assign) NSInteger dayNumber;
@property (nonatomic, assign) NSInteger programID;
@property (nonatomic, assign) NSInteger dayID;
@property (nonatomic, assign) NSInteger weekNumber;
@property (nonatomic, copy) NSString *dayName;
@property (nonatomic, assign) BOOL hasBeenCompleted;

- (id)initWithDay:(NSInteger)dayID dayName:(NSString *)dayName dayNumber:(NSInteger)dayNumber weekNumber:(NSInteger)weekNumber completed:(NSInteger)completed hasBeenCompleted:(BOOL)hasBeenCompleted programID:(NSInteger)programID;
@end
