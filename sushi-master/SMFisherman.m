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

@synthesize type,bodyNode;

-(float) travelTimeAtDistance:(float)distance PerSecondBetweenA:(CGPoint)a andB:(CGPoint)b {
    
    float deltaX = fabs(a.x-b.x);
    float deltaY = fabs(a.y-b.y);
    float magnitude = powf(powf(deltaX, 2)+powf(deltaY, 2),0.5);
    
    return magnitude/distance;
}

-(id) init
{
    self = [super init];
    
    if (self)
    {
        //fisherman has
        
        //movementSpeed how fast to switch positions
        
        //strength how fast to reel fish in
        
        //accuracy how likely to hook fish
        
        
        movementSpeed = 200.0; //pixels per second
        hookCastSpeed = 200.0; //pixels per second
        
        self.userInteractionEnabled = YES;
        
        isReelingIn = NO;
        
        baseHeight = fishermanWidth;
        CGSize baseSize = CGSizeMake(baseHeight, baseHeight);
        SKColor* baseColor = [SKColor blackColor];
        
        bodyNode = [SKSpriteNode spriteNodeWithColor:baseColor size:baseSize];
        bodyNode.zPosition = zBoatBackground;
        [self addChild:bodyNode];
        
        hookedFish = [[NSMutableArray alloc] init];
        
        // setup
        
        hookStartingPosition = CGPointMake(0,20);
        hookDestinationHighlight = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.8] size:CGSizeMake(fishermanWidth, fishermanWidth)];
        hookDestinationHighlight.hidden = YES;
        hook.zPosition = zOceanForeground;
        [self addChild:hookDestinationHighlight];
        
        //TODO attach hook as joint with limit
        //https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Physics/Physics.html
        
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
    
    // TODO draw fishing line to hook
    
    hookReadyToCast = NO;
    
    float hookCastTime = [self travelTimeAtDistance:hookCastSpeed PerSecondBetweenA:hook.position andB:location];
    
    SKAction* castHookAction = [SKAction moveTo:location duration:hookCastTime];
    
    SKAction* castHookDoneAction = [SKAction runBlock:^(){
        //[self startReelingIn];
    }];
    
    SKAction* castHookSequence = [SKAction sequence:@[castHookAction,castHookDoneAction]];
    
    [hook runAction:castHookSequence withKey:@"casting"];

}

-(SKAction*) returnHook {
    
    float weightedHookCoefficient = 1.0;
    
    if ([hookedFish count]>0) {
        //TODO vary by fish weight
        weightedHookCoefficient = 1.5;
    }
    
    float hookReturnTime = [self travelTimeAtDistance:hookCastSpeed*weightedHookCoefficient PerSecondBetweenA:hook.position andB:hookStartingPosition] ;
    
    NSLog(@"returnHook");
    SKAction* returnHookAction = [SKAction moveTo:hookStartingPosition duration:hookReturnTime];
    
    return returnHookAction;
}


-(void) moveToPosition:(int)index {
    
    if ([self actionForKey:@"changingPosition"]){
        return;
    }
    
    [boat clearFishermanAtOrder:position];
    
    CGPoint newLocation = [boat locationAtFishermanPosition:index];
    //position = index;
    
    // return hook first
    
    //SKAction* returnHookAction = [self returnHook];
    
    float travelTime = [self travelTimeAtDistance:movementSpeed PerSecondBetweenA:self.position andB:newLocation];
    
    SMFisherman* fishermanAtLocation = [boat getFishermanAtPosition:index];
    
    if (![fishermanAtLocation isEqual:[NSNull null]]) {
        [fishermanAtLocation moveToPosition:position];
    }
    
    SKAction* changePositionAction = [SKAction moveTo:newLocation duration:travelTime];
    
    SKAction* changePositionDoneAction = [SKAction runBlock:^(){
        
        if (![fishermanAtLocation isEqual:[NSNull null]]) {
            [boat setFisherman:self WithOrder:position];
        }
        
        position = index;
        [boat setFisherman:self WithOrder:index];
    }];
    
    SKAction* sequence = [SKAction sequence:@[changePositionAction,changePositionDoneAction]];
    
    [self runAction:sequence withKey:@"changingPosition"];
    
}

-(void) checkHookedFish:(SMFish *)fish {
    
    CGPoint hookPosition = [self convertPoint:hook.position toNode:(SKNode*)boat.ocean];
    
    float xProximity = fabsf(hookPosition.x-fish.position.x);
    float yProximity = fabsf(hookPosition.y-fish.position.y);
    //NSLog(@"fish-hook proximity: %f,%f", xProximity, yProximity);
    
    // extend active area of hook, so fisherman can catch a moving fish
    
    float activeHookRange = 20.0;
    
    // first fished hooked starts reeling in
    
    if (xProximity<activeHookRange && yProximity<activeHookRange) {
         NSLog(@"hook near fish");
     
        [self hookFish:fish];
        
        if ([hookedFish count]==1) {
            [self startReelingIn];
        }
        
    }

}

-(void) hookFish:(SMFish *)fish {
    
    
    [fish caughtByFisherman:self];
    
    fish.position = CGPointZero;
    [hook addChild:fish];
    
    [hookedFish addObject:fish];
    
    hookDestinationHighlight.color = [UIColor greenColor];
   
    //[self startBreakawayTimer];
    
}

-(void) startBreakawayTimer {
    
    NSLog(@"start breakaway timer");
    
    float breakawayTimeInterval = 0.1;
    breakawayResistance = breakawayLimit/breakawayTimeInterval;
    
    //TODO set resistance based on fish size and fisherman strength
    
    breakawayTimer = [NSTimer scheduledTimerWithTimeInterval:breakawayTimeInterval target:self selector:@selector(updateBreakawayTimer) userInfo:nil repeats:YES];
}


-(void) updateBreakawayTimer {
    
    breakawayResistance-=1;
    
     NSLog(@"breakaway resistance: %f",breakawayResistance);
    
    if (breakawayResistance<=0) {
        
        [self endBreakawayTimer];
        
         NSLog(@"fish got away");
        
        [hookedFish enumerateObjectsUsingBlock:^(id _fish, NSUInteger idx, BOOL *stop) {
            
            SMFish* fish = (SMFish*)_fish;
            [hookedFish removeObject:fish];
            hookDestinationHighlight.color = [UIColor redColor];
            
            [fish breakaway];
            
        }];
  
    }

}

-(void) endBreakawayTimer {
    
    if ([breakawayTimer isValid]) {
        [breakawayTimer invalidate];
        breakawayTimer = nil;
    }
    
}

-(void) startReelingIn {
    
    //[self endBreakawayTimer];
    
    [hook removeAllActions];
    
    isReelingIn = YES;
    
    SKAction* returnHookAction = [self returnHook];
    
    [hook runAction:returnHookAction completion:^(){
        
        NSLog(@"fish caught!!!!!!!!");
        
        [self finishReelingIn];
    }];
}

-(void) finishReelingIn {
    
    isReelingIn = NO;
    
    //CGPoint caughtFishStartingPosition
    
    [hookedFish enumerateObjectsUsingBlock:^(id _fish, NSUInteger idx, BOOL *stop) {
        
        SMFish* fish = (SMFish*)_fish;
        
        CGPoint caughtFishLocation = [hook convertPoint:fish.position toNode:boat];
        
        [boat addCaughtFish:fish atLocation:caughtFishLocation];
    }];
    
    [hookedFish removeAllObjects];
    hookDestinationHighlight.color = [UIColor redColor];
    
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
        
        [boat highlightFishermanPositionAtLocation:touch];

        
        // move fisherman immediately
        // and swap positions with fisherman at that location
        location = [touch locationInNode:boat.bodyNode];
        
        NSLog(@"fisherman ended: %f,%f",location.x,location.y);
        
        int newPosition = [boat fishermanPositionAtLocation:touch];
        NSLog(@"new position, old position: %i,%i",newPosition,position);
        
        
        if (newPosition != position) {
            
            [self moveToPosition:newPosition];
        }
        
    }
}

-(void) toggleReeling {
    
    if (!isReelingIn) {
        
        if ([hook actionForKey:@"casting"]) {
            
            [self startReelingIn];
        } else {
            CGPoint hookTarget = CGPointMake(0.0,fishHookDepth);
            [self castHookToLocation:hookTarget];
        }
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        
        // if touched up inside fisherman, return hook
        CGPoint location = [touch locationInNode:self];

        if (fabs(location.x)<baseHeight/2 && fabs(location.y)<baseHeight/2) {
            
            [self toggleReeling];
            

        } else {
            /*
            location = [touch locationInNode:boat.bodyNode];
            
            NSLog(@"fisherman ended: %f,%f",location.x,location.y);
            
            int newPosition = [boat fishermanPositionAtLocation:touch];
            NSLog(@"new position, old position: %i,%i",newPosition,position);
            
            if (newPosition != position) {
                [self moveToPosition:newPosition];
            }
            */
            
        }
        
        
        
        
    }
}


@end
