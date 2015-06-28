//
//  GMSAnimateMarker.m
//  tssmap
//
//  Created by Vladimir Calfa on 28/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import "GMSAnimateMarker.h"

@interface GMSAnimateMarker()

@property(nonatomic, assign) double velocity;
@property(nonatomic, assign) BOOL isAnimated;

@end

@implementation GMSAnimateMarker

- (id)initWithPath:(GMSPath *)path {
    if ((self = [super init])) {
        _path = [path copy];
        [self setPosition:[_path coordinateAtIndex:0]];
        _target = 0;
        [self setVelocityKmH:50.0];
    }
    return self;
}

- (CLLocationCoordinate2D)next {
    ++_target;
    if (_target == [_path count]) {
        _target = 0;
    }
    return [_path coordinateAtIndex:_target];
}

- (void)setVelocityKmH:(double)velocity {
    _velocity = velocity * (1.0/3.6);
}

- (void)animateToNextCoord {
    
    if (!_isAnimated) return;
    
    CLLocationCoordinate2D coord = [self next];
    CLLocationCoordinate2D previous = self.position;
    
    CLLocationDistance distance = GMSGeometryDistance(previous, coord);
    
    // Use CATransaction to set a custom duration for this animation. By default, changes to the
    // position are already animated, but with a very short default duration. When the animation is
    // complete, trigger another animation step.
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:(distance / _velocity)];
    
    __weak GMSAnimateMarker *weakSelf = self;
    [CATransaction setCompletionBlock:^{
        [weakSelf animateToNextCoord];
    }];
    
    self.position = coord;
    
    [CATransaction commit];
}

-(void)pauseLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}


- (void)play {
    
    if (_isAnimated) return;

    _isAnimated = YES;

    if (self.layer.timeOffset != 0.0) {
        [self resumeLayer:self.layer];
    }
    else {
        [self animateToNextCoord];
    }
}

- (void)pause {
    
    if (!_isAnimated) return;
        _isAnimated = NO;
    
    [self pauseLayer:self.layer];
}

@end
