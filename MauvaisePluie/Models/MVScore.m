//
//  MVScore.m
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 29/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import "MVScore.h"

@implementation MVScore

@synthesize scoreNumber, playerName, levelNumber;

- (id)init
{
    self = [super init];
    
    if (self)
    {
        scoreNumber = nil;
        playerName = nil;
        levelNumber = nil;
    }
    
    return self;
}



- (id)initWithScore:(NSUInteger)score 
            atLevel:(NSUInteger)level
{
    self = [self init];
    
    if (self)
    {
        scoreNumber = [NSNumber numberWithInteger:score];
        levelNumber = [NSNumber numberWithInteger:level];
    }
    
    return self;
}



- (id)initWithScore:(NSUInteger)score 
          andPlayer:(NSString*)name 
            atLevel:(NSUInteger)level
{
    self = [self initWithScore:score atLevel:level];
    
    if (self)
    {
        if (name != nil)
        {
            playerName = name;
        }
    }
    
    return self;
}

@end
