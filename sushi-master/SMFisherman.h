//
//  SMFisherman.h
//  sushi-master
//
//  Created by Michael Garrido on 3/3/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SMFisherman : SKNode {
    SKSpriteNode* bodyNode;
    float baseHeight;
    
    SKSpriteNode* hook;
    SKSpriteNode* hookDestinationHighlight;
    CGPoint hookStartingPosition;
}

@property (atomic,retain) SKSpriteNode* bodyNode;


@end
