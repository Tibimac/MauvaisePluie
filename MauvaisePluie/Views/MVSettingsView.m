//
//  MVSettingsView.m
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import "MVSettingsView.h"
#import "MVViewsController.h"

@implementation MVSettingsView

@synthesize viewController, pickerPlayers, pickerLevels;
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
        [viewTitle setText:@"🔧 Réglages 🔧"];
        [viewTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:viewTitle];
        
        
        // Label "Choisi ton personnage" + UIPickerView
        // ============================================
        labelForPlayer = [[UILabel alloc] init];
        [labelForPlayer setText:@"Choisi ton personnage :"];
        [labelForPlayer setTextAlignment:NSTextAlignmentCenter];
        [labelForPlayer setTextColor:[UIColor whiteColor]];
        [labelForPlayer setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:labelForPlayer];
    
        pickerPlayers = [[UIPickerView alloc] init];
        [pickerPlayers setTag:1];
        [pickerPlayers setTranslatesAutoresizingMaskIntoConstraints:NO];
        [pickerPlayers setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.05]];
        // DataSource & Delegate set by MVViewController
        [self addSubview:pickerPlayers];
        
        
        // Label "Choisi ton niveau de difficulté" + UIPickerView
        // ======================================================
        labelForLevel = [[UILabel alloc] init];
        [labelForLevel setText:@"Choisi ton niveau de difficulté :"];
        [labelForLevel setTextAlignment:NSTextAlignmentCenter];
        [labelForLevel setTextColor:[UIColor whiteColor]];
        [labelForLevel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:labelForLevel];
        
        pickerLevels = [[UIPickerView alloc] init];
        [pickerLevels setTag:2];
        [pickerLevels setTranslatesAutoresizingMaskIntoConstraints:NO];
        [pickerLevels setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.05]];       
        // DataSource & Delegate set by MVViewController
        [self addSubview:pickerLevels];
        
        
        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:20.0];
        
        buttonDone = [UIButton buttonWithType:UIButtonTypeSystem];
        [buttonDone setTitle:@"OK" forState:UIControlStateNormal];
        [[buttonDone titleLabel] setFont:boldSystemFont];
        [buttonDone addTarget:viewController action:@selector(hideSettingsView) forControlEvents:UIControlEventTouchUpInside];
        [buttonDone setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:buttonDone];
        
        
        NSDictionary *views = @{                @"viewTitle":viewTitle,
                                @"LabelPlayer":labelForPlayer, @"LabelLevel":labelForLevel,
                                @"PickerPlayer":pickerPlayers, @"PickerLevel":pickerLevels,
                                                @"ButtonDone":buttonDone};
        
        NSNumber *titleWidth    = [NSNumber numberWithDouble:(frame.size.width)-40];
        NSNumber *pickerWidth   = [NSNumber numberWithDouble:(frame.size.width/2)-30];
        NSNumber *labelWidth    = pickerWidth;
        NSNumber *middleButton  = [NSNumber numberWithDouble:(frame.size.width/2)-15];
        NSDictionary *metrics = @{@"titleWidth":titleWidth, @"labelWidth":labelWidth, @"labelHeight":@20, @"pickerHeight":@162, @"pickerWidth":pickerWidth, @"space":@20, @"middleButton":middleButton};
        
        // Label "Réglages"
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(space)-[viewTitle(labelHeight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(space)-[viewTitle(titleWidth)]-(space)-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        // Labels
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[viewTitle]-(40)-[LabelPlayer(labelHeight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[viewTitle]-(40)-[LabelLevel(labelHeight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(space)-[LabelPlayer(labelWidth)]-(space)-[LabelLevel(labelWidth)]-(space)-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        // Pickers
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[LabelPlayer]-(space)-[PickerPlayer(pickerHeight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[LabelPlayer]-(space)-[PickerLevel(pickerHeight)]"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(space)-[PickerPlayer(pickerWidth)]-(space)-[PickerLevel(pickerWidth)]-(space)-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        
        // Bouton "OK"
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[ButtonDone(30)]-(30)-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(middleButton)-[ButtonDone(30)]-(middleButton)-|"
                                                                     options:0
                                                                     metrics:metrics
                                                                       views:views]];

    }
    
    return self;
}

@end
