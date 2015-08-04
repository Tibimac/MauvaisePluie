//
//  MVScoresView.h
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MVViewsController;

@interface MVScoresView : UIView
{
    UILabel *viewTitle;
}

@property (readwrite) MVViewsController <UITextFieldDelegate> *viewController;

@property (readonly) NSDictionary *labelsLevels;
@property (readonly) NSDictionary *labelsScores;
@property (readonly) UILabel *yourScore;
@property (readonly) UITextField *txtFieldName;
@property (readonly) UIButton *buttonDone;
 

@end
