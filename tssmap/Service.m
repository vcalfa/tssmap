//
//  Service.m
//  tssmap
//
//  Created by Vladimir Calfa on 27/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import "Service.h"
#import "Directions.h"
#import "AppData.h"

@interface Service ()

@property (nonatomic, strong) AFURLSessionManager *urlSessionManager;

@end

@implementation Service


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        [self.urlSessionManager setResponseSerializer: [AFJSONResponseSerializer serializer]];
    }

    return self;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

NSString *encodeToPercentEscapeString(NSString *string) {
    return (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef) string,
                                            NULL,
                                            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
}

- (void)requestDirectionFrom:(NSString*)startLocation
                          to:(NSString*)endLocation
            withCompletition:(ServiceCompletitionBlock)completition {
    
    NSParameterAssert(startLocation);
    NSParameterAssert(endLocation);
    
    Directions *cachedDirection = [[AppData sharedInstance] chachedDirectionFromStartLocation:startLocation toEndLocation:endLocation];
    
    if (cachedDirection) {
        completition(YES, cachedDirection, nil);
        return;
    }
    
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&waypoints=&key=%@",encodeToPercentEscapeString(startLocation), encodeToPercentEscapeString(endLocation), GOOGLE_MAPS_SERVER_API_KEY]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task = [self.urlSessionManager dataTaskWithRequest:request
                              completionHandler:^(NSURLResponse *response, NSDictionary *responseObject, NSError *error) {
                                  
                                  
                                  NSString *status = [responseObject objectForKey:@"status"];
                                  
                                  if ([status isEqualToString:@"OK"]) {
                                  
                                      NSError *error = nil;
                                      Directions *directions = [MTLJSONAdapter modelOfClass:Directions.class fromJSONDictionary: responseObject error:&error];
                                      directions.startLocation = startLocation;
                                      directions.endLocation = endLocation;
                                      
                                      [[AppData sharedInstance] addDirection:directions];
                                      
                                      completition(YES, directions, error);
                                  }
                                  else {
                                      completition(NO,nil, error);
                                  }
        
                                  
    }];
    
    [task resume];
}



@end
