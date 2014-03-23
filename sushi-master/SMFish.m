//
//  SMFish.m
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMFish.h"
#import "SMFisherman.h"
#import "SMChumPiece.h"
#import "SMOcean.h"

@implementation SMFish

-(id) init
{
    self = [super init];
    
    if (self)
    {
        NSLog(@"init fish");
        //[self setup];
    }
    
    return self;
}

-(id) initWithCreatureClass: (int)_creatureClass AndSizeClass: (int)_sizeClass AtPoint: (CGPoint)origin {
    self = [super init];
    
    if (self)
    {
        
        creatureClass = _creatureClass;
        sizeClass = _sizeClass;
        self.position = origin;
        
        [self setup];
    }
    
    return self;
}

-(void) setup {
    
    self.userInteractionEnabled = YES;
    isLured = NO;
    
    levelUpLimits = @[ @1.0, @5.0, @10.0, @20.0];
    
    //currentCommandMarker = nil;
    bodyNode = nil;
    
    luringChum = nil;
    
    willReceiveCommands = YES;
    movementDirection = 0;
    
    self.name = @nodeNameFish;
    self.zPosition = zOceanForeground;
    
    foodLevel = 0;
    movementSpeed = 0.25; // time to move 1 tile width
    
    [self updateBody];
}

-(void) updateBody {
    
    NSLog(@"fish update body enter: %@",self.children);
    NSLog(@"body node: %@",bodyNode);
    
    //NSLog(@"size class:%i",sizeClass);
    //NSLog(@"creature class:%i",creatureClass);
    
    float creatureWidth;
    float creatureHeight;
    UIColor* creatureColor;
    
    // TODO differentiate class by...
    // blending a color into sprite??
    
    switch (creatureClass) {
        case 0:
            creatureColor = [UIColor grayColor];
            creatureWidth = fishAwidth;
            creatureHeight = fishAheight;
            break;
        case 1:
            creatureColor = [UIColor yellowColor];
            creatureWidth = fishAwidth;
            creatureHeight = fishAheight;
            break;
        default:
            creatureWidth = fishAwidth;
            creatureHeight = fishAheight;
    }
    
    switch (sizeClass) {
        case 0:
            sizeRatio = fishSize0;
            weight = fishWeight0;
            break;
        case 1:
            sizeRatio = fishSize1;
            weight = fishWeight1;
            break;
        case 2:
            sizeRatio = fishSize2;
            weight = fishWeight2;
            break;
        case 3:
            sizeRatio = fishSize3;
            weight = fishWeight3;
            break;
        case 4:
            sizeRatio = fishSize4;
            weight = fishWeight4;
            break;
            
    }
    
    
    
    if (bodyNode!=NULL) {
        [bodyNode removeFromParent];
    }
    
    //CGSize creatureSize = CGSizeMake(creatureWidth, creatureHeight);
    
    SKSpriteNode* newBody = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@fileFishA] size:CGSizeMake(creatureWidth, creatureHeight)];
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(creatureWidth*fishAContactSizeRatio, creatureHeight*fishAContactSizeRatio)];
    
    self.physicsBody.categoryBitMask = bitmaskCategoryCreature;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.collisionBitMask = bitmaskCategoryNeutral;
    self.physicsBody.contactTestBitMask = bitmaskCategoryHook | bitmaskCategoryChum;
    /*
     self.physicsBody.dynamic = YES;
     self.physicsBody.restitution = 0.2;
     self.physicsBody.mass = 5;
     */
    
    //NSLog(@"new body:%@",newBody);
    
    bodyNode = newBody;
    
    bodyNode.xScale = sizeRatio;
    bodyNode.yScale = sizeRatio;
    
    [self addChild:bodyNode];
    
    //NSLog(@"body node:%@",bodyNode);
    NSLog(@"fish update body exit: %@",self.children);
}

-(void)swimmingLoop
{
    SKTextureAtlas *fishSwimmingAtlas = [SKTextureAtlas atlasNamed:@"fish"];
    
    NSArray *swimFrames = @[[fishSwimmingAtlas textureNamed:@"fish1"],[fishSwimmingAtlas textureNamed:@"fish2"],[fishSwimmingAtlas textureNamed:@"fish1"],[fishSwimmingAtlas textureNamed:@"fish3"]];
    
    NSLog(@"swim frames: %@",swimFrames);
    
    [bodyNode runAction:[SKAction repeatActionForever:
                      [SKAction animateWithTextures:swimFrames
                                       timePerFrame:0.25f
                                             resize:NO
                                            restore:YES]] withKey:@"swimming"];
    return;
}

-(void) startSwimmingInDirection:(int)_movementDirection {
    [super startSwimmingInDirection:_movementDirection];
    [self swimmingLoop];
}

-(void) luredByChum:(SMChumPiece*)chum {
    
    if (!isLured) {
        
        luringChum = chum;
        isLured = YES;
        [chum lureFish:self];
        [self updateDirection:1 AtPosition:CGPointMake(chum.position.x, self.position.y)];
    }
    
}

-(void) breakaway {
    
    NSLog(@"fish breaking away!!!!");
    
    isLured = NO;
    luringChum = nil;
    [self updateDirection:2     AtPosition:self.position];
    
}

-(void) lostScent {
    
    isLured = NO;
    luringChum = nil;
    [self updateDirection:2 AtPosition:self.position];
    
}

-(void) eatChum:(SMChumPiece *)chum {
    
    [chum consumedByFish:self];
    
    [self updateDirection:3 AtPosition:chum.position];
    
}

-(void) updateDirection:(int)direction AtPosition:(CGPoint)position {
    if (movementDirection!=direction) {
        
        if ([self actionForKey:@kActionSwimmingKey]) {
            [self removeActionForKey:@kActionSwimmingKey];
        }
        
        self.position = position;
        
        [self startSwimmingInDirection:direction];
        
    }
    
}

-(void) caughtByFisherman:(SMFisherman*)fisherman {
    
    if ([self actionForKey:@kActionSwimmingKey]) {
        [self removeActionForKey:@kActionSwimmingKey];
    }
    
    luringChum = nil;
    
    [ocean removeFish:self];
    
    // attach to hook
}

-(void) loadIntoBoat {
    
    [self removeFromParent];
    
}

@end
