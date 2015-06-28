//
//  Step.h
//  tssmap
//
//  Created by Vladimir Calfa on 27/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import "RouteInfo.h"

@interface Step : RouteInfo

@property (nonatomic, strong) NSString *htmlInstructions;
@property (nonatomic, strong) NSString *travelMode;
@property (nonatomic, strong) NSString *polyline;
@property (nonatomic, strong) NSString *maneuver;

@end
