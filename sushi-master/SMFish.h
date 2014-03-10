//
//  SMFish.h
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SMFisherman;

@interface SMFish : SKNode {
    SKSpriteNode* bodyNode;
    float baseHeight;
    bool isLured;
    
    //NPMyScene* scene;
    //NPCommandMarker* currentCommandMarker;

    SKShapeNode* facingDirection;
    CGPoint destination;
    int creatureClass;
    int sizeClass;
    int movementDirection;
    float movementSpeed;
    float rotation;
    float deltaX;
    float deltaY;
    
    float healthLevel;
    float foodLevel;
    
    NSArray* levelUpLimits;
    
    bool willReceiveCommands;
}
@property (atomic,retain) SKSpriteNode* bodyNode;
@property (assign,readwrite) int creatureClass;
@property (assign,readwrite) int sizeClass;
@property (assign,readwrite) float movementSpeed;

-(id) initWithCreatureClass: (int)_creatureClass AndSizeClass: (int)_sizeClass AtPoint: (CGPoint)origin;
-(void) startSwimmingInDirection: (int)_movementDirection;
-(void) wrapMovement;
-(void) updateDirection:(int)direction AtPosition:(CGPoint)position;
-(void) caughtByFisherman:(SMFisherman*)fisherman;

@end
