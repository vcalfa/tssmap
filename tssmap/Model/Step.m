//
//  Step.m
//  tssmap
//
//  Created by Vladimir Calfa on 27/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import "Step.h"

@implementation Step

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    
    [d addEntriesFromDictionary:[super JSONKeyPathsByPropertyKey]];
    [d addEntriesFromDictionary:@{@"htmlInstructions":@"html_instructions",
                                  @"travelMode":@"travel_mode",
                                  @"polyline":@"polyline.points",
                                  @"maneuver":@"maneuver",
                                  }] ;
    
    return d;
}

@end
