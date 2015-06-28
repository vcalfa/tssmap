//
//  Leg.m
//  tssmap
//
//  Created by Vladimir Calfa on 27/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import "Leg.h"

@implementation Leg

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    
    [d addEntriesFromDictionary:[super JSONKeyPathsByPropertyKey]];
    [d addEntriesFromDictionary:@{@"startAddress":@"start_address",
                                  @"endAddress":@"end_address",
                                  @"steps":@"steps",
        
             }] ;

    return d;
}


+ (NSValueTransformer *)stepsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass: Step.class];
}

- (void)addStepPointsToPath:(GMSMutablePath *)path {
    [self.steps enumerateObjectsUsingBlock:^(Step *step, NSUInteger idx, BOOL *stop) {
        [path addLatitude:step.endLocation.lat.doubleValue longitude:step.endLocation.lng.doubleValue];
    }];
}

- (void)addStartPointToPath:(GMSMutablePath *)path {
    [path addLatitude: self.startLocation.lat.doubleValue longitude: self.startLocation.lng.doubleValue];
}

@end
