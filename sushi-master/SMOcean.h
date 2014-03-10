//
//  SMOcean.h
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class SMBoat;

@interface SMOcean : SKSpriteNode {
    SKSpriteNode* bodyNode;
    float baseHeight;
    float baseWidth;
    
    SMBoat* boat;
    
    int creatureLimit;
    double nextCreatureSpawnTime;
    NSMutableArray* creatures;
}

@property (atomic,retain) SKSpriteNode* bodyNode;

-(void) spawnCreaturesContinuously;
-(void) addChumAtLocation:(CGPoint)location;

@end
