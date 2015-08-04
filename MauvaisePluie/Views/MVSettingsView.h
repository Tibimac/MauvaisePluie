//
//  MVSettingsView.h
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MVViewsController;

@interface MVSettingsView : UIView
{
    UILabel *viewTitle;
    UILabel *labelForPlayer;
    UILabel *labelForLevel;
    UIButton *buttonDone;
}

@property (readwrite) MVViewsController <UIPickerViewDataSource, UIPickerViewDelegate> *viewController;

@property (readonly) UIPickerView *pickerPlayers;
@property (readonly) UIPickerView *pickerLevels;

@end
