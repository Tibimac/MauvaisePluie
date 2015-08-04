//
//  MVAsteroidView.m
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import "MVAsteroidView.h"

@implementation MVAsteroidView

@synthesize imageAsteroid, verticalMove, horizontalMove, rotationAngle, lastRotationAngle;


- (id)initWithVerticalMove:(NSUInteger)vMove 
         andHorizontalMove:(NSInteger)hMove 
          andRotationAngle:(CGFloat)angle
{
    self = [super init];
    
    if (self)
    {
        // Propriétés
        // ==========
        verticalMove    = vMove;
        horizontalMove  = hMove;
        rotationAngle    = angle;
        lastRotationAngle = 0.0;

        // Image de l'asteroid
        // ===================
        int i = 0;
        while ([UIImage imageNamed:[NSString stringWithFormat:@"asteroid%d",i]])
        {
            i++;
        }
        int randomNumber = arc4random() % (i+1);
        imageAsteroid = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"asteroid%d",randomNumber]]];
//        [imageAsteroid setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:imageAsteroid];
        
     
//        NSNumber *imageWidth  = [NSNumber numberWithFloat:[imageAsteroid image].size.width];
//        NSNumber *imageHeight = [NSNumber numberWithFloat:[imageAsteroid image].size.height];
//        NSDictionary *metrics = NSDictionaryOfVariableBindings(imageWidth, imageHeight);
//        
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageAsteroid(imageWidth)]|" 
//                                                                     options:0 
//                                                                     metrics:metrics 
//                                                                       views:@{@"imageAsteroid":imageAsteroid}]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageAsteroid(imageHeight)]|" 
//                                                                     options:0 
//                                                                     metrics:metrics 
//                                                                       views:@{@"imageAsteroid":imageAsteroid}]];
    }

    return self;
}

@end
