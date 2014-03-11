//
//  SMChumPiece.m
//  sushi-master
//
//  Created by Michael Garrido on 3/3/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMChumPiece.h"
#import "SMOcean.h"
#import "SMFish.h"

@implementation SMChumPiece

@synthesize bodyNode, ocean;

-(id) init
{
    self = [super init];
    
    if (self)
    {
        luredFish = [[NSMutableArray alloc] init];
        
        float baseWidth = chumPieceWidth;
        
        SKColor* baseColor = [SKColor orangeColor];
        
        CGSize baseSize = CGSizeMake(baseWidth, baseWidth);
        
        bodyNode = [SKSpriteNode spriteNodeWithColor:baseColor size:baseSize];
        [self addChild:bodyNode];
    }
    
    return self;
}

-(void) lureFish:(SMFish*)fish {
    
    [luredFish addObject:fish];
    
}

-(void) consumedByFish:(SMFish*)fish {
    
    [luredFish removeObject:fish];
    
    [ocean removeChum:self];
    
    [luredFish enumerateObjectsUsingBlock:^(id _fish, NSUInteger idx, BOOL *stop) {
       
        SMFish* fish = (SMFish*)_fish;
        [fish lostScent];
        
    }];
    
    [luredFish removeAllObjects];
}

@end
