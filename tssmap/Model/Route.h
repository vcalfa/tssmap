//
//  Route.h
//  tssmap
//
//  Created by Vladimir Calfa on 26/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppModelObject.h"
#import "Bounds.h"
#import "Leg.h"

@interface Route : AppModelObject

@property (nonatomic, strong) Bounds *bounds;
@property (nonatomic, strong) NSArray *legs;
@property (nonatomic, strong) NSDictionary *overviewPolyline;

- (GMSMutablePath *)path;
- (GMSPath *)overviewPath;
- (Leg*)firstLeg;
- (Leg*)lastLeg;

@end
