//
//  SMChumPiece.m
//  sushi-master
//
//  Created by Michael Garrido on 3/3/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMChumPiece.h"

@implementation SMChumPiece

@synthesize bodyNode;

-(id) init
{
    self = [super init];
    
    if (self)
    {
        float baseHeight = 10.0;
        
        SKColor* baseColor = [SKColor redColor];
        
        CGSize baseSize = CGSizeMake(baseHeight, baseHeight);
        
        bodyNode = [SKSpriteNode spriteNodeWithColor:baseColor size:baseSize];
        
        [self addChild:bodyNode];
    }
    
    return self;
}


@end
