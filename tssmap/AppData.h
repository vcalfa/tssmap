//
//  AppData.h
//  tssmap
//
//  Created by Vladimir Calfa on 27/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Directions.h"

@interface AppData : NSObject

@property (nonatomic, strong, readonly) NSArray *directions;

+ (instancetype)sharedInstance;
- (void)addDirection:(Directions*)direction;
- (Directions*)chachedDirectionFromStartLocation:(NSString*)startLocation toEndLocation:(NSString*)endLocation;

@end
