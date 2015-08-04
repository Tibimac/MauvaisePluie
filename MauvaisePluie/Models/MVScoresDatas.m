//
//  MVScores.m
//  Attestation_Tibimac
//
//  Created by Thibault Le Cornec on 23/03/2015.
//  Copyright (c) 2015 Thibault Le Cornec. All rights reserved.
//

#import "MVScoresDatas.h"

@implementation MVScoresDatas

- (id)init
{
    self = [super init];
    
    if (self)
    {
        allScores = [[NSArray alloc] initWithObjects:[[NSMutableArray alloc] init],
                                                     [[NSMutableArray alloc] init],
                                                     [[NSMutableArray alloc] init],
                                                     [[NSMutableArray alloc] init],
                                                     [[NSMutableArray alloc] init],
                                                     nil];
        minScores = [[NSMutableArray alloc] init];
        
        for (int i=0; i<5; i++)
        {
            for (int j=0; j<5; j++)
            {
                [[allScores objectAtIndex:i] addObject:[[MVScore alloc] init]]; // Les objets MVScore seront initialisé aux valeurs par défaut (tout à nil)
            }
            
            // Initialisation du tableau des scores minimaux pour chaque niveau
            // Chaque MVScore créé au-dessus est initialisé avec un NSNumber à nil
            //  ce qui équivaut à pas de score.
            // Donc pour représenter l'abscence de score, les scores minimaux sont
            //  initialisé à -1. Ainsi même si l'utilisateur fait un score de 0
            //  il pourra enregistrer son score car 0 est supérieur à -1
            // Voir dans MVViewController.m le test "if (currentScore > [scoresDatas minScoreForLevel:x])"
            [minScores addObject:[NSNumber numberWithInt:-1]];
        }
    }
    
    return self;
}



- (NSNumber*)minScoreForLevel:(NSUInteger)level
{
    NSNumber *minScore = [NSNumber numberWithInteger:[[minScores objectAtIndex:level] integerValue]];
    return minScore;
}



- (BOOL)addScore:(NSUInteger)newScore 
       forPlayer:(NSString*)name 
         atLevel:(NSUInteger)level
{
    BOOL isInserted = NO;
    int indInsert = 0;
    
    // Récupération du tableau correspondant uniquement au niveau pour lequel il faut ajouter un score
    NSMutableArray *scoresForLevel = [allScores objectAtIndex:level];
    NSUInteger nbElements = [scoresForLevel count]-1;
    
    // On s'assure qu'il y a bien un objet au rang indInsert dans le tableau des scores du niveau
    if ([scoresForLevel objectAtIndex:indInsert] != nil)
    {
        // Recherche indice d'insertion pour le nouveau score
        // Tant que : pas fin de tableau ET score de objet MVScore à l'indice indInsert != nil ET newScore < à valeur score objet MVScore à l'indice indInsert 
        while ((indInsert <= nbElements) && ([[scoresForLevel objectAtIndex:indInsert] scoreNumber] != nil) && (newScore < [[[scoresForLevel objectAtIndex:indInsert] scoreNumber] integerValue]))
        {
            // On avance l'indice d'insertion à la case inférieure car le newScore est plus petit que le score de la case précédente
            // (on descend le rang d'insertion en fonction du score)
            indInsert++;
        }    
        
        // Déplacement des éléments du tableau entre le fin du tableau et l'indice d'insertion du nouveau score
        // Le score au dernier rang est donc remplacé (effacé) par le score 4 (rangs indéxés de 0 à 4)
        for (int i=(int)nbElements; i>indInsert; i--)
        {
            // Il est possible qu'il n'y ai dans la tableau que des objet MVScore avec des valeurs à nil; ça n'a aucune importance
            [scoresForLevel replaceObjectAtIndex:i withObject:[scoresForLevel objectAtIndex:i-1]];
        }
    }
    
    // Création d'un objet score avec les infos sur le nouveau score
    MVScore *newScoreForLevel = [[MVScore alloc] initWithScore:newScore andPlayer:name atLevel:level]; // name peut être à nil
    
    if (indInsert < 5)
    {
        // Insertion du nouveau score dans le tableau
        [scoresForLevel replaceObjectAtIndex:indInsert withObject:newScoreForLevel];
        
        isInserted = YES;
        
        if (indInsert == 4) // Si indInsert = 4 alors le score inséré est le plus petit du niveau
        {
            // On met donc à jour le tableau des scores minimaux
            [minScores replaceObjectAtIndex:level withObject:[NSNumber numberWithUnsignedLong:newScore]];
        }
    }
    else
    {
        NSLog(@"Indice d'insertion supérieur au nombre d'éléments dans le tableau : Insertion impossible !");
    }
    
    return isInserted;
}



- (NSString*)stringForScoreAtLevel:(NSUInteger)level andRank:(NSUInteger)rank
{
    NSString *theString = nil;
    MVScore *theScore = nil;
    
    // Récupération de l'objet MVScore pour le niveau et le rang demandé
    theScore = [[allScores objectAtIndex:level] objectAtIndex:rank];

    // Si les informations sur le score sont toutes à nil (valeurs à l'initialisation) alors c'est qu'il n'y a pas de score enregistré
    if ([theScore scoreNumber] == nil && [theScore playerName] == nil && [theScore levelNumber] == nil)
    {
        theString = @"-";
    }
    else
    {
        NSUInteger score = [[theScore scoreNumber] integerValue]; // Récupération du score (peut être 0)
        
        NSString *stringPlayerName;
        
        if ([theScore playerName] == nil || [[theScore playerName] isEqualToString:@""]) // Si le joueur n'a pas renseigné son nom lors de l'enregistrement de son score
        {
            stringPlayerName = @"???";
        }
        else
        {
            stringPlayerName = [theScore playerName];
        }
        
        if (rank == 0) // Si le rang demandé est le 0, il s'agit du meilleur score pour ce niveau
        {
            // Personnalisation de la chaine de caractères renvoyée
            theString = [NSString stringWithFormat:@"🏆 %@ : %ld",stringPlayerName, (unsigned long)score];
        }
        else
        {
            theString = [NSString stringWithFormat:@"%@ : %ld",stringPlayerName, (unsigned long)score];
        }
    }
    
    return theString;
}


@end
