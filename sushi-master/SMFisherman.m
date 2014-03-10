//
//  SMFisherman.m
//  sushi-master
//
//  Created by Michael Garrido on 3/3/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMFisherman.h"
#import "SMBoat.h"

@implementation SMFisherman

@synthesize bodyNode;

-(id) init
{
    self = [super init];
    
    if (self)
    {
        //fisherman has
        
        //movementSpeed how fast to switch positions
        
        //strength how fast to reel fish in
        
        //accuracy how likely to hook fish
        
        self.userInteractionEnabled = YES;
        
        baseHeight = fishermanWidth;
        CGSize baseSize = CGSizeMake(baseHeight, baseHeight);
        SKColor* baseColor = [SKColor yellowColor];
        
        bodyNode = [SKSpriteNode spriteNodeWithColor:baseColor size:baseSize];
        bodyNode.zPosition = zBoatBackground;
        [self addChild:bodyNode];
        
        // setup
        
        hookStartingPosition = CGPointMake(0,20);
        hookDestinationHighlight = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.8] size:CGSizeMake(fishHookWidth*2, fishHookWidth*2)];
        hookDestinationHighlight.hidden = YES;
        hook.zPosition = zOceanForeground;
        [self addChild:hookDestinationHighlight];
        
        hook = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(fishHookWidth, fishHookWidth)];
        hook.zPosition = zOceanBackground;
        [self addChild:hook];
        hook.position = hookStartingPosition;
    }
    
    return self;
}

-(void) setBoat:(SMBoat *)_boat andPosition:(int)_position {
    boat = _boat;
    position = _position;
}

-(void) castHookToLocation:(CGPoint)location {
    
    hookDestinationHighlight.position = location;
    hookDestinationHighlight.hidden = NO;
    // draw fishing line to hook
    
    SKAction* castHookAction = [SKAction moveTo:location duration:1.0];
    
    [hook runAction:castHookAction withKey:@"casting"];
}

-(void) returnHook {
    
    SKAction* returnHookAction = [SKAction moveTo:hookStartingPosition duration:1.0];
    [hook runAction:returnHookAction withKey:@"returning"];
}

-(void) moveToPosition:(int)index {
    
    CGPoint newLocation = [boat locationAtFishermanPosition:index];
    position = index;
    
    // return hook first
    SKAction *returnHookAction = [SKAction runBlock:(dispatch_block_t)^() {
        [self returnHook];
    }];
    SKAction* changePositionAction = [SKAction moveTo:newLocation duration:1.0];
    
    SKAction* movePositionSequence = [SKAction sequence:@[returnHookAction,changePositionAction]];
    
    [self runAction:movePositionSequence withKey:@"changingPosition"];
    
}

-(void) startReelingIn {
    
    
}

-(void) finishReelingIn {
    
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        NSLog(@"fisherman touched: %f,%f",location.x,location.y);
        
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
         NSLog(@"fisherman touch moved: %f,%f",location.x,location.y);
        
        // swipe down to cast hook
        if (location.y < -20.0 && ![hook actionForKey:@"casting"]) {
            
            CGPoint hookTarget = CGPointMake(0.0,-100.0);
            
            [self castHookToLocation:hookTarget];
            
        } else {
            [boat highlightFishermanPositionAtLocation:touch];
        }
        
       
        
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        //CGPoint location = [touch locationInNode:self];
        CGPoint location = [touch locationInNode:boat.bodyNode];
        
        NSLog(@"fisherman ended: %f,%f",location.x,location.y);
        
        int newPosition = [boat fishermanPositionAtLocation:touch];
        
        if (newPosition != position) {
            [self moveToPosition:newPosition];
        }
        
        //[self castHookToLocation:location];
        
    }
}


@end
