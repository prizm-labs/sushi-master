//
//  SMBoat.m
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMBoat.h"
#import "SMFisherman.h"

@implementation SMBoat

@synthesize bodyNode;

-(id) init
{
    self = [super init];
    
    if (self)
    {
        self.userInteractionEnabled = YES;
        
        aboveWaterRatio = 0.8;
        baseHeight = boatHeight;
        baseWidth = boatWidth;
        baseColor = [SKColor brownColor];
        
        CGSize baseSize = CGSizeMake(baseWidth, baseHeight);
        
        bodyNode = [SKSpriteNode spriteNodeWithColor:baseColor size:baseSize];
        bodyNode.zPosition = zBoat;
        bodyNode.position = CGPointMake(0, 0*aboveWaterRatio);
        [self addChild:bodyNode];
        
        [self setupFishermenPositions];
    }
    
    return self;
}

-(void) setupFishermenPositions {
    
    maxFishermenPositions = 8;
    fishermenPositionSpacing = baseWidth/(maxFishermenPositions-1)*0.9;
    
    fishermenPositions = [[NSMutableArray alloc] initWithCapacity:maxFishermenPositions];
    
    fishermen = [[NSMutableArray alloc] initWithCapacity:maxFishermenPositions];
    
    fishermenDeck = [SKNode node];
    fishermenDeck.position = CGPointMake(-(maxFishermenPositions-1)*fishermenPositionSpacing/2,baseHeight*0.5);
    fishermenDeck.zPosition = zBoatForeground;
    [bodyNode addChild:fishermenDeck];
    
    for (int n=0;n<maxFishermenPositions;n++) {
        SKSpriteNode* fishermanPosition = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(20.0,20.0)];
        CGPoint position = CGPointMake(n*fishermenPositionSpacing,0);
        fishermanPosition.position = position;
        [fishermenDeck addChild:fishermanPosition];
        
        fishermanPosition.userData = [[NSMutableDictionary alloc] init];
        [fishermanPosition.userData setValue:NO forKey:@"occupied"];
        
        [fishermenPositions addObject:fishermanPosition];
    }
    
    [self addFishermanAtPosition:3];
}

-(void) addFishermanAtPosition:(int)position {
    
    if (position>=maxFishermenPositions) {
        return;
    }
    
    // TODO add a fisherman with persistent XP and stats
    
    SMFisherman* fisherman = [[SMFisherman alloc] init];
    SKSpriteNode* fishermanPosition = (SKSpriteNode*)[fishermenPositions objectAtIndex:position];
    fisherman.zPosition = zBoatForeground;
    fisherman.position = fishermanPosition.position;
    
    [fishermenDeck addChild:fisherman];
    [fishermen addObject:fisherman];
}

-(void) addWeight {
    // boat cannot
}


@end
