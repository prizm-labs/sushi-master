//
//  SMFisherman.m
//  sushi-master
//
//  Created by Michael Garrido on 3/3/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMFisherman.h"
#import "SMBoat.h"
#import "SMFish.h"

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
        SKColor* baseColor = [SKColor blackColor];
        
        bodyNode = [SKSpriteNode spriteNodeWithColor:baseColor size:baseSize];
        bodyNode.zPosition = zBoatBackground;
        [self addChild:bodyNode];
        
        hookedFish = [[NSMutableArray alloc] init];
        
        // setup
        
        hookStartingPosition = CGPointMake(0,20);
        hookDestinationHighlight = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.8] size:CGSizeMake(fishHookWidth*2, fishHookWidth*2)];
        hookDestinationHighlight.hidden = YES;
        hook.zPosition = zOceanForeground;
        [self addChild:hookDestinationHighlight];
        
        hook = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(fishHookWidth, fishHookWidth)];
        hook.name = @nodeNameHook;
        hook.zPosition = zOceanBackground;
        [self addChild:hook];
        hook.position = hookStartingPosition;
        
        hookReadyToCast = YES;
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
    
    hookReadyToCast = NO;
    
    SKAction* castHookAction = [SKAction moveTo:location duration:1.0];
    
    [hook runAction:castHookAction withKey:@"casting"];
}

-(void) returnHook {
    
    
    NSLog(@"returnHook");
    SKAction* returnHookAction = [SKAction moveTo:hookStartingPosition duration:1.0];
    //return returnHookAction;
    [hook runAction:returnHookAction withKey:@"returning"];
}

-(void) moveToPosition:(int)index {
    
    CGPoint newLocation = [boat locationAtFishermanPosition:index];
    position = index;
    
    // return hook first
    
    SKAction* returnHookAction = [SKAction moveTo:hookStartingPosition duration:1.0];
    
    SKAction* changePositionAction = [SKAction moveTo:newLocation duration:1.0];
    
    if (!hookReadyToCast) {
        
        [hook runAction:returnHookAction completion:^(){
            
            hookReadyToCast = YES;
            NSLog(@"hooked returned!!!!!!!!");
            [self runAction:changePositionAction];
            
        }];
        
    } else {
        
        [self runAction:changePositionAction];
        
    }
    
    
    
}

-(void) checkHookedFish:(SMFish *)fish {
    
    CGPoint hookPosition = [self convertPoint:hook.position toNode:(SKNode*)boat.ocean];
    
     float xProximity = fabsf(hookPosition.x-fish.position.x);
     float yProximity = fabsf(hookPosition.y-fish.position.y);
    //NSLog(@"fish-hook proximity: %f,%f", xProximity, yProximity);
     
     if (xProximity<5.0 && yProximity<5.0) {
         NSLog(@"hook near fish");
     
         [self hookFish:fish];
         
     }

}

-(void) hookFish:(SMFish *)fish {
    
    [fish caughtByFisherman:self];
    
    fish.position = CGPointZero;
    [hook addChild:fish];
    
    [hookedFish addObject:fish];
    
    [self startReelingIn];
    
}

-(void) startReelingIn {
    
    SKAction* returnHookAction = [SKAction moveTo:hookStartingPosition duration:1.0];
    
    [hook runAction:returnHookAction completion:^(){
        
        NSLog(@"fish caught!!!!!!!!");
        
        [self finishReelingIn];
        
    }];
}

-(void) finishReelingIn {
    
    //CGPoint caughtFishStartingPosition
    
    [hookedFish enumerateObjectsUsingBlock:^(id _fish, NSUInteger idx, BOOL *stop) {
        
        SMFish* fish = (SMFish*)_fish;
        
        CGPoint caughtFishLocation = [hook convertPoint:fish.position toNode:boat];
        
        [boat addCaughtFish:fish atLocation:caughtFishLocation];
    }];
    
    [hookedFish removeAllObjects];
    
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
            
            CGPoint hookTarget = CGPointMake(0.0,-fishHookDepth);
            
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
