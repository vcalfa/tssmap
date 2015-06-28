//
//  Directions.m
//  tssmap
//
//  Created by Vladimir Calfa on 27/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import "Directions.h"
#import "Route.h"

@implementation Directions

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"routes": @"routes",
             };
}

+ (NSValueTransformer *)routesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass: Route.class];
}

- (GMSPolyline *)polylineOfFirstRoute {
    return [self polylineOfRouteAtIndex:0];
}

- (GMSPolyline *)polylineOfRouteAtIndex:(NSInteger)index {
    
    if ([self.routes count] <= index) {
        return nil;
    }
    
    Route *r = [self.routes objectAtIndex:index];
    
    GMSMutablePath *path = [r path];
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor blueColor];
    polyline.strokeWidth = 5.f;
    
    return polyline;
}

- (GMSPolyline *)overviewPolylineOfFirstRoute {
    return [self overviewPolylineOfRouteAtIndex:0];
}

- (GMSPolyline *)overviewPolylineOfRouteAtIndex:(NSInteger)index {
    
    if ([self.routes count] <= index) {
        return nil;
    }
    
    Route *r = [self.routes objectAtIndex:index];
    
    GMSPath *path = [r overviewPath];
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor blueColor];
    polyline.strokeWidth = 5.f;
    
    return polyline;
}

- (Bounds*)boundsOfRouteAtIndex:(NSInteger)index {
    
    if ([self.routes count] <= index) {
        return nil;
    }
    
    Route *r = [self.routes objectAtIndex:index];
    
    return r.bounds;
}

@end
