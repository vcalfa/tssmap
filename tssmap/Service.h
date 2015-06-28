//
//  Service.h
//  tssmap
//
//  Created by Vladimir Calfa on 27/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#define GOOGLE_MAPS_API_KEY @"AIzaSyBdDQONtIA5l38wYAVETKtD9cJX8tNnhSc"
#define GOOGLE_MAPS_SERVER_API_KEY  @"AIzaSyAXJv7eYwER4B3jNQ-mAX-pihS9RHZe9FU"

typedef void (^ServiceCompletitionBlock)(BOOL success, id object, NSError *error);


@interface Service : NSObject

+ (instancetype)sharedInstance;
- (void)requestDirectionFrom:(NSString*)startLocation to:(NSString*)endlocation withCompletition:(ServiceCompletitionBlock)completition;

@end
