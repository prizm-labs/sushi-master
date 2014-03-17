//
//  SMFisherman.h
//  sushi-master
//
//  Created by Michael Garrido on 3/3/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SMBoat, SMFish;

@interface SMFisherman : SKNode {
    SKSpriteNode* bodyNode;
    float baseHeight;
    int type;
    
    SMBoat* boat;
    int position;
    bool hookReadyToCast;
    bool isReelingIn;
    
    float hookCastSpeed;
    float movementSpeed;
    
    NSTimer* breakawayTimer;
    float breakawayResistance;
    
    SKSpriteNode* hook;
    SKSpriteNode* hookDestinationHighlight;
    CGPoint hookStartingPosition;
    
    NSMutableArray* hookedFish;
}

@property (assign,readonly) int type;
@property (atomic,retain) SKSpriteNode* bodyNode;

-(void) setBoat:(SMBoat*)_boat andPosition:(int)_position;
-(void) hookFish:(SMFish*)fish;
-(void) checkHookedFish:(SMFish *)fish;

@end
