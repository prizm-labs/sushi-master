//
//  SMSeaTurtle.m
//  sushi-master
//
//  Created by Michael Garrido on 3/16/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMSeaTurtle.h"

@implementation SMSeaTurtle

-(id) init
{
    self = [super init];
    
    if (self)
    {
        NSLog(@"init sea turtle");

        movementSpeed = 0.25; // time to move 1 tile width
        
        
        float creatureWidth = 40.0;
        float creatureHeight = 25.0;
        SKColor* creatureColor = [SKColor redColor];
        
        //[self updateBody];
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(creatureWidth, creatureHeight)];
        
        self.physicsBody.categoryBitMask = bitmaskCategoryCreature;
        self.physicsBody.allowsRotation = NO;
        self.physicsBody.collisionBitMask = bitmaskCategoryNeutral;
        self.physicsBody.contactTestBitMask = bitmaskCategoryHook | bitmaskCategoryChum;
        /*
         self.physicsBody.dynamic = YES;
         self.physicsBody.restitution = 0.2;
         self.physicsBody.mass = 5;
         */

        SKSpriteNode* newBody = [SKSpriteNode spriteNodeWithColor:creatureColor size:CGSizeMake(creatureWidth, creatureWidth)];

        
        bodyNode = newBody;
        
        [self addChild:bodyNode];
        
        
        facingDirection = [SKShapeNode node];
        facingDirection.zPosition = 99;
        facingDirection.position = CGPointMake(-10.0, -10.0);
        CGPoint triangle[] = {CGPointMake(0.0, 0.0), CGPointMake(10.0, 20.0), CGPointMake(20.0, 0.0)};
        CGMutablePathRef facingPointer = CGPathCreateMutable();
        CGPathAddLines(facingPointer, NULL, triangle, 3);
        facingDirection.path = facingPointer;
        facingDirection.lineWidth = 1.0;
        facingDirection.fillColor = [SKColor whiteColor];
        facingDirection.strokeColor = [SKColor clearColor];
        facingDirection.glowWidth = 0.0;
        
        
        [self addChild:facingDirection];
        
        
        
    }
    
    return self;
    
}

-(void) setup {
    
}

@end
