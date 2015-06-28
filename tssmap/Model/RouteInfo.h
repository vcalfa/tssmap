//
//  RouteInfo.h
//  tssmap
//
//  Created by Vladimir Calfa on 27/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import "AppModelObject.h"
#import "Location.h"

@interface RouteInfo : AppModelObject

@property (nonatomic, strong) NSString *distanceText;
@property (nonatomic, strong) NSNumber *distanceValue;

@property (nonatomic, strong) NSString *durationText;
@property (nonatomic, strong) NSNumber *durationValue;

@property (nonatomic, strong) Location *startLocation;
@property (nonatomic, strong) Location *endLocation;

@end
