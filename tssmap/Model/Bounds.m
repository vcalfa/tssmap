//
//  Bounds.m
//  tssmap
//
//  Created by Vladimir Calfa on 27/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import "Bounds.h"

@implementation Bounds


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"northeast": @"southwest",
             @"southwest": @"southwest",
             };
}

+ (NSValueTransformer *)northeastJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass: Location.class];
}

+ (NSValueTransformer *)southwestJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass: Location.class];
}

@end
