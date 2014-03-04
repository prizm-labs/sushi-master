//
//  SMFisherman.m
//  sushi-master
//
//  Created by Michael Garrido on 3/3/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMFisherman.h"

@implementation SMFisherman

@synthesize bodyNode;

-(id) init
{
    self = [super init];
    
    if (self)
    {
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

-(void) castHookToLocation:(CGPoint)location {
    
    hookDestinationHighlight.position = location;
    hookDestinationHighlight.hidden = NO;
    // draw fishing line to hook
    
    SKAction* castHookAction = [SKAction moveTo:location duration:1.0];
    
    [hook runAction:castHookAction withKey:@"casting"];
}

-(void) returnHook {
    
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
        
        NSLog(@"fisherman moved: %f,%f",location.x,location.y);
        
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        NSLog(@"fisherman ended: %f,%f",location.x,location.y);
        [self castHookToLocation:location];
        
    }
}


@end
