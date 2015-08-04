//
//  MVGameView.h
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MVViewsController;

@interface MVGameView : UIView
{
    CGFloat rightLimit;
    CGFloat leftLimit;
    
    NSTimer *timerForMovePlayerToLeft;
    NSTimer *timerForMovePlayerToRight;
}

@property (readwrite) MVViewsController *viewController;

// Bouttons de la vue d'accueil
@property (readonly) UIButton *buttonScores;
@property (readonly) UIButton *buttonPlay;
@property (readonly) UIButton *buttonSettings;

// Labels et Bouttons pour le jeu
@property (readonly) UILabel *labelScore;
@property (readonly) UILabel *labelLevel;
@property (readonly) UIButton *goLeft;
@property (readonly) UIButton *goRight;

// Image du joueur
@property (readonly) UIImageView *player;

@end
