//
//  Directions.h
//  tssmap
//
//  Created by Vladimir Calfa on 27/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppModelObject.h"
#import "Bounds.h"

@interface Directions : AppModelObject

@property (nonatomic, strong) NSArray *routes;

@property (nonatomic, strong) NSString *startLocation;
@property (nonatomic, strong) NSString *endLocation;

- (GMSPolyline *)polylineOfFirstRoute;
- (GMSPolyline *)polylineOfRouteAtIndex:(NSInteger)index;
- (GMSPolyline *)overviewPolylineOfFirstRoute;
- (GMSPolyline *)overviewPolylineOfRouteAtIndex:(NSInteger)index;
- (Bounds*)boundsOfRouteAtIndex:(NSInteger)index;

@end
