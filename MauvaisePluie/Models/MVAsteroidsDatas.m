//
//  MVAsteroids.m
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import "MVAsteroidsDatas.h"

@implementation MVAsteroidsDatas

@synthesize allAsteroids, maxAsteroids;

- (id)initWithMaxAsteroids:(NSUInteger)max
{
    self = [super init];
    
    if (self)
    {
        allAsteroids = [[NSMutableArray alloc] init];
        maxAsteroids = max;
    }
    
    return  self;
}

@end
