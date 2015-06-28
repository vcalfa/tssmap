//
//  Leg.h
//  tssmap
//
//  Created by Vladimir Calfa on 27/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppModelObject.h"
#import "Location.h"
#import "RouteInfo.h"
#import "Step.h"

@interface Leg : RouteInfo

@property (nonatomic, strong) NSString *startAddress;
@property (nonatomic, strong) NSString *endAddress;
@property (nonatomic, strong) NSArray *steps;

- (void)addStartPointToPath:(GMSMutablePath *)path;
- (void)addStepPointsToPath:(GMSMutablePath *)path;

@end
