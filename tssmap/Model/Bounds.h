//
//  Bounds.h
//  tssmap
//
//  Created by Vladimir Calfa on 27/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import "AppModelObject.h"
#import "Location.h"

@interface Bounds : AppModelObject

@property (nonatomic, strong) Location *northeast;
@property (nonatomic, strong) Location *southwest;


@end
