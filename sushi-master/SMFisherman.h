//
//  SMFisherman.h
//  sushi-master
//
//  Created by Michael Garrido on 3/3/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class SMBoat;

@interface SMFisherman : SKNode {
    SKSpriteNode* bodyNode;
    float baseHeight;
    
    SMBoat* boat;
    int position;
    
    SKSpriteNode* hook;
    SKSpriteNode* hookDestinationHighlight;
    CGPoint hookStartingPosition;
}

@property (atomic,retain) SKSpriteNode* bodyNode;

-(void) setBoat:(SMBoat*)_boat andPosition:(int)_position;

@end
