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
        self.texture = [SKTexture textureWithImageNamed:@fileHook];
        
        self.anchorPoint = CGPointMake(0.5, 1.0);
        
        self.color = [UIColor whiteColor];
        self.size = CGSizeMake(hookWidth, hookHeight);
        self.name = @nodeNameHook;
        self.zPosition = zOceanBackground;
        
        //self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(hookWidth, hookHeight)];
        
        //self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(17.0, 17.0) center:CGPointZero];
        
        CGRect bodyRect = CGRectMake(0, -25.0, hookWidth/2, hookWidth/2);
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bodyRect];
        
        self.physicsBody.categoryBitMask = bitmaskCategoryHook;
        self.physicsBody.allowsRotation = NO;
        self.physicsBody.collisionBitMask = bitmaskCategoryNeutral;
        self.physicsBody.contactTestBitMask = bitmaskCategoryCreature;
    }
    
    return self;    
}

@end
