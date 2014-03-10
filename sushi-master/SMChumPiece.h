//
//  SMChumPiece.h
//  sushi-master
//
//  Created by Michael Garrido on 3/3/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SMOcean;

@interface SMChumPiece : SKNode {
    SKSpriteNode* bodyNode;
    SMOcean* ocean;
}

@property (atomic,retain) SKSpriteNode* bodyNode;
@property (atomic,retain) SMOcean* ocean;

-(void) consumed;

@end
