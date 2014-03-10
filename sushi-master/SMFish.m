//
//  SMFish.m
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMFish.h"
#import "SMFisherman.h"
#import "SMChumPiece.h"
#import "SMOcean.h"

@implementation SMFish

@synthesize ocean, bodyNode, creatureClass, sizeClass;

-(id) init
{
    self = [super init];
    
    if (self)
    {
        self.userInteractionEnabled = YES;
        isLured = NO;
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
        
        luringChum = nil;
        
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
    
    //NSLog(@"size class:%i",sizeClass);
    //NSLog(@"creature class:%i",creatureClass);
    
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
    
    //NSLog(@"creature width:%f",creatureWidth);
    
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
    
    //NSLog(@"new body:%@",newBody);
    
    bodyNode = newBody;
    
    [self addChild:bodyNode];
    
    //NSLog(@"body node:%@",bodyNode);
}

-(CGPoint) setDestination {
    deltaX = 0, deltaY = 0;
    
    switch (movementDirection) {
        case 1:
            rotation = 0;
            deltaY = kTileWidth;
            break;
        case 2:
            deltaX = kTileWidth;
            rotation = -M_PI/2;
            break;
        case 3:
            deltaY = -kTileWidth;
            rotation = M_PI;
            break;
        case 4:
            deltaX = -kTileWidth;
            rotation = M_PI/2;
            break;
    }
    
    //destination = CGPointMake(self.position.x+deltaX, self.position.y+deltaY);
    //NSLog(@"destination: %f,%f",destination.x,destination.y);
    
    return CGPointMake(self.position.x+deltaX, self.position.y+deltaY);
}

-(void) startSwimmingInDirection: (int)_movementDirection {
    movementDirection = _movementDirection;
    
    [self setDestination];
    
    SKAction *unitDestinationAction = [SKAction runBlock:(dispatch_block_t)^() {
        //NSLog(@"arrived at destination: %f,%f",self.position.x,self.position.y);
        //[self setDestination];
    }];
    
    SKAction* unitRotateAction = [SKAction rotateToAngle:rotation duration:0.1 shortestUnitArc:YES];
    
    SKAction *unitMoveAction = [SKAction moveByX:deltaX y:deltaY duration:movementSpeed];
    
    [self runAction:unitRotateAction];
    
    SKAction* movementSequence = [SKAction sequence:@[unitMoveAction,unitDestinationAction]];
    SKAction *movementLoop = [SKAction repeatActionForever:movementSequence];
    
    [self runAction:movementLoop withKey:@kActionSwimmingKey];
    
}

-(void) luredByChum:(SMChumPiece*)chum {
    
    if (!isLured) {
        
        luringChum = chum;
        
        [self updateDirection:1 AtPosition:CGPointMake(chum.position.x, self.position.y)];
    }
    
}

-(void) eatChum:(SMChumPiece *)chum {
    
    [chum consumed];
    
    [self updateDirection:3 AtPosition:chum.position];
    
}

-(void) updateDirection:(int)direction AtPosition:(CGPoint)position {
    if (movementDirection!=direction) {
        
        if ([self actionForKey:@kActionSwimmingKey]) {
            [self removeActionForKey:@kActionSwimmingKey];
        }
        
        self.position = position;
        
        [self startSwimmingInDirection:direction];
        isLured = YES;
    }
    
}

-(void) caughtByFisherman:(SMFisherman*)fisherman {
    
    if ([self actionForKey:@kActionSwimmingKey]) {
        [self removeActionForKey:@kActionSwimmingKey];
    }
    
    luringChum = nil;
    
    [ocean removeFish:self];
    
    // attach to hook
}

-(void) loadIntoBoat {
    
    [self removeFromParent];
    
}


-(void) wrapMovement {
    
    float sceneWidth = screenWidth;
    float sceneHeight = screenHeight;
    
    float offscreenPadding = bodyNode.size.width/2;
    
    //NSLog(@"fish x: %f",self.position.x);
    
    bool isOffscreenRight = (self.position.x>sceneWidth+offscreenPadding+1);
    bool isOffscreenLeft = (self.position.x<-offscreenPadding-1);
    bool isOffscreenTop = (self.position.y>sceneHeight+offscreenPadding+1);
    bool isOffscreenBottom = (self.position.y<-offscreenPadding-1);
    
    if (isOffscreenTop || isOffscreenRight || isOffscreenBottom || isOffscreenLeft) {
        
        [self removeActionForKey:@kActionSwimmingKey];
        
        if (isOffscreenTop) {
            self.position = CGPointMake(self.position.x,-offscreenPadding);
            [self startSwimmingInDirection:1];
        } else if (isOffscreenRight) {
            self.position = CGPointMake(-offscreenPadding,self.position.y);
            [self startSwimmingInDirection:2];
        } else if (isOffscreenBottom) {
            //self.position = CGPointMake(self.position.x,sceneHeight+offscreenPadding);
            //[self startSwimmingInDirection:3];
            
            
            // remove fish if moving down
            // it has eaten and and will not be lured again
            
            [ocean removeFish:self];
            
        } else if (isOffscreenLeft) {
            self.position = CGPointMake(sceneWidth+offscreenPadding,self.position.y);
            [self startSwimmingInDirection:4];
        }
        
    }
    
}


@end
