//
//  SMOcean.h
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class SMBoat;
@class SMFish, SMChumPiece;

@interface SMOcean : SKSpriteNode {
    SKSpriteNode* bodyNode;
    float baseHeight;
    float baseWidth;
    
    SMBoat* boat;
    
    int creatureLimit;
    double nextCreatureSpawnTime;
    NSMutableArray* creatures;
    
    NSMutableArray* chumPieces;
}

@property (atomic,retain) SKSpriteNode* bodyNode;
@property (atomic,retain) SMBoat* boat;

-(void) spawnCreaturesContinuously;
-(void) addChumAtLocation:(CGPoint)location;
-(void) checkChumLuredFish:(SMFish*)fish;
-(void) checkChumWillBeEatenByFish:(SMFish*)fish;
-(void) removeFish:(SMFish*)fish;
-(void) removeChum:(SMChumPiece*)chum;

@end
