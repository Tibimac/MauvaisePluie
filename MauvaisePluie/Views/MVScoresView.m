//
//  MVScoresView.m
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import "MVScoresView.h"
#import "MVViewsController.h"

@implementation MVScoresView

@synthesize viewController, labelsLevels, labelsScores, yourScore, txtFieldName, buttonDone;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {        
        if (UIAccessibilityIsReduceTransparencyEnabled() == NO)
        {
            UIVisualEffectView *blurEffectView;
            blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
            [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [blurEffectView setFrame:frame];
            [self addSubview:blurEffectView];
            
            NSDictionary *dic = NSDictionaryOfVariableBindings(blurEffectView);
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blurEffectView]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:dic]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blurEffectView]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:dic]];
        }
        else
        {
            [self setBackgroundColor:[UIColor blackColor]];
        }

        // Label "Meilleurs Scores"
        // ========================
        viewTitle = [[UILabel alloc] init];
        [viewTitle setFont:[UIFont systemFontOfSize:18]];
        [viewTitle setTextColor:[UIColor whiteColor]];
        [viewTitle setTextAlignment:NSTextAlignmentCenter];
        [viewTitle setText:@"🏆 Meilleurs Scores 🏆"];
        [viewTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:viewTitle];
        
        
        // Création des UILabel pour les niveaux
        // =====================================
        NSMutableDictionary *tempDico = [[NSMutableDictionary alloc] init];
        
        for (int i=0; i < 5; i++)
        {
            UILabel *tempLabel = [[UILabel alloc] init];
            [tempLabel setTextColor:[UIColor whiteColor]];
            [tempLabel setText:[NSString stringWithFormat:@"Niveau %d",i+1]];
            [tempLabel setTextAlignment:NSTextAlignmentCenter];
            [tempLabel setTranslatesAutoresizingMaskIntoConstraints:NO];            
            [self addSubview:tempLabel];
         
            NSString *varLabelTitle = [NSString stringWithFormat:@"labelLevel%d",i]; // Exemple : labelScore2 pour le niveau 3
            [tempDico setObject:tempLabel forKey:varLabelTitle];
        }
        
        labelsLevels = [[NSDictionary alloc] initWithDictionary:tempDico];
        tempDico = nil;
        
        
        // Création des UILabel pour les scores
        // ====================================
        NSMutableDictionary *tempDico2 = [[NSMutableDictionary alloc] init];
        
        for (int i=0; i<5; i++)
        {
            for (int j=0; j<5; j++)
            {
                UILabel *tempLabel = [[UILabel alloc] init];
                [tempLabel setFont:[UIFont systemFontOfSize:13]];
                [tempLabel setTextColor:[UIColor whiteColor]];                
                [tempLabel setText:@"-"];
                [tempLabel setTextAlignment:NSTextAlignmentCenter];
                [tempLabel setTranslatesAutoresizingMaskIntoConstraints:NO];                
                [self addSubview:tempLabel];
             
                NSString *varLabelTitle = [NSString stringWithFormat:@"labelScore%d%d",i,j]; // Exemple : labelScore2-3 pour le niveau 3 rang 4
                [tempDico2 setObject:tempLabel forKey:varLabelTitle];
            }
        }
        
        labelsScores = [[NSDictionary alloc] initWithDictionary:tempDico2];
        tempDico2 = nil;
        
        
        // Label "Votre score : x"
        // =======================
        yourScore = [[UILabel alloc] init];
        [yourScore setTextColor:[UIColor whiteColor]];
        [yourScore setText:@"Votre score : x"];
        [yourScore setTextAlignment:NSTextAlignmentCenter];
        [yourScore setTranslatesAutoresizingMaskIntoConstraints:NO];
        [yourScore setHidden:YES];       
        [self addSubview:yourScore];
        
        
        // Champ de saisi nom joueur
        // =========================
        txtFieldName = [[UITextField alloc] init];
        [txtFieldName setTextAlignment:NSTextAlignmentLeft];
        [txtFieldName setTextColor:[UIColor whiteColor]];
        [txtFieldName setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.05]];
        [txtFieldName setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Saisis ton prénom" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4]}]];
        [txtFieldName setTextAlignment:NSTextAlignmentCenter];
        [txtFieldName setReturnKeyType:UIReturnKeyDone];
        [txtFieldName setTranslatesAutoresizingMaskIntoConstraints:NO];
        [txtFieldName setHidden:YES];       
        [self addSubview:txtFieldName];
        
        
        // Bouton "OK"
        // ===========
        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:20.0];
        
        buttonDone = [UIButton buttonWithType:UIButtonTypeSystem];
        [buttonDone setTitle:@"OK" forState:UIControlStateNormal];
        [[buttonDone titleLabel] setFont:boldSystemFont];
        [buttonDone addTarget:viewController action:@selector(hideScoresView) forControlEvents:UIControlEventTouchUpInside];
        [buttonDone setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:buttonDone];
        
        
        // Auto-Layout
        // ===========
        
        // Dictionnaire de toutes les vues
        NSMutableDictionary *allViews = [[NSMutableDictionary alloc] init];
        [allViews addEntriesFromDictionary:NSDictionaryOfVariableBindings(viewTitle, yourScore, txtFieldName, buttonDone)];
        [allViews addEntriesFromDictionary:labelsLevels];
        [allViews addEntriesFromDictionary:labelsScores];
        // Dictionnaire des tailles
        NSNumber *titleWidth      = [NSNumber numberWithDouble:(frame.size.width)-20];
        NSNumber *labelWidth      = [NSNumber numberWithDouble:(frame.size.width-52)/5];
        NSNumber *yourScoreWidth  = [NSNumber numberWithDouble:frame.size.width/3];
        NSNumber *yourScoreMiddle = [NSNumber numberWithDouble:(frame.size.width/2)-([yourScoreWidth doubleValue]/2)];
        NSNumber *txtFieldWidth   = yourScoreWidth;
        NSNumber *txtFieldMiddle  = yourScoreMiddle;
        NSNumber *middleButton = [NSNumber numberWithDouble:(frame.size.width/2)-15];
        NSDictionary *metrics = @{@"titleWidth":titleWidth, @"labelWidth":labelWidth, @"labelHeight":@20, @"yourScoreWidth":yourScoreWidth, @"yourScoreMiddle": yourScoreMiddle, @"txtFieldWidth":txtFieldWidth, @"txtFieldMiddle":txtFieldMiddle, @"txtFieldHeight":@30, @"middleButton":middleButton, @"space":@8, @"margin":@10};
        
        
        // Label "Meilleurs Scores"
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[viewTitle(labelHeight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:allViews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[viewTitle(titleWidth)]-(margin)-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:allViews]];
        
        
        // Labels des niveaux
        for (int i=0; i<5; i++)
        {
            if (i==0)
            {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(margin)-[labelLevel%d(labelWidth)]",i]
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:allViews]];
            }
            else if (i==4)
            {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[labelLevel%d(labelWidth)]-(margin)-|",i]
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:allViews]];
            }
            else if (i>0 && i<4)
            {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[labelLevel%d]-(space)-[labelLevel%d(labelWidth)]",i-1,i]
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:allViews]];
            }
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[viewTitle]-(20)-[labelLevel%d(labelHeight)]",i]
                                                                         options:0
                                                                         metrics:metrics
                                                                           views:allViews]];
        }
        
        
        // Labels des scores
        for (int i=0; i<5; i++)
        {
            for (int j=0; j<5; j++)
            {
                // Placement Horizontal selon I
                // ============================
                
                // 1ère colonne
                if (i==0)
                {
                    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(margin)-[labelScore%d%d(labelWidth)]",i,j]
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:allViews]];
                }
                
                // Colonnes entre la 1ère et la dernière
                if (i>0 && i<4)
                {
                    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[labelScore%d%d]-(space)-[labelScore%d%d(labelWidth)]-(space)-[labelScore%d%d]",i-1, j, i, j, i+1, j]
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:allViews]];
                }
                
                // Dernière colonne
                if (i==4)
                {
                    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[labelScore%d%d]-(space)-[labelScore%d%d(labelWidth)]-(margin)-|",i-1, j, i, j]
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:allViews]];
                }
                
                // Placement Vertical selon J
                // ==========================
                
                
                if (j==0)
                {
                    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[labelLevel%d]-(margin)-[labelScore%d%d(labelHeight)]",i, i, j]
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:allViews]];
                }
                
                if (j > 0)
                {
                    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[labelScore%d%d]-(space)-[labelScore%d%d(labelHeight)]",i, j-1, i, j]
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:allViews]];
                }
            }
        }
        
        // Label "Votre Score : x"
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(yourScoreMiddle)-[yourScore(yourScoreWidth)]-(yourScoreMiddle)-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:allViews]];
        // Champ de saisie
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(txtFieldMiddle)-[txtFieldName(txtFieldWidth)]-(txtFieldMiddle)-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:allViews]];
        // Bouton "OK"
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(middleButton)-[buttonDone(30)]-(middleButton)-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:allViews]];
        // Placement Vertical Label "Votre Score : x" + Champ de saisie + Bouton "OK"
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[yourScore(labelHeight)]-(space)-[txtFieldName(txtFieldHeight)]-(30)-[buttonDone(30)]-(30)-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:allViews]];
    }
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
