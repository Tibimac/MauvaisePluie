//
//  MVSettingsDatas.m
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import "MVSettingsDatas.h"

@implementation MVSettingsDatas

@synthesize nbPlayers, nbLevels, selectedPlayer, selectedLevel;


- (id)init
{
    self = [super init];
    
    if (self)
    {
        int i = 0;
        while ([UIImage imageNamed:[NSString stringWithFormat:@"player%d",i]])
        {
            i++;
        }
        nbPlayers = i;
        
        nbLevels  = 5;  // Nombre de niveau par défaut
        
        selectedPlayer = 0;  // Player 1 par défaut
        selectedLevel  = 2;  // Niveau 3 par défaut
    }

    return self;
}



- (NSString*)stringForLevel:(NSUInteger)level
{
    NSString *string= [NSString stringWithFormat:@"Niveau de difficulté %lu",(long)level+1];
    
    return string;
}

@end
