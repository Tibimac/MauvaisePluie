//
//  MVScore.h
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 29/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVScore : NSObject

@property (readonly) NSNumber *scoreNumber;
@property (readonly, copy) NSString *playerName;
@property (readonly) NSNumber *levelNumber;

/**
 *  @brief  Initialise un nouveau Score avec score et niveau
 *
 *  @param score Le score réalisé par le joueur
 *  @param level Le niveau auquel le score a été réalisé
 *
 *  @return L'objet Score initialisé
 */
- (id)initWithScore:(NSUInteger)score 
            atLevel:(NSUInteger)level;

/**
 *  @brief  Initialise un nouveau Score avec score, nom joueur et niveau
 *
 *  @param score Le score réalisé par le joueur
 *  @param name  Le nom du joueur ayant réalisé le score
 *  @param level Le niveau auquel le score a été réalisé
 *
 *  @note Le nom (name) peut être à nil si le joeur n'a pas renseigné son nom
 *
 *  @return 
 */
- (id)initWithScore:(NSUInteger)score 
          andPlayer:(NSString*)name 
            atLevel:(NSUInteger)level;

@end
