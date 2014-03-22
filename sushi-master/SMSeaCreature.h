//
//  SMSeaCreature.h
//  sushi-master
//
//  Created by Michael Garrido on 3/16/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SMOcean, SMCreatureSpawner;

@interface SMSeaCreature : SKNode {

    int movementDirection;
    float movementSpeed;
    float rotation;
    float deltaX;
    float deltaY;
    
    int movementWrapLimit; //how many times creature will wrap screen before disappearing
    
    int creatureClass;
    int sizeClass;
    float weight;
    
    SMOcean* ocean;
    SKSpriteNode* bodyNode;
    SKShapeNode* facingDirection;
    
    SMCreatureSpawner* spawner;
}
@property (weak,readwrite) SMCreatureSpawner* spawner;
@property (atomic,retain) SMOcean* ocean;
@property (atomic,retain) SKSpriteNode* bodyNode;
@property (assign,readwrite) float movementSpeed;
@property (assign,readwrite) int creatureClass;
@property (assign,readwrite) int sizeClass;
@property (assign,readwrite) float weight;

-(void) startSwimmingInDirection: (int)_movementDirection;
-(void) setup;
-(void) wrapMovement;

@end
