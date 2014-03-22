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
#import "SMCreatureSpawner.h"

@implementation SMOcean

@synthesize bodyNode, boat, creatures;

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
        
        creatureLimit = 20;
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
        
        int chumQuantity = 3;
        
        [boat scatterChumOfQuantity:chumQuantity];
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
        
        if (xProximity<1.0) {
            
            // chance increases the more chum pieces in water
            
            
            float chance = [self randomValueBetween:0 andValue:1.0];
            NSLog(@"chance: %f",chance);
            
            float wasLured = [chumPieces count]*0.1;
            
            if (chance<wasLured) {
                 [fish luredByChum:chum];
            }
            
           
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

-(void) removeCreature:(SMSeaCreature*)creature {
    
    [creature removeFromParent];
    [creatures removeObject:creature];
    
    //also remove from spawner
    [creature.spawner removeCreature:creature];
}


-(void) removeFish:(SMFish *)fish {
    
    [fish removeFromParent];
    [creatures removeObject:fish];
    
    //also remove from spawner
    [fish.spawner removeCreature:fish];
    
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
/*
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
        
        NSLog(@"creature count: %lu",(unsigned long)[creatures count]);
        
        float timeToNextSpawn = [self randomValueBetween:1.0 andValue:3.0];
        
        nextCreatureSpawnTime = currentTime+timeToNextSpawn;
        
        int newCreatureClass = 1;
        int newCreatureSize = floorf([self randomValueBetween:0 andValue:1]);
        
        int newCreatureY = floorf([self randomValueBetween:0 andValue:12]);
        
        int newCreatureX, newCreatureDirection;
        
        int startingPositionType = floorf([self randomValueBetween:0 andValue:2]);
        
        if (startingPositionType==0) {
            newCreatureX = 0;
            newCreatureDirection = 2;
        } else {
            newCreatureX = screenTileWidth;
            newCreatureDirection = 4;
        }
        
        NSLog(@"starting type: %i, %i, %i",startingPositionType,newCreatureX,newCreatureDirection);
        
        // spawn on left or right side of screen
        
        [self spawnCreatureWithClass:newCreatureClass Size:newCreatureSize Direction:newCreatureDirection AtX:newCreatureX AndY:newCreatureY];
    }
    
}
*/

@end
