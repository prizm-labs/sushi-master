//
//  SMFish.h
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMSeaCreature.h"

@class SMFisherman;
@class SMChumPiece;
@class SMOcean;

@interface SMFish : SMSeaCreature {

    float baseHeight;
    bool isLured;
    
    SMChumPiece* luringChum;
    
    //NPMyScene* scene;
    //NPCommandMarker* currentCommandMarker;

    CGPoint destination;
    int creatureClass;
    int sizeClass;
    float weight;
    
    float healthLevel;
    float foodLevel;
    
    NSArray* levelUpLimits;
    
    bool willReceiveCommands;
}

@property (assign,readwrite) int creatureClass;
@property (assign,readwrite) int sizeClass;
@property (assign,readwrite) float weight;

-(id) initWithCreatureClass: (int)_creatureClass AndSizeClass: (int)_sizeClass AtPoint: (CGPoint)origin;

-(void) wrapMovement;
-(void) updateDirection:(int)direction AtPosition:(CGPoint)position;
-(void) caughtByFisherman:(SMFisherman*)fisherman;
-(void) loadIntoBoat;
-(void) eatChum:(SMChumPiece*)chum;
-(void) luredByChum:(SMChumPiece*)chum;
-(void) lostScent;
-(void) breakaway;

@end
