//
//  MVSettingsDatas.h
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MVSettingsDatas : NSObject

@property (readonly) NSUInteger nbLevels;
@property (readonly) NSUInteger nbPlayers;

//  Numéro de 0 a 4 correspondant à une image de playerx 
//  et à un index dans le PickerView de sélection du player
@property (readwrite) NSUInteger selectedPlayer;

//  Numéro de 0 à 4 correspondant à un index dans le PickerView de sélection du niveau
@property (readwrite) NSUInteger selectedLevel;

/**
 *  @brief  Renvoi une chaine de caractères formatée pour un niveau
 *  en vue de son affichage
 *
 *  @param level Numéro du niveau (indexé de 0 à 4)
 *
 *  @return Chaine de caractères formatée pour l'affichage du niveau
 *  
 *  @code
 *  NSString *theString = [self stringForLevel:2];
 *  return "Niveau : 3"
 *  @endcode
 */
- (NSString*)stringForLevel:(NSUInteger)level;

@end
