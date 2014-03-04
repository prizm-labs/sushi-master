//
//  SMOcean.m
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMOcean.h"
#import "SMChumPiece.h"
#import "SMBoat.h"

@implementation SMOcean

@synthesize bodyNode;

-(id) init
{
    self = [super init];
    
    if (self)
    {
        self.userInteractionEnabled = YES;
        
        baseHeight = oceanHeight;
        CGSize baseSize = CGSizeMake(screenWidth, baseHeight);
        SKColor* baseColor = [SKColor colorWithRed:0.2 green:1.0 blue:0.8 alpha:0.5];
        
        bodyNode = [SKSpriteNode spriteNodeWithColor:baseColor size:baseSize];
        bodyNode.position = CGPointMake(0, baseHeight/2-screenHeight/2);
        bodyNode.zPosition = zOcean;
        [self addChild:bodyNode];
        
        // setup
        
        [self addFishingBoat];
        
    }
    
    return self;
}

-(void) addFishingBoat {
    
    SMBoat* boat = [[SMBoat alloc] init];
    boat.position = CGPointMake(0,baseHeight/2);
    [self addChild:boat];
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        NSLog(@"ocean touched: %f,%f",location.x,location.y);
        
        [self addChumAtLocation:location];
    }
}

-(void) addChumAtLocation:(CGPoint)location {
    
    
    SMChumPiece* chumPiece = [[SMChumPiece alloc] init];
    chumPiece.zPosition = zOceanForeground;
    chumPiece.position = location;
    
    [self addChild:chumPiece];
}

@end
