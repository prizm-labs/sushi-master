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
#import "SMHook.h"

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
        hookCastSpeed = 350.0; //pixels per second
        
        self.userInteractionEnabled = YES;
        
        isReelingIn = NO;
        
        baseHeight = fishermanWidth;
        
        bodyNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@fileFishermanA] size:CGSizeMake(fishermanAwidth, fishermanAheight)];
        bodyNode.xScale = 1.0;
        bodyNode.yScale = 1.0;
        bodyNode.zPosition = zBoatBackground;
        [self addChild:bodyNode];
        
        hookedFish = [[NSMutableArray alloc] init];
        
        // setup
        
        //TODO change hook start if fisherman facing another direction
        // assumed facing left
        hookStartingPosition = CGPointMake(fishHookStartX,fishHookStartY);
        hookTouchesWaterPosition = CGPointMake(fishHookStartX,fishHookEntersWaterDepth);
        hookLimitPosition = CGPointMake(fishHookStartX,fishHookDepth);
        
        /*
        hookDestinationHighlight = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.8] size:CGSizeMake(fishermanWidth, fishermanWidth)];
        hookDestinationHighlight.hidden = YES;
        hookDestinationHighlight.zPosition = zOceanForeground;
        [self addChild:hookDestinationHighlight];
        */
        
        //TODO attach hook as joint with limit ??
        //https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Physics/Physics.html
        
        hook = [[SMHook alloc] init];
        [self addChild:hook];
        hook.position = hookStartingPosition;
        hook.fisherman = self;
        
        hookReadyToCast = YES;
        
        
        fishingline = [SKShapeNode node];
        [fishingline setStrokeColor:[UIColor whiteColor]];
        [self addChild:fishingline];
        
        //TODO remove ???
        [self updateFishingLine];
    }
    
    return self;
}

-(void) setBoat:(SMBoat *)_boat andPosition:(int)_position {
    boat = _boat;
    position = _position;
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

#pragma mark Hook Management

-(void) castHookToLocation:(CGPoint)location {
    
    //hookDestinationHighlight.position = location;
    //hookDestinationHighlight.hidden = NO;
    
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
    
    NSLog(@"returnHook");
    
    // move hook to water surface
    float hookReturnTime = [self travelTimeAtDistance:hookCastSpeed PerSecondBetweenA:hook.position andB:hookTouchesWaterPosition];
    
    SKAction* returnHookPart1Action = [SKAction moveTo:hookTouchesWaterPosition duration:hookReturnTime];
    
    // trigger animation of fisherman pulling fish out of water
    SKAction* ifCaughtFishAction = [SKAction runBlock:^(){
        if ([hookedFish count]>=1) {
            
            [hookedFish enumerateObjectsUsingBlock:^(id _fish, NSUInteger idx, BOOL *stop) {
                
                SMFish* fish = (SMFish*)_fish;
                
                CGPoint caughtFishLocation = [hook convertPoint:fish.position toNode:boat];
                
                [boat addCaughtFish:fish atLocation:caughtFishLocation];
            }];
            
            [hookedFish removeAllObjects];
        }
    }];
    
    // move hook to starting position
    hookReturnTime = [self travelTimeAtDistance:hookCastSpeed PerSecondBetweenA:hookTouchesWaterPosition andB:hookStartingPosition];
    
    SKAction* returnHookPart2Action = [SKAction moveTo:hookStartingPosition duration:hookReturnTime];
    
    SKAction* returnHookAction = [SKAction sequence:@[returnHookPart1Action,ifCaughtFishAction,returnHookPart2Action]];
    
    //SKAction* returnHookAction = [SKAction sequence:@[returnHookPart1Action,ifCaughtFishAction]];
    
    return returnHookAction;
}

-(void) checkHookedFish:(SMFish *)fish {
    
    [self hookFish:fish];
    
    if ([hookedFish count]==1) {
        [self startReelingIn];
    }

    /*
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
    */
}

-(void) hookFish:(SMFish *)fish {
    
    if (![hookedFish containsObject:fish]) {
        [fish caughtByFisherman:self];
        
        fish.position = CGPointZero;
        [hook addChild:fish];
        
        [hookedFish addObject:fish];
        
        hookDestinationHighlight.color = [UIColor greenColor];
        
        //[self startBreakawayTimer];
    }
}

-(void) startReelingIn {
    
    //[self endBreakawayTimer];
    
    [self animateStartReelingIn];
    
    [hook removeAllActions];
    
    isReelingIn = YES;
    
    SKAction* returnHookAction = [self returnHook];
    
    SKAction* returnHookDoneAction = [SKAction runBlock:^(){
        [self finishReelingIn];
    }];
    
    SKAction* castHookSequence = [SKAction sequence:@[returnHookAction,returnHookDoneAction]];
    
    [hook runAction:castHookSequence withKey:@"reeling"];
}

-(void) finishReelingIn {
    NSLog(@"fish caught:%@",hookedFish);
    
    [self animateFinishReelingIn];
    
    isReelingIn = NO;
    hookReadyToCast = YES;
    
    /*
    if ([hookedFish count]>=1) {
        
        [hookedFish enumerateObjectsUsingBlock:^(id _fish, NSUInteger idx, BOOL *stop) {
            
            SMFish* fish = (SMFish*)_fish;
            
            CGPoint caughtFishLocation = [hook convertPoint:fish.position toNode:boat];
            
            [boat addCaughtFish:fish atLocation:caughtFishLocation];
        }];
        
        [hookedFish removeAllObjects];
    }
     */
}

-(void)animateFinishReelingIn
{
    SKTextureAtlas *finishReelingAtlas = [SKTextureAtlas atlasNamed:@"tiger"];
    
    NSArray *finishReelingFrames = @[[finishReelingAtlas textureNamed:@"tiger5"],[finishReelingAtlas textureNamed:@"tiger4"],[finishReelingAtlas textureNamed:@"tiger3"],[finishReelingAtlas textureNamed:@"tiger2"],[finishReelingAtlas textureNamed:@"tiger1"]];
    
    NSLog(@"swim frames: %@",finishReelingFrames);
    
    [bodyNode runAction:[SKAction animateWithTextures:finishReelingFrames
                                          timePerFrame:0.05f
                                                resize:NO
                                               restore:NO] withKey:@"finishReeling"];
    //return;
}


-(void)animateStartReelingIn
{
    if ([bodyNode actionForKey:@"startReeling"])
        return;
    
    SKTextureAtlas *startReelingAtlas = [SKTextureAtlas atlasNamed:@"tiger"];
    
    NSArray *startReelingFrames = @[[startReelingAtlas textureNamed:@"tiger1"],[startReelingAtlas textureNamed:@"tiger2"],[startReelingAtlas textureNamed:@"tiger3"],[startReelingAtlas textureNamed:@"tiger4"],[startReelingAtlas textureNamed:@"tiger5"]];
    
    NSLog(@"swim frames: %@",startReelingFrames);
    
    [bodyNode runAction:[SKAction animateWithTextures:startReelingFrames
                                         timePerFrame:0.05f
                                               resize:NO
                                              restore:NO] withKey:@"startReeling"];
    //return;
}




-(void) toggleReeling {
    NSLog(@"toggleReeling");
    
    // if outbound and moving
    // stop and return hook
    if ([hook actionForKey:@"casting"]) {
        [self startReelingIn];
        
    // if inbound and moving
    // stop
    } else if ([hook actionForKey:@"reeling"]) {
        
        
    // if stopped
    } else if (![hook actionForKey:@"casting"] && ![hook actionForKey:@"reeling"]) {
        
        if (hookReadyToCast) {
            NSLog(@"will cast hook");

            [self castHookToLocation:hookLimitPosition];
            
        // if outbound (at limit) and stopped
        // return hook
        } else if (!isReelingIn) {
            
            [self startReelingIn];

        // if inbound and stopped
        // return hook
        }
    }
    /*
    if (!isReelingIn) {
        
        if ([hook actionForKey:@"casting"]) {
            NSLog(@"will reel in");
            [self startReelingIn];
        } else {
            NSLog(@"will cast hook");
            CGPoint hookTarget = CGPointMake(0.0,fishHookDepth);
            [self castHookToLocation:hookTarget];
        }
    }
    */
}


#pragma mark Time-based Actions

-(void) updateFishingLine {
    
    //http://stackoverflow.com/questions/19092011/how-to-draw-a-line-in-sprite-kit
    
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, fishHookStartX, fishHookStartY);
    CGPathAddLineToPoint(pathToDraw, NULL, fishHookStartX, hook.position.y);
    fishingline.path = pathToDraw;
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


#pragma mark Touch Handling

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
