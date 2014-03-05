//
//  SMFishingScene.h
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SMOcean;

@interface SMFishingScene : SKScene <SKPhysicsContactDelegate> {
    SMOcean* ocean;
}

@end
