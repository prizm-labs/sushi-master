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
@class SMCreatureSpawner;

@interface SMFish : SMSeaCreature {

    float baseHeight;
    bool isLured;
    
    SMChumPiece* luringChum;
    
    //NPMyScene* scene;
    //NPCommandMarker* currentCommandMarker;

    CGPoint destination;
    
    float healthLevel;
    float foodLevel;
    
    NSArray* levelUpLimits;
    
    bool willReceiveCommands;
}

-(id) initWithCreatureClass: (int)_creatureClass AndSizeClass: (int)_sizeClass AtPoint: (CGPoint)origin;

-(void) setup;

-(void) updateDirection:(int)direction AtPosition:(CGPoint)position;
-(void) caughtByFisherman:(SMFisherman*)fisherman;
-(void) loadIntoBoat;
-(void) eatChum:(SMChumPiece*)chum;
-(void) luredByChum:(SMChumPiece*)chum;
-(void) lostScent;
-(void) breakaway;

@end
