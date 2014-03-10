//
//  SMFishingScene.m
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMFishingScene.h"
#import "SMOcean.h"
#import "SMFish.h"
#import "SMBoat.h"
#import "SMFisherman.h"

@implementation SMFishingScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        self.physicsWorld.contactDelegate = self;
        
        
        ocean = [[SMOcean alloc] init];
        //ocean.position = screenCenter;
        
        [self addChild:ocean];
    }
    return self;
}

-(void) startGame {
    
    
}

-(void) addTime {
    
    
}

-(void) endGame {
    
    // tally fish
    
}


-(void) highlightImminentBite {
    
    
}

-(void) showHookedFish {
    
    
}

-(void) showMissedFish {
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    [ocean spawnCreaturesContinuously];
    
    // creature movement and commands
    [ocean enumerateChildNodesWithName:@nodeNameFish usingBlock:^(SKNode *nodeB, BOOL *stop) {
        
       
        SMFish* creature = (SMFish*)nodeB;
        [ocean checkChumLuredFish:creature];
        [ocean checkChumWillBeEatenByFish:creature];
        
        
        [creature wrapMovement];
        
        [ocean.boat.fishermen enumerateObjectsUsingBlock:^(id _fisherman, NSUInteger idx, BOOL *stop) {
            
            SMFisherman* fisherman = (SMFisherman*)_fisherman;
            [fisherman checkHookedFish:creature];
            
        }];
    }];
    
    
}
@end
