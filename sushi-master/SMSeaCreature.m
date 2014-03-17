//
//  SMSeaCreature.m
//  sushi-master
//
//  Created by Michael Garrido on 3/16/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMSeaCreature.h"

@implementation SMSeaCreature

@synthesize ocean,bodyNode,movementSpeed;

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


- (float)randomValueBetween:(float)low andValue:(float)high {
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

-(void) startSwimmingInDirection: (int)_movementDirection {
    movementDirection = _movementDirection;
    
    [self setDestination];
    
    SKAction *unitDestinationAction = [SKAction runBlock:(dispatch_block_t)^() {
        //NSLog(@"arrived at destination: %f,%f",self.position.x,self.position.y);
        //[self setDestination];
    }];
    
    SKAction* unitRotateAction = [SKAction rotateToAngle:rotation duration:0.1 shortestUnitArc:YES];
    
    
    float variedSpeed = [self randomValueBetween:0.70 andValue:1.30]*movementSpeed;
    
    SKAction *unitMoveAction = [SKAction moveByX:deltaX y:deltaY duration:variedSpeed];
    
    [self runAction:unitRotateAction];
    
    SKAction* movementSequence = [SKAction sequence:@[unitMoveAction,unitDestinationAction]];
    SKAction *movementLoop = [SKAction repeatActionForever:movementSequence];
    
    [self runAction:movementLoop withKey:@kActionSwimmingKey];
    
}

@end
