//
//  MVViewController.h
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVGameView.h"
#import "MVAsteroidView.h"
#import "MVAsteroidsDatas.h"
#import "MVScoresView.h"
#import "MVScoresDatas.h"
#import "MVSettingsView.h"
#import "MVSettingsDatas.h"
#import <GLKit/GLKit.h>

@interface MVViewsController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    CGRect mainScreenFrame;
    // Zones de sorties des astéroides
    CGRect leftOutZoneAbovePlayer;
    CGRect rightOutZoneAbovePlayer;
    CGRect leftOutZoneNextToPlayer;
    CGRect rightOutZoneNextToPlayer;
    CGRect collisionZone;
    CGRect outZoneBelowPlayer;
    
    // Objet stockant le nombre de point lors d'une partie en cours
    // Est utilisé par la ScoreView lors de la disparition pour l'enregistrement du score
    NSNumber *currentScore;
    BOOL currentScoreIsNewBestScore;
    
    // Tableau contenant 2 valeurs : -1 et 1
    // Sert à la génération des variables aléatoire (voir méthode playGame)
    NSArray *tabSigne;
    // Compteur incrémenté par le timer à chaque appel de la méthode liée au timer
    NSInteger compteur;
    
    NSTimer *theTimer;
    NSUInteger maxMoveV;
    
    BOOL isPlaying;
    
    
    // Views
    UIView *mainView; // Vue principale de base contenant une UIImageView pour le fond

    // Vues du jeu
    MVGameView *gameView;
    UILabel *gameOverView;
    MVSettingsView *settingsView;
    MVScoresView *scoresView;
    
    // Models
    MVScoresDatas *scoresDatas;
    MVAsteroidsDatas *asteroidsDatas;
    MVSettingsDatas *settingsDatas;
}

- (void)showScoresView;
- (void)hideScoresView;
- (void)playGame;
- (void)showSettingsView;
- (void)hideSettingsView;

@end

