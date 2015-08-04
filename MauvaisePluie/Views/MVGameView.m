//
//  MVGameView.m
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import "MVGameView.h"
#import "MVViewsController.h"

@implementation MVGameView

@synthesize viewController, buttonScores, buttonPlay, buttonSettings, labelScore, labelLevel, goLeft, goRight, player;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //[self setTranslatesAutoresizingMaskIntoConstraints:NO];
        //[self setTag:1];
//        [self setBackgroundColor:[UIColor whiteColor]];
        timerForMovePlayerToLeft = nil;
        timerForMovePlayerToRight = nil;
    
    // Boutons d'affichage des vues
    // ============================
        buttonScores = [UIButton buttonWithType:UIButtonTypeSystem];
        [buttonScores setTranslatesAutoresizingMaskIntoConstraints:NO];    
        [buttonScores setTitle:@"Scores" forState:UIControlStateNormal];
        [buttonScores setTintColor:[UIColor whiteColor]];
        [buttonScores addTarget:viewController action:@selector(showScoresView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonScores];
    
        buttonPlay = [UIButton buttonWithType:UIButtonTypeSystem];
        [buttonPlay setTranslatesAutoresizingMaskIntoConstraints:NO];    
        [buttonPlay setTitle:@"Jouer" forState:UIControlStateNormal];
        [buttonPlay setTintColor:[UIColor whiteColor]];
        [buttonPlay addTarget:viewController action:@selector(playGame) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonPlay];
    
        buttonSettings = [UIButton buttonWithType:UIButtonTypeSystem];
        [buttonSettings setTranslatesAutoresizingMaskIntoConstraints:NO];
        [buttonSettings setTitle:@"Réglages" forState:UIControlStateNormal];
        [buttonSettings setTintColor:[UIColor whiteColor]];
        [buttonSettings addTarget:viewController action:@selector(showSettingsView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonSettings];
    
    // Labels
    // ======
        labelScore = [[UILabel alloc] init];
        [labelScore setTranslatesAutoresizingMaskIntoConstraints:NO];
        [labelScore setText:@"Score : 4444"];
        [labelScore setTextAlignment:NSTextAlignmentLeft];
        [labelScore setTextColor:[UIColor whiteColor]];
        [labelScore setHidden:YES];
        [self addSubview:labelScore];
    
        labelLevel = [[UILabel alloc] init];
        [labelLevel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [labelLevel setText:@"Niveau : 4"];
        [labelLevel setTextAlignment:NSTextAlignmentRight];
        [labelLevel setTextColor:[UIColor whiteColor]];
        [labelLevel setHidden:YES];
        [self addSubview:labelLevel];
    
    
    // Flèches de déplacement 
    // ======================
        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:25.0];
        
        goLeft = [UIButton buttonWithType:UIButtonTypeSystem];
        [goLeft setTranslatesAutoresizingMaskIntoConstraints:NO];    
        [goLeft addTarget:self action:@selector(playerMove:) forControlEvents:UIControlEventTouchDown];
        [goLeft addTarget:self action:@selector(playerStopMove:) forControlEvents:UIControlEventTouchUpInside];
        [goLeft setTitle:@"<<<" forState:UIControlStateNormal];
        [goLeft setTintColor:[UIColor blackColor]];
        [[goLeft titleLabel] setFont:boldSystemFont];
        [goLeft setHidden:YES];
        [self addSubview:goLeft];
        
        goRight = [UIButton buttonWithType:UIButtonTypeSystem];
        [goRight setTranslatesAutoresizingMaskIntoConstraints:NO];    
        [goRight addTarget:self action:@selector(playerMove:) forControlEvents:UIControlEventTouchDown];
        [goRight addTarget:self action:@selector(playerStopMove:) forControlEvents:UIControlEventTouchUpInside];
        [goRight setTitle:@">>>" forState:UIControlStateNormal];    
        [goRight setTintColor:[UIColor blackColor]];
        [[goRight titleLabel] setFont:boldSystemFont];    
        [goRight setHidden:YES];
        [self addSubview:goRight];
    
    // Image joueur
    // ============
        player = [[UIImageView alloc] init];
        // Image par défaut donné par le controleur en fonction des réglages
        //player = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player0"]];
        [player setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:player];
    
    
    NSDictionary *views = @{@"Scores":buttonScores, @"Play":buttonPlay, @"Settings":buttonSettings,
                            @"LabelScore":labelScore,                   @"LabelLevel":labelLevel,
                            @"goLeft":goLeft,       @"player":player,   @"goRight":goRight};
    // NSDictionaryOfVariableBindings
    NSNumber *middleButton = [NSNumber numberWithDouble:(frame.size.width/2)-35];
    NSNumber *middlePlayer = [NSNumber numberWithDouble:(frame.size.width/2)-25];
    NSDictionary *metrics = @{@"buttonWidth":@70,@"buttonHeight":@30, @"middleButton":middleButton, @"middlePlayer":middlePlayer, @"space":@10};
    
   
// Bouton "Scores"
// ===============
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-space-[Scores(buttonHeight)]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-space-[Scores(buttonWidth)]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
// Bouton "Jouer"
// ==============
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-space-[Play(buttonHeight)]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(middleButton)-[Play(buttonWidth)]-(middleButton)-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
// Bouton "Réglages"
// =================
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-space-[Settings(buttonHeight)]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[Settings(buttonWidth)]-space-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
// Label "Scores : " + score
// =========================
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-space-[LabelScore(buttonHeight)]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];   
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-space-[LabelScore(100)]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
// Label "Niveau : " + level
// =========================
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-space-[LabelLevel(buttonHeight)]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[LabelLevel(80)]-space-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
// Flèches de déplacement
// ======================
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[goLeft(buttonWidth)]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[goLeft(75)]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[goRight(buttonWidth)]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[goRight(75)]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
// Image joueur
// ============
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[player(50)]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(middlePlayer)-[player(50)]-(middlePlayer)-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    }
       
    return self;
}



- (void)playerMove:(id)sender
{
    if (sender == goLeft)
    {
      timerForMovePlayerToLeft = [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(movePlayerToLeft) userInfo:nil repeats:YES];  
    } 
    else if (sender == goRight)
    {
        timerForMovePlayerToRight = [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(movePlayerToRight) userInfo:nil repeats:YES];
    }
}


- (void)movePlayerToRight
{
    // Le centre de l'image du player ne doit pas dépasser ..
    rightLimit = [goRight frame].origin.x - 25; // le début du bouton déplacement de droite - la moitié de la largeur de l'image du player
    
 
        //        NSLog(@"Déplacement à droite."); 
        CGFloat newCenterX = [player center].x+10;
        
        if (newCenterX > rightLimit)
        {
            newCenterX = rightLimit;
        }
        
        [player setCenter:CGPointMake(newCenterX, [player center].y)];    

}

- (void)movePlayerToLeft
{
    leftLimit = ([goLeft frame].origin.x) + ([goLeft frame].size.width) + 25; // le début du bouton déplacement de gauche + sa largeur + la moitié de la largeur de l'image du player
    CGFloat newCenterX = [player center].x-10;
    
    if (newCenterX < leftLimit)
    {
        newCenterX = leftLimit;
    }
    
    [player setCenter:CGPointMake(newCenterX, [player center].y)];
}


- (void)playerStopMove:(id)sender
{
    [timerForMovePlayerToLeft invalidate];
    timerForMovePlayerToLeft = nil;
    [timerForMovePlayerToRight invalidate];
    timerForMovePlayerToRight = nil;
}

@end
