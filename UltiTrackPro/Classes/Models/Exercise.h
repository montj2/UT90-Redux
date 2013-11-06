//
//  Exercise.h
//  UltiTrackPro
//
//  Created by James Montgomery on 7/25/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exercise : NSObject

@property (nonatomic, assign) NSInteger exerciseCompleted;
@property (nonatomic, assign) NSInteger dayID;
@property (nonatomic, assign) NSInteger exerciseOrder;
@property (nonatomic, assign) NSInteger exerciseID;
@property (nonatomic, assign) NSInteger exerciseType;
@property (nonatomic, copy) NSString *exerciseName;

- (id)initWithExerciseID:(NSInteger)exercisedID exerciseName:(NSString *)exerciseName exerciseType:(NSInteger)exerciseType exerciseCompleted:(NSInteger)exerciseCompleted dayID:(NSInteger)dayID exerciseOrder:(NSInteger)exerciseOrder;
@end
