//
//  MVAsteroidView.h
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVAsteroidView : UIView

@property (readonly)  UIImageView *imageAsteroid;
@property (readonly)  NSInteger verticalMove;
@property (readonly)  NSInteger horizontalMove;
@property (readonly)  CGFloat rotationAngle;
@property (readwrite) CGFloat lastRotationAngle;

/**
 *  @brief  Initialise un objet MVAsteroidView avec une image aléatoire et les paramètres transmis.
 *
 *  @param vMove    Valeur de déplacement vertical (positive ou négative) en points.
 *  @param hMove    Valeur de déplacement horizontal (positive ou négative) en points.
 *  @param rotation Valeur de l'angle de rotation, en radian, a appliquer à chaque mouvement
 *
 *  @return La vue MVAsteroidView créée.
 */
- (id)initWithVerticalMove:(NSUInteger)vMove 
         andHorizontalMove:(NSInteger)hMove 
          andRotationAngle:(CGFloat)angle;

@end
