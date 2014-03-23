//
//  SMHookContactVisitor.h
//  sushi-master
//
//  Created by Michael Garrido on 3/22/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "ContactVisitor.h"

@interface SMHookContactVisitor : ContactVisitor

- (void)visitSMSeaCreature:(SKPhysicsBody *)seaCreatureBody;

- (void)visitSMFish:(SKPhysicsBody *)fishBody;

@end
