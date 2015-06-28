//
//  Route.m
//  tssmap
//
//  Created by Vladimir Calfa on 26/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import "Route.h"


@implementation Route


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"bounds": @"bounds",
             @"legs": @"legs",
             @"overviewPolyline": @"overview_polyline",
             };
}

+ (NSValueTransformer *)boundsJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass: Bounds.class];
}

+ (NSValueTransformer *)legsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass: Leg.class];
}

- (GMSMutablePath *)path {

    GMSMutablePath *path = [GMSMutablePath path];
    
    [self.legs enumerateObjectsUsingBlock:^(Leg *leg, NSUInteger idx, BOOL *stop) {
        
        if (idx == 0) {
            [leg addStartPointToPath:path];
        }
        
        [leg addStepPointsToPath:path];
    }];
    
    return path;
}

- (GMSPath *)overviewPath {
    NSString *points = [self.overviewPolyline objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:points];
    return path;
}

- (Leg*)firstLeg {
    if (self.legs.count > 0) {
        return [self.legs objectAtIndex:0];
    }
    
    return nil;
}

- (Leg*)lastLeg {
    
    if (self.legs.count > 0) {
        return [self.legs objectAtIndex:self.legs.count-1];
    }
    
    return nil;
}

@end
