//
//  SMChumPiece.h
//  sushi-master
//
//  Created by Michael Garrido on 3/3/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SMOcean, SMFish;

@interface SMChumPiece : SKNode {
    SKSpriteNode* bodyNode;
    SMOcean* ocean;
    NSMutableArray* luredFish;
}

@property (atomic,retain) SKSpriteNode* bodyNode;
@property (atomic,retain) SMOcean* ocean;

-(void) consumedByFish:(SMFish*)fish;
-(void) lureFish:(SMFish*)fish;

@end
