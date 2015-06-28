//
//  RouteInfo.m
//  tssmap
//
//  Created by Vladimir Calfa on 27/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import "RouteInfo.h"

@implementation RouteInfo


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"distanceText": @"distance.text",
             @"distanceValue": @"distance.value",
             @"durationText": @"duration.text",
             @"durationValue": @"duration.value",
             @"startLocation": @"start_location",
             @"endLocation": @"end_location",
            };
}

+ (NSValueTransformer *)startLocationJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass: Location.class];
}

+ (NSValueTransformer *)endLocationJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass: Location.class];
}

@end
