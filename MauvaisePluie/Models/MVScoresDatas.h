//
//  MVScores.h
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVScore.h"

@interface MVScoresDatas : NSObject
{
    // Tableau contenant l'ensemble des scores
    NSArray *allScores;
    // Tableau du score minimal pour chaque niveau
    NSMutableArray *minScores;
}

/**
 *  @brief  Renvoi le plus petit score d'un niveau
 *
 *  @param level Niveau pour lequel on souhaite récupérer le plus petit score
 *
 *  @return Le score sous forme d'un entier non signé
 */
- (NSNumber*)minScoreForLevel:(NSUInteger)level;

/**
 *  @brief Ajoute un nouveau score dans le tableau des scores
 *
 *  @param score Score réalisé par le joueur
 *  @param name  Nom du joueur (si un nom a été saisi
 *  @param level Niveau auquel a été réalisé le score
 *  
 *  @note Un objet MVScore est créé avec les paramètres puis
 *  celui-ci est inseré dans le tableau qui est trié en fonction 
 *  des niveaux et des scores
 *
 *  @see MVScore.h et MVScore.m
 *
 *  @return Un booléen indiquant si l'insertion c'est bien déroulée (YES) ou non (NO)
 */
- (BOOL)addScore:(NSUInteger)newScore 
       forPlayer:(NSString*)name 
         atLevel:(NSUInteger)level;

/**
 *  @brief  Renvoi le score demandé sous forme d'une chaine de 
 *  caractères formaté en vue de son affichage
 *
 *  @param level Le niveau (indexé de 0 à 4) pour lequel on veux récupérer un score
 *  @param rank  Le rang (indexé de 0 à 4) pour lequel on veux récupérer le score
 *
 *  @return Chaîne de caractères formatée pour l'affichage du score
 *
 *  @code
 *  NSString *theString = [self stringForScoreAtLevel:2 andRank:1];
 *  return "Thibault : 150"
 *  @endcode
 */
- (NSString*)stringForScoreAtLevel:(NSUInteger)level andRank:(NSUInteger)rank;

@end
