//
//  SMBoat.h
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SMBoat : SKNode {
    SKSpriteNode* bodyNode;
    SKNode* fishermenDeck;
    SKColor* baseColor;
    
    float baseHeight;
    float baseWidth;
    float aboveWaterRatio;
    
    float weightCapacity;
    float baitCapacity;
    float catchCapacity;
    
    int maxFishermenPositions;
    float fishermenPositionSpacing;
    NSMutableArray* fishermenPositions;
    NSMutableArray* fishermen;
}

@property (atomic,retain) SKSpriteNode* bodyNode;


@end
