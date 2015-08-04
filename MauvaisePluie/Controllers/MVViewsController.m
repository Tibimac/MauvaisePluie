//
//  MVViewController.m
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import "MVViewsController.h"

@implementation MVViewsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mainScreenFrame = [[UIScreen mainScreen] bounds];
    currentScore = nil;
    currentScoreIsNewBestScore = NO;
    asteroidsDatas = nil;
    theTimer = nil;
    tabSigne = [NSArray arrayWithObjects:[NSNumber numberWithInteger:-1], @1, nil];
    isPlaying = NO;
    
    
    // Représentation de l'écran et des "zones de sorties"
    //      +-----------------------------------------------------------------------+--+
    //      |////|                                                             |////|   \
    //      |/25/|                                                             |/25/|    \
    //      |////|                                                             |////|     \
    //      |/25/|                                                             |/25/|     /
    //      |////|                                                             |////|     \
    //      |/25/|                                                             |/25/|      \     Zone de sortie d'astéroides : ils ne comptent pas dans le score car
    //      |////|             ZONE DE CHUTES LIBRE DES ASTEROIDES             |////|       |>   ils sont sortis avant d'entrer dans la zone de déplacement du joueur (zone de collision)
    //      |/25/|                                                             |/25/|      /     (idem pour la même bande côté gauche de l'écran)
    //      |////|                                                             |////|     /
    //      |/25/|                                                             |/25/|     \
    //      |////|                                                             |////|     /
    //      |/25/|                                                             |/25/|    /
    //      |////|                           ((😃))                            |////|   /
    //      |----|-------------------------------------------------------------|----|--/
    //      |\20\|++++++++++++++++++++++ ZONE TEST COLLISION ++++++++++++++++++|\20\|   \
    //      |\50\|-- <== ZONE DE DEPLACEMENT DU PLAYER ET TEST COLLISION ==> --|\50\|    \      Zone de sorties d'astéroides : ils comptent dans le score car il sont passés
    //      |-----------------------------------------------------------------------|     |>    dans la zone de collision sans avoir de collision avec le joueur
    //      |\10\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\10\|    /      (idem pour les mêmes bandes côté gauche de l'écran)
    //      |\15\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\15\|   /
    //      +-----------------------------------------------------------------------+--+
    
    // Définition des "zones de sorties"
    // 25 = la moitié de la hauteur max d'un astéroide + 5 de marge| 50 = la hauteur de la zone de déplacement du player (car 50 est la hauteur de l'image du  player)
    // |==> Zones de sorties n'incrémentant pas le score
    // |=====> Zone gauche
    leftOutZoneAbovePlayer   = CGRectMake(mainScreenFrame.origin.x-25,    mainScreenFrame.origin.y, 25, mainScreenFrame.size.height);
    // |=====> Zone droite
    rightOutZoneAbovePlayer  = CGRectMake(CGRectGetMaxX(mainScreenFrame), mainScreenFrame.origin.y, 25, mainScreenFrame.size.height);
    
    // |==> Zones de sorties incrémentant le score
    // |=====> Zone gauche
    leftOutZoneNextToPlayer  = CGRectMake(mainScreenFrame.origin.x-25, CGRectGetMaxY(mainScreenFrame)-50-25, 25, 25+50);
    // |=====> Zone droite
    rightOutZoneNextToPlayer = CGRectMake(CGRectGetMaxX(mainScreenFrame), CGRectGetMaxY(mainScreenFrame)-50-25, 25, 25+50);
    // |=====> Zone sous l'écran
    outZoneBelowPlayer       = CGRectMake(mainScreenFrame.origin.x-25, CGRectGetMaxY(mainScreenFrame), 25+mainScreenFrame.size.width+25, 25);
    
    // |==> Zone de collision
    collisionZone            = CGRectMake(mainScreenFrame.origin.x, CGRectGetMaxY(mainScreenFrame)-50-25, mainScreenFrame.size.width, 25+50);
    
    
//  Vue Principale
//  ==============
    mainView = [[UIView alloc] initWithFrame:mainScreenFrame];
    [self setView:mainView];
    
    
//  Background
//  ==========
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallpaper"]];
    [backgroundImage setFrame:mainScreenFrame];
    [backgroundImage setContentMode:UIViewContentModeCenter];    
    
    // Celui-ci ne semble pas fonctionner mais j'ignore pourquoi (est-ce lié à l'orientation bloquée ?)
    // Une idée ?
    UIInterpolatingMotionEffect *effectH = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    [effectH setMinimumRelativeValue:@(-30)];
    [effectH setMinimumRelativeValue:@30];
    
    UIInterpolatingMotionEffect *effectV = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    [effectV setMinimumRelativeValue:@(-30)];
    [effectV setMaximumRelativeValue:@30];
    
    [backgroundImage addMotionEffect:effectH];
    [backgroundImage addMotionEffect:effectV];
    
    [mainView addSubview:backgroundImage];
    
    
    //  SettingsView
    //  ============
    settingsDatas = [[MVSettingsDatas alloc] init]; // Objet Model source pour PickerLevel et pour l'enregistrement des réglages
    
    settingsView = [[MVSettingsView alloc] initWithFrame:CGRectMake(0, -mainScreenFrame.size.height, mainScreenFrame.size.width, mainScreenFrame.size.height)];
    [settingsView setViewController:self];
    [[settingsView pickerPlayers] setDataSource:self];
    [[settingsView pickerPlayers] setDelegate:self];
    [[settingsView pickerLevels] setDataSource:self];
    [[settingsView pickerLevels] setDelegate:self];
    [settingsView setHidden:YES];
    
    //  GameView
    //  ========
    gameView = [[MVGameView alloc] initWithFrame:mainScreenFrame];
    [gameView setViewController:self];
    [[gameView player] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"player%lu", (unsigned long)[settingsDatas selectedPlayer]]]];
    
    
    //  ScoresView
    //  ==========
    scoresDatas = [[MVScoresDatas alloc] init]; // Objet Model pour l'enregistrement des scores
    
    scoresView = [[MVScoresView alloc] initWithFrame:CGRectMake(0, -mainScreenFrame.size.height, mainScreenFrame.size.width, mainScreenFrame.size.height)];
    [scoresView setViewController:self];
    [[scoresView txtFieldName] setDelegate:self];
    [scoresView setHidden:YES];
    
    
    [mainView addSubview:gameView];
    [mainView addSubview:scoresView];
    [mainView addSubview:settingsView];
    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//    {
        // Étant donné la manière dont sont placé les éléments sur l'interface, le décalage est également nécessaire pour l'iPad
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    }
}





/* ******************************************** */
/* ---------------- ScoresView ---------------- */
/* ******************************************** */
#pragma mark - ===== ScoresView =====

#pragma mark |--> Affichage
// Méthode appelée par le bouton "Scores" sur la GameView.
//  Cette méthode appelle simplement une autre méthode en passant nil
//  à la place du score pour signifier que la vue est appellée sans score
//  car elle n'est pas appellée suite à une partie perdue.
- (void)showScoresView
{   
    [scoresView setHidden:NO];
    
    if (currentScore == nil)
    {
        // Cas par défaut : on affiche la vue sans "Votre Socre : " et sans le champ de saisie
        [[scoresView yourScore]     setHidden:YES];
        [[scoresView txtFieldName]  setHidden:YES];
    }
    
    if (currentScore != nil && currentScoreIsNewBestScore == NO)
    {
        // Cas partie perdue sans un nouveau meilleur score : on affiche la vue avec "Votre score :" mais sans le champ de saisie
        [[scoresView yourScore]     setText:[NSString stringWithFormat:@"👎 Votre score : %d 👎",[currentScore intValue]]];
        [[scoresView yourScore]     setHidden:NO];
        [[scoresView txtFieldName]  setHidden:YES];
    }
    
    if (currentScore != nil && currentScoreIsNewBestScore == YES)
    {
        // Cas partie perdue avec un nouveau meilleur score : on affiche la vue avec "Votre score :" ET avec le champ de saisie
        [[scoresView yourScore]     setText:[NSString stringWithFormat:@"👍 Votre score : %d 👍",[currentScore intValue]]];
        [[scoresView yourScore]     setHidden:NO];
        [[scoresView txtFieldName]  setHidden:NO];
    }
    
    // Rafraîchissement du tableau des scores
    for (int i=0; i<5; i++)
    {
        for (int j=0; j<5; j++)
        {
            NSString *nameLabel = [NSString stringWithFormat:@"labelScore%d%d", i, j];
            UILabel *tempLabel = [[scoresView labelsScores] objectForKey:nameLabel];
            
            [tempLabel setText:[scoresDatas stringForScoreAtLevel:i andRank:j]];
        }
    }
    
    [UIView animateWithDuration:0.40 animations:
     ^{
         [scoresView setFrame:CGRectMake(0, 0, mainScreenFrame.size.width, mainScreenFrame.size.height)];
     }];
}


#pragma mark |--> Modification Nom (UITextFieldDelegate)
#pragma mark |-----> Déplacement vue avec le clavier
// Méthode appelée lorsque le clavier apparait et disparait
// Cette méthode anime la ScoreView pour la faire monter et descendre en même temps que le clavier
- (void)keyboardFrameDidChange:(NSNotification *)notification
{
    CGRect keyboardEndFrame   = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = scoresView.frame;
    CGRect keyboardFrameEnd   = [scoresView convertRect:keyboardEndFrame toView:nil];
    CGRect keyboardFrameBegin = [scoresView convertRect:keyboardBeginFrame toView:nil];
    
    newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y);
    [scoresView setFrame:newFrame];
    
    [UIView commitAnimations];
}


#pragma mark |-----> Début Édition - Déplacement ScoreView
// Lorsque l'utilisateur saisis son nom, le bouton OK est masqué
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[scoresView buttonDone] setHidden:YES];
}


#pragma mark |-----> Édition en cours - Vérification longueur
// Méthode appellée à chaque modification du texte dans le champ de saisie
// Cette méthode vérifie la longueur du texte pour bloquer la saisie une fois les 10 caractères atteint
- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger oldLength = [[textField text] length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 10 || returnKey; // 10 = Nombre max de caractères
}


#pragma mark |-----> Fin édition
//  Cette méthode est appellée lorsque l'édition du champ de saisi est terminée après que l'utilisateur est appuyé sur la touche "Terminer"
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[scoresView buttonDone] setHidden:NO];
    [[scoresView txtFieldName] resignFirstResponder];
    return YES;
}

// Méthode appellée lorsque l'utilisateur fait disparaitre le clavier sans toucher la touche "Terminé" du clavier
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[scoresView buttonDone] setHidden:NO];
    // Le txtFieldName n'est déjà plus FirstResponder car le clavier est masqué.
}


#pragma mark |--> Masquage
// Méthode appelée par le bouton "OK" de la vue des Scores (scoresView)
// Cette méthode fait remonter la vue avec une animation puis appele une autre méthode pour masquer la vue
//  une fois l'animation finie. 
- (void)hideScoresView
{
    if (currentScore != nil && currentScoreIsNewBestScore == YES) // Nouveau meilleur score = champ de saisie été affiché = enregistrement score
    {
        #pragma mark |--> Enregistrment d'un nouveau meilleur score
        BOOL isInserted = [scoresDatas addScore:[currentScore integerValue] forPlayer:[[scoresView txtFieldName] text] atLevel:[settingsDatas selectedLevel]];
        
        if (isInserted == NO)
        {
            UIAlertView *scoreInsertionError = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Désolé, une erreur s'est produite, le score n'as pas pu être enregistré et est perdu." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [scoreInsertionError show];
        }
        
        // Il faut maintenant réinitialiser le currentScore ...
        currentScore = nil;
        currentScoreIsNewBestScore = NO;
        // ... et le champ de saisie
        [[scoresView txtFieldName] setText:nil];
    }
    
    [UIView animateWithDuration:0.40 animations:
     ^{
         [scoresView setFrame:CGRectMake(0, -mainScreenFrame.size.height, mainScreenFrame.size.width, mainScreenFrame.size.height)];
     }];
    
    if (isPlaying == YES) // Si le jeu été en cours, on revient à GameView en mode "Accueil"
    {
        // Suppression des asteroids de l'écran
        // ====================================
        for (MVAsteroidView *asteroidToRemove in [asteroidsDatas allAsteroids])
        {
            [asteroidToRemove removeFromSuperview];
        }
        
        // Suppression de tous les asteroids du tableau
        // ============================================
        [[asteroidsDatas allAsteroids] removeAllObjects];
        asteroidsDatas = nil;
        
        
        // Affichage des boutons de la vue d'accueil
        // ========================================
        [[gameView buttonScores] setHidden:NO];
        [[gameView buttonPlay] setHidden:NO];
        [[gameView buttonSettings] setHidden:NO];

        // Masquage des label et des flèches de déplacement
        // =================================================
        [[gameView labelScore] setHidden:YES];
        [[gameView labelScore] setText:nil];
        [[gameView labelLevel] setHidden:YES];
        [[gameView labelLevel] setText:nil];
        [[gameView goLeft] setHidden:YES];
        [[gameView goRight] setHidden:YES];
        
        isPlaying = NO; // Jeu fini
    }
    
    // Impossible de faire le setHidden:YES ici car la ligne serait executé pendant l'animation !
    // Il faut donc, après la durée de l'animation appeller une méthode tierce qui s'occupe de faire le setHidden:YES
    [self performSelector:@selector(hideViewsAfterAnimation:) withObject:scoresView afterDelay:0.40 ];
}





/* ****************************************** */
/* ---------------- GameView ---------------- */
/* ****************************************** */
#pragma mark - ===== GameView =====
#pragma mark |==> Lancement du jeu
// Méthode appelée par le bouton "Jouer" de la GameView
// Cette méthode masque les bouton de l'accueil est met la
//  la GameView en mode jeu.
- (void)playGame
{
    isPlaying = YES;
    currentScore = [NSNumber numberWithInt:0];
    compteur = 0; // Réinitialisé à chaque début de partie    
    NSUInteger currentSelectedLevel = [settingsDatas selectedLevel]+1; // currentSelectedLevel va de 0+1(1) à 4+1(5)
    
    
    // Objet Model pour le stockage des asteroids créés
    // ================================================
    NSUInteger maxAsteroids;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        maxAsteroids = 4 + (3 * currentSelectedLevel);
    }
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        maxAsteroids = 8 + (2 * currentSelectedLevel);
    }
    asteroidsDatas = [[MVAsteroidsDatas alloc] initWithMaxAsteroids:maxAsteroids];
    
    
    // Paramètres du jeu en fonction du niveau
    // =======================================
    maxMoveV = (3 + (2 * currentSelectedLevel));
    NSTimeInterval refreshTime = (1.0/(20.0 + (4.0 * (float)currentSelectedLevel)));
    
    
    // Masquage des boutons de la vue d'accueil
    // ========================================
    [[gameView buttonScores] setHidden:YES];
    [[gameView buttonPlay] setHidden:YES];
    [[gameView buttonSettings] setHidden:YES];
    
    
    // Modification de la couleur des fléches de déplacement en fonction du player sélectionné
    // =======================================================================================
    switch ([settingsDatas selectedPlayer])
    {
        case 0:
            [[gameView goLeft]  setTintColor:[UIColor colorWithRed:0.96 green:0.86 blue:0.23 alpha:1]];
            [[gameView goRight] setTintColor:[UIColor colorWithRed:0.96 green:0.86 blue:0.23 alpha:1]];
            break;
        case 1:
            [[gameView goLeft]  setTintColor:[UIColor colorWithRed:0.64 green:0.8 blue:0.31 alpha:1]];
            [[gameView goRight] setTintColor:[UIColor colorWithRed:0.64 green:0.8 blue:0.31 alpha:1]];
            break;
        case 2:
            [[gameView goLeft]  setTintColor:[UIColor colorWithRed:0.17 green:0.42 blue:0.72 alpha:1]];
            [[gameView goRight] setTintColor:[UIColor colorWithRed:0.17 green:0.42 blue:0.72 alpha:1]];
            break;
        default:
            break;
    }
    
    
    // Affichage des label et des flèches de déplacement
    // =================================================
    [[gameView labelScore] setHidden:NO];
    [[gameView labelScore] setText:@"Score : 0"];
    [[gameView labelLevel] setHidden:NO];
    [[gameView labelLevel] setText:[NSString stringWithFormat:@"Niveau : %lu", (unsigned long)[settingsDatas selectedLevel]+1]];
    
    [[gameView goLeft] setHidden:NO];
    [[gameView goRight] setHidden:NO];
    

/********/  // En remplacant le paramètre refreshTime par 0.25 on peut se rendre compte sur le jeu que tant qu'il n'y a pas d'asteroid créé le joueur peut se déplacer sans
/* INFO */  // problème et que c'est lors de la création d'un asteroid que le joueur est remis à sa place par défaut...
/********/    
    theTimer = [NSTimer scheduledTimerWithTimeInterval:refreshTime target:self selector:@selector(controlGame) userInfo:nil repeats:YES];
}



#pragma mark |==> Contrôle du jeu (NSTimer)
// Méthode appellée par le NSTimer
// Cette méthode vérifie la position des asteroids pour détecter ceux sortis de l'écran ou entré en collision avec le joueur
// puis agit en fonction de ça pour supprimer les asteroids, stopper le je, créer de nouveaux asteroids etc..
- (void)controlGame
{
    compteur++;
    
    BOOL isCollidedWithPlayer = NO;
    NSMutableArray *asteroidsToRemove = nil;
    asteroidsToRemove = [[NSMutableArray alloc] init];
    
    #pragma mark Zones de collision sur le joueur
    // Création des zones de collision sur le player
    // =============================================
    CGRect collidedZone1;
    CGRect collidedZone2;
    CGRect collidedZone3;
    switch ([settingsDatas selectedPlayer])
    {
        case 0:
            collidedZone1 = CGRectMake([gameView player].frame.origin.x,    [gameView player].frame.origin.y+20, [gameView player].frame.size.width,        [gameView player].frame.size.height);
            collidedZone2 = CGRectMake([gameView player].frame.origin.x,    [gameView player].frame.origin.y+20, [gameView player].frame.size.width,        [gameView player].frame.size.height);
            collidedZone3 = CGRectMake([gameView player].frame.origin.x,    [gameView player].frame.origin.y+20, [gameView player].frame.size.width,        [gameView player].frame.size.height);
            break;
        case 1:
            collidedZone1 = CGRectMake([gameView player].frame.origin.x+18, [gameView player].frame.origin.y+24, [gameView player].frame.size.width-18-15,  [gameView player].frame.size.height-24-47); // Tête
            collidedZone2 = CGRectMake([gameView player].frame.origin.x,    [gameView player].frame.origin.y+50, [gameView player].frame.size.width,        [gameView player].frame.size.height-50-30); // Bras
            collidedZone3 = CGRectMake([gameView player].frame.origin.x+20, [gameView player].frame.origin.y+70, [gameView player].frame.size.width-20-20,  [gameView player].frame.size.height-70);    // Jambes
            break;
        case 2:
            collidedZone1 = CGRectMake([gameView player].frame.origin.x+10, [gameView player].frame.origin.y+35, [gameView player].frame.size.width-65,     [gameView player].frame.size.height-35);    // Aile gauche
            collidedZone2 = CGRectMake([gameView player].frame.origin.x+34, [gameView player].frame.origin.y,    [gameView player].frame.size.width-34-34,  [gameView player].frame.size.height-20);    // Fuselage
            collidedZone3 = CGRectMake([gameView player].frame.origin.x+66, [gameView player].frame.origin.y+35, [gameView player].frame.size.width-66-7,   [gameView player].frame.size.height-35);    // ile droite
            break;
        default:
            break;
    }
    
    
    #pragma mark Vérification position des asteroids
    // Vérification position des asteroids
    // ===================================
    for (MVAsteroidView *asteroid in [asteroidsDatas allAsteroids])
    {
        BOOL isOutAbovePlayer    = NO;
        BOOL isOutNextToPlayer   = NO;
        BOOL isOutBelowPlayer    = NO;
        
        CGPoint asteroidPositionCenter  = [asteroid center];
        CGRect  asteroidFrame           = [asteroid frame];
    
        CGPoint pointToCheckInLeftZones     = CGPointMake(asteroidPositionCenter.x+((asteroidFrame.size.width/2)+1), asteroidPositionCenter.y); // X = centre.x + la moitié de la largeur de la frame de l'asteroid
        CGPoint pointToCheckInRightZones    = CGPointMake(asteroidPositionCenter.x-((asteroidFrame.size.width/2)+1), asteroidPositionCenter.y); // X = centre.x - la moitié de la largeur de la frame de l'asteroid
        CGPoint pointToCheckInBelowZone     = CGPointMake(asteroidPositionCenter.x, asteroidPositionCenter.y-((asteroidFrame.size.height/2)+1));// Y = centre.y - la moitié de la hauteur de l'asteroid
        CGPoint pointToCheckInCollisionZone = CGPointMake(asteroidPositionCenter.x, asteroidPositionCenter.y+(asteroidFrame.size.height/2));    // Y = centre.y + la moitié de la hauteur de l'asteroid
        
        // Test Zones AbovePlayer
        // ======================        
        if (CGRectContainsPoint(leftOutZoneAbovePlayer, pointToCheckInLeftZones) || CGRectContainsPoint(rightOutZoneAbovePlayer, pointToCheckInRightZones))
        {
            isOutAbovePlayer = YES;
        }
        
        // Test Zones NextToPlayer
        // =======================
        if ((isOutAbovePlayer == NO) && ((CGRectContainsPoint(leftOutZoneNextToPlayer, pointToCheckInLeftZones) || CGRectContainsPoint(rightOutZoneNextToPlayer, pointToCheckInRightZones))))
        {
            isOutNextToPlayer = YES;
        }
        
        // Test Zone BelowPlayer
        // =====================
        if ((isOutAbovePlayer == NO && isOutNextToPlayer == NO) && (CGRectContainsPoint(outZoneBelowPlayer, pointToCheckInBelowZone)))
        {
            isOutBelowPlayer = YES;
        }
        
        // Test Zone de Collision
        // ======================
        if ((isOutAbovePlayer == NO && isOutNextToPlayer == NO && isOutBelowPlayer == NO) && (CGRectContainsPoint(collisionZone, pointToCheckInCollisionZone)))
        {
            // Test Collission entre l'asteroid et le player
            // =============================================
            // L'astéroid pourrait toucher le joueur sur un de ses 4 côtés, on défini 4 points de contact possible
            CGPoint asteroidPointToCheckAtLeft  = CGPointMake(asteroidPositionCenter.x - (asteroidFrame.size.width/2), asteroidPositionCenter.y);
            CGPoint asteroidPointToCheckAtRight = CGPointMake(asteroidPositionCenter.x + (asteroidFrame.size.width/2), asteroidPositionCenter.y);
            CGPoint asteroidPointToCheckAtBelow = CGPointMake(asteroidPositionCenter.x, asteroidPositionCenter.y + (asteroidFrame.size.height/2));
            CGPoint asteroidPointToCheckAtTop   = CGPointMake(asteroidPositionCenter.x, asteroidPositionCenter.y - (asteroidFrame.size.height/2));            
            
            // On test les 4 points de contact possible définis ci-dessus dans les 3 zones de collision définies en fonction du joueur
            if (CGRectContainsPoint(collidedZone1, asteroidPointToCheckAtLeft) || CGRectContainsPoint(collidedZone1, asteroidPointToCheckAtRight) || CGRectContainsPoint(collidedZone1, asteroidPointToCheckAtBelow) || CGRectContainsPoint(collidedZone1, asteroidPointToCheckAtTop) ||
                CGRectContainsPoint(collidedZone2, asteroidPointToCheckAtLeft) || CGRectContainsPoint(collidedZone2, asteroidPointToCheckAtRight) || CGRectContainsPoint(collidedZone2, asteroidPointToCheckAtBelow) || CGRectContainsPoint(collidedZone2, asteroidPointToCheckAtTop) ||
                CGRectContainsPoint(collidedZone3, asteroidPointToCheckAtLeft) || CGRectContainsPoint(collidedZone3, asteroidPointToCheckAtRight) || CGRectContainsPoint(collidedZone3, asteroidPointToCheckAtBelow) || CGRectContainsPoint(collidedZone3, asteroidPointToCheckAtTop)) 
            {
                isCollidedWithPlayer = YES;
            }
        }
        
        
        #pragma mark Actions sur l'asteroid
        // Actions sur l'asteroid
        // ======================
        if (isOutAbovePlayer == YES)
        {
            [asteroid removeFromSuperview];
            // Il faut stocker les asteroid a supprimer dans un tableau séparé
            // Car il est impossible de supprimer un élément d'un tableau pendant que le tableau est parcouru
            [asteroidsToRemove addObject:asteroid];
        }
        else if (isOutNextToPlayer == YES || isOutBelowPlayer == YES)
        {
            // Il faut stocker les asteroid a supprimer dans un tableau séparé
            // Car il est impossible de supprimer un éléments d'un tableau pendant que le tableau est parcouru
            [asteroidsToRemove addObject:asteroid];
            
            // Incrémentation du score
            int newCurrentScore = [currentScore intValue]+1;
            currentScore = nil;
            currentScore = [NSNumber numberWithInt:newCurrentScore];
            [[gameView labelScore] setText:[NSString stringWithFormat:@"Score : %d", [currentScore intValue]]];
        }
        else // L'asteroid n'est pas sorti de l'écran alors on le fait bouger
        {            
            // Rotation
            // ========
            CGFloat angleToRotation = [asteroid lastRotationAngle] + [asteroid rotationAngle];
            if (angleToRotation > 6.2831853 || angleToRotation < -6.2831853)
            {
                angleToRotation = 0.0;
            }
            
///* DEBUG */ NSLog(@"Angle Précédent : %.5f | Nouvel angle de rotation : %.5f",[asteroid lastRotationAngle] , angleToRotation);
            
            [asteroid setLastRotationAngle:angleToRotation];
            [[asteroid imageAsteroid] setTransform:CGAffineTransformMakeRotation(angleToRotation)]; 
            
            // Déplacement
            // ===========
            [asteroid setCenter:CGPointMake((asteroidPositionCenter.x+[asteroid horizontalMove]), (asteroidPositionCenter.y+[asteroid verticalMove]))];
        }
    }
    
    
    // Suppression des asteroids sortis de l'écran
    // ===========================================
    for (MVAsteroidView *theAsteroidToRemove in asteroidsToRemove)
    {
        [[asteroidsDatas allAsteroids] removeObject:theAsteroidToRemove];
    }
    asteroidsToRemove = nil;
    
    
    #pragma mark Création Astéroid
    // Création d'un nouvel astéroid
    // =============================
    if (isCollidedWithPlayer == NO) // Création inutile s'il y a eu collision
    {
        // Probabilité (pour la création d'un nouvel astéroid)
        NSUInteger proba = arc4random() % 101 + compteur;
        
        if (([[asteroidsDatas allAsteroids] count] < [asteroidsDatas maxAsteroids]) && (compteur >= 30) && (proba > 50))
        {
            // Valeur déplacement vertical
            // ===========================;
            NSUInteger vMove = (arc4random() % maxMoveV)+1;
            
            // Valeur déplacement horizontal
            // =============================
            NSUInteger  hTabInd = arc4random() % [tabSigne count];                  // Tire aléatoirement 0 ou 1
            NSInteger   hSigne  = [[tabSigne objectAtIndex:hTabInd] integerValue];  // Récupération du nombre (-1 ou 1)
            NSInteger   hMove   = (1 * hSigne);                                     // hMove = -1 ou 1
            
            // Rotation
            // ========
            //  Principe établi : un astéroid fait maximum 1 tour complet en 1sec
            //  - 1 tour = 360°
            //  - 1sec = 24img/sec soit 24 boucle du timer/sec
            //  - 360°/24 = 15° ainsi un asteroid tournant de 15° max a chaque
            //  - boucle du timer aura tourné de 360° en 1sec soit le 1 tour maximum
            //
            //  Principe établi : un astéroid tourne forcément d'au moins 18°/sec (5%) a chaque fois
            //  - 18°/24 = 0,75° à chaque boucle du timer
            //
            //  Angle de rotation minimum a chaque mouvement : 0,75°
            //  Angle de rotation maximum à chaque mouvement : 15°
            //
            //  Il faut donc tirer aléatoirement un nombre entre 0,75 et 15,0
            NSInteger   rotationAngle   = (arc4random() % 16);                      // Tirage aléatoire d'un angle (exprimé en degrés)
            if (rotationAngle == 0) { rotationAngle = 0.75; }                       // Si le tirage donne 0 alors on affecte le degré de rotation minimum
            CGFloat angleInRadian = GLKMathDegreesToRadians(rotationAngle);         // Conversion en radian
            NSUInteger  vTabInd = arc4random() % [tabSigne count];                  // Tire aléatoirement 0 ou 1
            NSInteger   rSigne  = [[tabSigne objectAtIndex:vTabInd] integerValue];  // Récupération du nombre (-1 ou 1)
            angleInRadian = (angleInRadian * rSigne);                               // angle * 1 ou -1 pour tourner dans un sens ou dans l'autre
            
            // Position de départ en x
            // =======================
            //  Si la valeur de déplacement horizontale est négative alors l'astéroid partira au minimum de 25% de la largeur de l'écran
            //  Si la valeur de déplacement horizontale est positive alors l'astéroid partira au maximum de 75% de la largeur de l'écran
            NSUInteger startPositionX = arc4random() % (int)((mainScreenFrame.size.width)+1);   // Position entre 0 et largeur de l'écran
            NSUInteger minStart = (((mainScreenFrame.size.width)/100)*10);                      // Position de départ minimum à 10% de l'écran
            NSUInteger maxStart = (((mainScreenFrame.size.width)/100)*90);                      // Position de départ maximum à 90% de l'écran
            
            if ((hMove < 0) && (startPositionX > maxStart))
            {
                startPositionX = maxStart;
            }
            else if ((hMove > 0) && (startPositionX < minStart))
            {
                startPositionX = minStart;
            }
            
            CGPoint startPosition = CGPointMake(startPositionX, -21); // Position de départ du centre de l'astéroid
            
            // Création du nouvel objet MVAsteroidView
            // =======================================
            MVAsteroidView *newAsteroid = [[MVAsteroidView alloc] initWithVerticalMove:vMove andHorizontalMove:hMove andRotationAngle:angleInRadian];
            [newAsteroid setFrame:CGRectMake(startPosition.x, startPosition.y, [[newAsteroid imageAsteroid] image].size.width, [[newAsteroid imageAsteroid] image].size.height)];
            [[newAsteroid imageAsteroid] setFrame:CGRectMake(startPosition.x, startPosition.y, [[newAsteroid imageAsteroid] image].size.width, [[newAsteroid imageAsteroid] image].size.height)];
            
            [[asteroidsDatas allAsteroids] addObject:newAsteroid];
            [gameView addSubview:newAsteroid];

            newAsteroid = nil;
            compteur = 0;
        }
    }
    #pragma mark Arrêt du jeu
    // Arrêt du jeu si collision
    // =========================
    else if (isCollidedWithPlayer == YES)
    {
        [theTimer invalidate];
        theTimer = nil;
        
        // Création du label "Game Over"
        // ============================
        gameOverView = [[UILabel alloc] init];
        [gameOverView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [gameOverView setFont:[UIFont systemFontOfSize:40.0]];
        [gameOverView setText:@"😕 Game Over 😕"];
        [gameOverView setTextColor:[UIColor redColor]];
        [gameView addSubview:gameOverView];
        
        NSNumber *middleHLabel = [NSNumber numberWithDouble:(mainScreenFrame.size.width/2)-175];
        [gameView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(middleLabel)-[gameOverView(350)]-(middleLabel)-|" options:0 metrics:@{@"middleLabel":middleHLabel} views:@{@"gameOverView":gameOverView}]];
        NSNumber *middleVLabel = [NSNumber numberWithDouble:(mainScreenFrame.size.height/2)-25];
        [gameView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(middleVLabel)-[gameOverView(50)]-(middleVLabel)-|" options:0 metrics:@{@"middleVLabel":middleVLabel} views:@{@"gameOverView":gameOverView}]];
        
        // Lancement timer
        // ===============
        NSTimer *timerGameover;
        timerGameover = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(hideGameOverAndLaunchScoresView) userInfo:nil repeats:NO];
    }
}

- (void)hideGameOverAndLaunchScoresView
{
    // Vérification du score par rapport au plus petit score du niveau
    if ([currentScore intValue] > [[scoresDatas minScoreForLevel:[settingsDatas selectedLevel]] intValue])
    {
        currentScoreIsNewBestScore = YES;
    }
    else
    {
        currentScoreIsNewBestScore = NO;
    }
    
    [gameOverView removeFromSuperview];
    gameOverView = nil;
    
    [self showScoresView];
}





/* ********************************************** */
/* ---------------- SettingsView ---------------- */
/* ********************************************** */
#pragma mark - ===== SettingsView =====
#pragma mark |--> Affichage
// Méthode appelée par le bouton "Réglages" de la vue GameView
// Cette méthode règle la valeur affichée par les pickers à la valeur présente dans les réglages
//  puis rend la vue visible et la fait descendre avec une animation.
- (void)showSettingsView
{
    [[settingsView pickerPlayers] selectRow:[settingsDatas selectedPlayer] inComponent:0 animated:NO];
    [[settingsView pickerLevels]  selectRow:[settingsDatas selectedLevel]  inComponent:0 animated:NO];
    [settingsView setHidden:NO];
    
    [UIView animateWithDuration:0.40 animations:
     ^{
         [settingsView setFrame:CGRectMake(0, 0, mainScreenFrame.size.width, mainScreenFrame.size.height)];
     }];
}


#pragma mark |-----> Méthodes UIPickerViewDataSource
#define PICKER_PLAYER_ROW_HEIGHT 50;
#define PICKER_LEVEL_ROW_HEIGHT 30;
//- (NSString*)pickerView:(UIPickerView *)pickerView 
//            titleForRow:(NSInteger)row 
//           forComponent:(NSInteger)component
//{
//    NSString *titleForRow = nil;
//    
//    if ([pickerView tag] == 2)
//    {
//        return [[[settingsDatas pickerLevelDatas] objectAtIndex:component] objectAtIndex:row];
//    }
//    
//    return titleForRow;
//}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    CGFloat height = 0;
    
    if ([pickerView tag] == 1)
    {
        height = PICKER_PLAYER_ROW_HEIGHT;
    }
    else if ([pickerView tag] == 2)
    {
        height = PICKER_LEVEL_ROW_HEIGHT;
    }
    
    return height;
}

- (UIView*)pickerView:(UIPickerView *)pickerView 
           viewForRow:(NSInteger)row 
         forComponent:(NSInteger)component 
          reusingView:(UIView *)view
{
    int pPHeight = PICKER_PLAYER_ROW_HEIGHT;
    int pLHeight = PICKER_LEVEL_ROW_HEIGHT;
    UIView *viewForRow = nil;
    
    
    if (view)
    {
        viewForRow = view;
    }
    else if (view == nil)
    {
        viewForRow = [[UIView alloc] init];
    }
    
    if ([pickerView tag] == 1)
    {
        UIImageView *playerView = [[UIImageView alloc] initWithFrame:CGRectMake(([[settingsView pickerPlayers] bounds].size.width/2)-25, 0, pPHeight, pPHeight)];
        [playerView setTag:1];
        [playerView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"player%lu",(unsigned long)row]]];
        [playerView setContentMode:UIViewContentModeScaleAspectFit];
        
        [viewForRow addSubview:playerView];
    }
    else if ([pickerView tag] == 2)
    {
        UILabel *level = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[settingsView pickerLevels] bounds].size.width, pLHeight)];
        [level setTag:1];
        [level setText:[settingsDatas stringForLevel:row]];
        [level setTextColor:[UIColor whiteColor]];
        [level setTextAlignment:NSTextAlignmentCenter];
        
        //        if (oldLabel != nil) {
//                        [oldLabel setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]]; }
        //        selectedLabel = (UILabel*)[[pickerView viewForRow:row forComponent:component] viewWithTag:1];
        //        [selectedLabel setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]+10]];
        //        [selectedLabel setNeedsDisplay];
        //        oldLabel = selectedLabel;
        
        [level setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]+7.5]];
        
        [viewForRow addSubview:level];
    }
    
    return viewForRow;
}

#pragma mark |-----> Enregistrement élément sélectionné dans un UIPicker
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if ([pickerView tag] == 1)
    {
        [settingsDatas setSelectedPlayer:row];
        [[gameView player] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"player%lu",(unsigned long)row]]];
    }
    else if ([pickerView tag] == 2)
    {
        [settingsDatas setSelectedLevel:row];
    }
}


#pragma mark |-----> Méthodes UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger nbComponents = 0;
    
    if ([pickerView tag] == 1) // Picker Choix Player
    {
        nbComponents = 1;
    }
    else if ([pickerView tag] == 2) // Picker Choix Niveau
    {
        nbComponents = 1;
    }
    
    return nbComponents;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger nbRows = 0;
    
    if ([pickerView tag] == 1) // Picker Choix Player
    {
        nbRows = [settingsDatas nbPlayers];
    }
    else if ([pickerView tag] == 2) // Picker Choix Niveau
    {
        nbRows = [settingsDatas nbLevels]; // Nombre de niveau de difficulté
    }
    
    return nbRows;
}


#pragma mark |--> Masquage
// Méthode appelée par le bouton "OK" de la vue des Réglages (settingsView)
// Cette méthode fait remonter la vue avec une animation puis appele une autre méthode pour masquer la vue
//  une fois l'animation finie.
- (void)hideSettingsView
{
    [UIView animateWithDuration:0.40 animations:
     ^{
         [settingsView setFrame:CGRectMake(0, -mainScreenFrame.size.height, mainScreenFrame.size.width, mainScreenFrame.size.height)];
     }];
    
    // Impossible de faire le setHidden:YES ici car la ligne serait executé pendant l'animation !
    // Il faut donc, après la durée de l'animation appeller une méthode tierce qui s'occupe de faire le setHidden:YES
    [self performSelector:@selector(hideViewsAfterAnimation:) withObject:settingsView afterDelay:0.40 ];
}





#pragma mark - Masquage des vues (ScoresView et SettingsView)
// Méthode appelée par la vue des Scores (scoreView) et la vue des Réglages (settingsView)
//  une fois que les animations sont finies
-(void)hideViewsAfterAnimation:(id)sender
{
    if ([sender isEqual:scoresView])
    {
        [scoresView   setHidden:YES];
    }
    else if ([sender isEqual:settingsView])
    {
        [settingsView setHidden:YES];
    }
}





#pragma mark - Gestion mémoire
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
