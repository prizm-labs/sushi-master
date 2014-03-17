//
//  SMSeaCreature.h
//  sushi-master
//
//  Created by Michael Garrido on 3/16/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SMOcean;

@interface SMSeaCreature : SKNode {

    int movementDirection;
    float movementSpeed;
    float rotation;
    float deltaX;
    float deltaY;
    
    SMOcean* ocean;
    SKSpriteNode* bodyNode;
    SKShapeNode* facingDirection;
}
@property (atomic,retain) SMOcean* ocean;
@property (atomic,retain) SKSpriteNode* bodyNode;
@property (assign,readwrite) float movementSpeed;

-(void) startSwimmingInDirection: (int)_movementDirection;

@end
