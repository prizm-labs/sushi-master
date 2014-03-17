//
//  SMBoat.h
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SMOcean;
@class SMFish;
@class SMFisherman;

@interface SMBoat : SKNode {
    SKSpriteNode* bodyNode;
    SKNode* fishermenDeck;
    SKColor* baseColor;
    
    SMOcean* ocean;
    
    NSMutableArray* fishCaught;

    SKSpriteNode* activeFishermanPosition;
    
    float baseHeight;
    float baseWidth;
    
    float aboveWaterRatio;
    
    float totalWeight;
    float weightCapacity;
    float baitCapacity;
    float catchCapacity;
    
    int maxFishermenPositions;
    float fishermenPositionSpacing;
    NSMutableArray* fishermenPositions;
    NSMutableArray* fishermanPositionOrder;
    NSMutableArray* fishermen;
}

@property (atomic,retain) SKSpriteNode* bodyNode;
@property (atomic,retain) SMOcean* ocean;
@property (atomic,retain) NSMutableArray* fishermen;

-(void) clearFishermanAtOrder:(int)order;
-(void) setFisherman:(SMFisherman*)fisherman WithOrder:(int)order;
-(SMFisherman*) getFishermanAtPosition:(int)position;
-(int) fishermanPositionAtLocation:(UITouch*)touch;
-(void) highlightFishermanPositionAtLocation:(UITouch*)touch;
-(CGPoint) locationAtFishermanPosition:(int)index;
-(void) scatterChumOfQuantity:(int)quantity;
-(void) addCaughtFish:(SMFish*)fish atLocation:(CGPoint)location;
-(void) dumpCatch;

@end
