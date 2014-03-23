//
//  SMFisherman.h
//  sushi-master
//
//  Created by Michael Garrido on 3/3/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SMBoat, SMFish, SMHook;

@interface SMFisherman : SKNode {
    SKSpriteNode* bodyNode;
    float baseHeight;
    int type;
    
    SMBoat* boat;
    int position;
    
    //TODO simplify hook state
    bool hookReadyToCast;
    bool isReelingIn;
    
    float hookCastSpeed;
    float movementSpeed;
    
    NSTimer* breakawayTimer;
    float breakawayResistance;
    
    SMHook* hook;
    SKShapeNode *fishingline;
    SKSpriteNode* hookDestinationHighlight;
    CGPoint hookStartingPosition;
    CGPoint hookTouchesWaterPosition;
    CGPoint hookLimitPosition;
    
    NSMutableArray* hookedFish;
}

@property (assign,readonly) int type;
@property (atomic,retain) SKSpriteNode* bodyNode;

-(void) setBoat:(SMBoat*)_boat andPosition:(int)_position;
-(void) hookFish:(SMFish*)fish;
-(void) checkHookedFish:(SMFish *)fish;
-(void) updateFishingLine;

@end
