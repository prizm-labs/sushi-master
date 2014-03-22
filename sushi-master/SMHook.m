//
//  SMHook.m
//  sushi-master
//
//  Created by Michael Garrido on 3/22/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMHook.h"

@implementation SMHook

-(id) init {
    
    self = [super init];
    
    if (self)
    {
        self.color = [UIColor whiteColor];
        self.size = CGSizeMake(fishHookWidth, fishHookWidth);
        self.name = @nodeNameHook;
        self.zPosition = zOceanBackground;
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(fishHookWidth, fishHookWidth)];
        
        self.physicsBody.categoryBitMask = bitmaskCategoryHook;
        self.physicsBody.allowsRotation = NO;
        self.physicsBody.collisionBitMask = bitmaskCategoryNeutral;
        self.physicsBody.contactTestBitMask = bitmaskCategoryCreature;
        
    }
    
    return self;
    
}

@end
