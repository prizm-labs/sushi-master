//
//  SMFish.m
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMFish.h"

@implementation SMFish

@synthesize bodyNode, creatureClass, sizeClass;

-(id) init
{
    self = [super init];
    
    if (self)
    {
        self.userInteractionEnabled = YES;
        
    }
    
    return self;
}

-(id) initWithCreatureClass: (int)_creatureClass AndSizeClass: (int)_sizeClass AtPoint: (CGPoint)origin {
    self = [super init];
    
    if (self)
    {
        levelUpLimits = @[ @1.0, @5.0, @10.0, @20.0];
        
        //currentCommandMarker = nil;
        bodyNode = nil;
        
        willReceiveCommands = YES;
        movementDirection = 0;
        creatureClass = _creatureClass;
        sizeClass = _sizeClass;
        self.position = origin;
        self.name = @nodeNameFish;
        self.zPosition = 1000;
        
        foodLevel = 0;
        movementSpeed = 0.5;
        
        [self updateBody];
        
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

-(void) updateBody {
    
    NSLog(@"size class:%i",sizeClass);
    NSLog(@"creature class:%i",creatureClass);
    
    float creatureWidth;
    UIColor* creatureColor;
    
    switch (creatureClass) {
        case 0:
            creatureColor = [UIColor grayColor];
            break;
        case 1:
            creatureColor = [UIColor yellowColor];
            break;
    }
    
    switch (sizeClass) {
        case 0:
            creatureWidth = 25.0;
            break;
        case 1:
            creatureWidth = 35.0;
            break;
        case 2:
            creatureWidth = 50.0;
            break;
        case 3:
            creatureWidth = 65.0;
            break;
        case 4:
            creatureWidth = 80.0;
            break;
            
    }
    
    NSLog(@"creature width:%f",creatureWidth);
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(creatureWidth, creatureWidth)];
    
    self.physicsBody.categoryBitMask = bitmaskCategoryCreature;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.collisionBitMask = bitmaskCategoryNeutral;
    self.physicsBody.contactTestBitMask = bitmaskCategoryHook | bitmaskCategoryChum;
    /*
     self.physicsBody.dynamic = YES;
     self.physicsBody.restitution = 0.2;
     self.physicsBody.mass = 5;
     */
    
    if (bodyNode!=nil) {
        [bodyNode removeFromParent];
    }
    
    SKSpriteNode* newBody = [SKSpriteNode spriteNodeWithColor:creatureColor size:CGSizeMake(creatureWidth, creatureWidth)];
    
    NSLog(@"new body:%@",newBody);
    
    bodyNode = newBody;
    
    [self addChild:bodyNode];
    
    NSLog(@"body node:%@",bodyNode);
}


@end
