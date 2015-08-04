//
//  MVAsteroids.h
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVAsteroidsDatas : NSObject

@property (readonly) NSMutableArray *allAsteroids;
@property (readonly) NSUInteger maxAsteroids;

/**
 *  @brief  Initialise l'objet MVAsteroidsDatas qui contiendra l'ensemble des objets MVAsteroidView créé
 *
 *  @param maxAsteroid Nombre maximum d'asteroids pour la partie = capacité maximum du tableau
 *
 *  @return L'objet MVAsteroidsDatas initialisé
 */
- (id)initWithMaxAsteroids:(NSUInteger)max;

@end
