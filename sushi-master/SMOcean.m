//
//  SMOcean.m
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMOcean.h"
#import "SMChumPiece.h"
#import "SMBoat.h"
#import "SMFish.h"

@implementation SMOcean

@synthesize bodyNode, boat;

-(id) init
{
    self = [super init];
    
    if (self)
    {
        self.userInteractionEnabled = YES;
        
        baseHeight = oceanHeight;
        baseWidth = screenWidth;
        
        CGSize baseSize = CGSizeMake(baseWidth, baseHeight);
        SKColor* baseColor = [SKColor colorWithRed:0.2 green:1.0 blue:0.8 alpha:0.5];
        
        self.size = baseSize;
        
        bodyNode = [SKSpriteNode spriteNodeWithColor:baseColor size:baseSize];
        bodyNode.position = CGPointMake(baseWidth/2, baseHeight/2);
        bodyNode.zPosition = zOcean;
        [self addChild:bodyNode];
        
        // setup
        
        creatureLimit = 1;
        creatures = [[NSMutableArray alloc] init];
        nextCreatureSpawnTime = 0;
        
        chumPieces = [[NSMutableArray alloc] init];
        
        // start game
        
        [self addFishingBoat];
        
    }
    
    return self;
}

-(void) addFishingBoat {
    
    boat = [[SMBoat alloc] init];
    boat.position = CGPointMake(0,baseHeight/2);
    boat.ocean = self;
    [bodyNode addChild:boat];
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        NSLog(@"ocean touched: %f,%f",location.x,location.y);
        
        [boat scatterChumOfQuantity:1];
        //[self addChumAtLocation:location];
    }
}

-(void) throwChumToLocation {
    
}

-(void) checkChumLuredFish:(SMFish*)fish {
    
    [chumPieces enumerateObjectsUsingBlock:^(id chumPiece, NSUInteger idx, BOOL *stop) {
        
        SMChumPiece* chum = (SMChumPiece*)chumPiece;
        //NSLog(@"chum piece x: %f",chum.position.x);
        //NSLog(@"fish: %f",fish.position.x);
        
        float xProximity = fabsf(chum.position.x-fish.position.x);
        
        if (xProximity<5.0) {
            //NSLog(@"command intersects creature");
            //[fish updateDirectionFromCommand:command];
            
            [fish luredByChum:chum];
        }

        
    }];
    
}

-(void) checkChumWillBeEatenByFish:(SMFish*)fish {
    
    [chumPieces enumerateObjectsUsingBlock:^(id chumPiece, NSUInteger idx, BOOL *stop) {
    
        SMChumPiece* chum = (SMChumPiece*)chumPiece;
        
        float xProximity = fabsf(chum.position.x-fish.position.x);
        float yProximity = fabsf(chum.position.y-fish.position.y);
        
        if (xProximity<5.0 && yProximity<5.0) {
            
            [fish eatChum:chum];
        }
        
        
    }];
}

-(void) removeFish:(SMFish *)fish {
    
    [fish removeFromParent];
    [creatures removeObject:fish];
    
}

-(void) removeChum:(SMChumPiece*)chum {
    [chum removeFromParent];
    [chumPieces removeObject:chum];
}


-(void) addChumAtLocation:(CGPoint)location {
    
    
    SMChumPiece* chumPiece = [[SMChumPiece alloc] init];
    chumPiece.zPosition = zOceanForeground;
    chumPiece.position = location;
    
    chumPiece.ocean = self;
    
    [chumPieces addObject:chumPiece];
    [self addChild:chumPiece];
}

- (float)randomValueBetween:(float)low andValue:(float)high {
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

-(CGPoint) pointAtGridX:(int)x AndGridY:(int)y {
    
    float positionX = x*kTileWidth;
    float positionY = y*kTileWidth;
    
    return CGPointMake(positionX,positionY);
}

-(void) spawnCreaturesFromData:(NSArray*)creaturesData {
    
    //NSLog(@"creatures data: %@",creaturesData);
    
    [creaturesData enumerateObjectsUsingBlock:^(id creatureData, NSUInteger idx, BOOL *stop) {
        
        int newCreatureClass = [[creatureData valueForKey:@"class"] intValue];
        
        [self spawnCreatureWithClass:newCreatureClass Size:[[creatureData valueForKey:@"size"] intValue] Direction:[[creatureData valueForKey:@"direction"] intValue] AtX:[[creatureData valueForKey:@"x"] intValue] AndY:[[creatureData valueForKey:@"y"] intValue]];
        
    }];
}

-(void) spawnCreatureWithClass:(int)class Size:(int)size Direction:(int)direction AtX:(int)x AndY:(int)y {
    
    //NSLog(@"spawning creature: class %i, size %i, direction %i, x %i, y %i",class,size,direction,x,y);
    
    CGPoint newCreaureOrigin = [self pointAtGridX:x AndGridY:y];
    
    SMFish* creature = [[SMFish alloc] initWithCreatureClass:class AndSizeClass:size AtPoint:newCreaureOrigin];

    
    [self addChild:creature];
    [creatures addObject:creature];
    creature.ocean = self;
    
    if (direction!=0) {
        [creature startSwimmingInDirection:direction];
    }
    
}

-(void) spawnCreaturesContinuously {
    
    double currentTime = CACurrentMediaTime();
    
    if ( currentTime > nextCreatureSpawnTime && [creatures count]<creatureLimit) {
        
        NSLog(@"creature count: %i",[creatures count]);
        
        float timeToNextSpawn = [self randomValueBetween:1.0 andValue:3.0];
        
        nextCreatureSpawnTime = currentTime+timeToNextSpawn;
        
        int newCreatureClass = 1;
        int newCreatureSize = floorf([self randomValueBetween:0 andValue:3]);
        int newCreatureX = 0;
        int newCreatureY = floorf([self randomValueBetween:0 andValue:5]);
        int newCreatureDirection = 2;
        
        [self spawnCreatureWithClass:newCreatureClass Size:newCreatureSize Direction:newCreatureDirection AtX:newCreatureX AndY:newCreatureY];
    }
    
}


@end
