//
//  Location.m
//  tssmap
//
//  Created by Vladimir Calfa on 27/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import "Location.h"

@implementation Location

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"lat": @"lat",
             @"lng": @"lng",
             };
}


@end
