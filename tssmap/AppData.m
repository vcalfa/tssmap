//
//  AppData.m
//  tssmap
//
//  Created by Vladimir Calfa on 27/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import "AppData.h"
#define MAX_STORED_ROUTES 5


@interface AppData()

@property (nonatomic, strong) NSMutableOrderedSet *keys;
@property (nonatomic, strong) NSMutableOrderedSet *internalRoutes;
@property (nonatomic, strong) NSArray *directions;

@end

@implementation AppData


+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _internalRoutes = [[NSMutableOrderedSet alloc] initWithCapacity: MAX_STORED_ROUTES + 1];
        _keys = [[NSMutableOrderedSet alloc] initWithCapacity: MAX_STORED_ROUTES + 1];
        _directions = @[];
    }
    return self;
}

- (void)addDirection:(Directions*)direction {
    [self addDirection:direction update:NO];
}

- (void)addDirection:(Directions*)direction update:(BOOL)update
{    
    NSAssert(direction, @"");
    
    NSString *key = [self keyForStartLocation:direction.startLocation endLocation:direction.endLocation];
    
    BOOL containsObject = [self.keys containsObject:key];
    if (containsObject && update) {
        //[self.internalRoutes setValue:direction forKey:key];
        NSAssert(nil, @"Not implemented");
        self.directions = [[self.internalRoutes reversedOrderedSet] array];
        return;
    } else if (containsObject) {
        return;
    }
    
    [self.internalRoutes addObject:direction];
    [self.keys addObject:key];
    
    if ([self.keys count] > MAX_STORED_ROUTES) {

        [self.keys removeObjectAtIndex:0];
        [self.internalRoutes removeObjectAtIndex:0];
    }

    self.directions = [[self.internalRoutes reversedOrderedSet] array];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appDataChanged" object:nil];
    
}

//- (BOOL)isStoredDirectionFromStartLocation:(NSString*)startLocation toEndLocation:(NSString*)endLocation {
//    NSString *key = [NSString stringWithFormat:@"%@%@",startLocation,endLocation];
//}

- (Directions*)chachedDirectionFromStartLocation:(NSString*)startLocation toEndLocation:(NSString*)endLocation {
    NSString *key = [self keyForStartLocation: startLocation endLocation: endLocation];
    NSUInteger index = [self.keys indexOfObject:key];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    Directions *direction = [self.internalRoutes objectAtIndex:index];
    return direction;
}

- (NSString*)keyForStartLocation:(NSString*)startLocation endLocation:(NSString*)endLocation {
    return [NSString stringWithFormat:@"%@%@",[startLocation lowercaseString],[endLocation lowercaseString]];
}

@end
