//
//  SMOcean.m
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMOcean.h"
#import "SMChumPiece.h"

@implementation SMOcean

@synthesize bodyNode;

-(id) init
{
    self = [super init];
    
    if (self)
    {
        self.userInteractionEnabled = YES;
        
        float baseHeight = 280.0;
        
        SKColor* baseColor = [SKColor colorWithRed:0.2 green:1.0 blue:0.8 alpha:1.0];
        
        CGSize baseSize = CGSizeMake(screenWidth, baseHeight);
        
        bodyNode = [SKSpriteNode spriteNodeWithColor:baseColor size:baseSize];

        bodyNode.position = CGPointMake(0, baseHeight/2-screenHeight/2);
        
        [self addChild:bodyNode];
    }
    
    return self;
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
    
    chumPiece.position = location;
    
    [self addChild:chumPiece];
}

@end
