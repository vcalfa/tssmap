//
//  GMSAnimateMarker.h
//  tssmap
//
//  Created by Vladimir Calfa on 28/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@interface GMSAnimateMarker : GMSMarker

@property(nonatomic, readonly, copy) GMSPath *path;
@property(nonatomic, readonly) NSUInteger target;
@property(nonatomic, readonly) double velocity;
@property(nonatomic, assign, readonly) BOOL isAnimated;

- (id)initWithPath:(GMSPath *)path;
- (void)setVelocityKmH:(double)velocity;

//- (CLLocationCoordinate2D)next;
//- (void)animateToNextCoord;

- (void)play;
- (void)pause;

@end
