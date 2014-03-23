//
//  SMHookContactVisitor.m
//  sushi-master
//
//  Created by Michael Garrido on 3/22/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMHookContactVisitor.h"

#import "SMFisherman.h"
#import "SMHook.h"
#import "SMSeaCreature.h"
#import "SMFish.h"

@implementation SMHookContactVisitor


- (void)visitSMSeaCreature:(SKPhysicsBody *)seaCreatureBody {
    
    SMHook* hook = (SMHook*) self.body.node;
    SMFisherman* fisherman = (SMFisherman*) hook.fisherman;
    SMSeaCreature* creature = (SMSeaCreature*)seaCreatureBody.node;
    
    // if fish
    // hook it!
    if ([creature isMemberOfClass:[SMFish class]]) {
        [fisherman checkHookedFish:(SMFish*)creature];
    }
}

- (void)visitSMFish:(SKPhysicsBody *)fishBody {
    [self visitSMSeaCreature:fishBody];
}

@end
