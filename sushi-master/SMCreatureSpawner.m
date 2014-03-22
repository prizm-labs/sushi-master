//
//  SMCreatureSpawner.m
//  sushi-master
//
//  Created by Michael Garrido on 3/16/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMCreatureSpawner.h"

#import "SMSeaCreature.h"
#import "SMFish.h"
#import "SMSeaTurtle.h"
#import "SMOcean.h"

@implementation SMCreatureSpawner

@synthesize minimumSpawnTime, maximumSpawnTime, creatureLimit;

-(id) initWithCreatureCategory:(Class)_creatureClass InOcean:(SMOcean*)_ocean
{
    self = [super init];
    
    if (self)
    {
        isActive = false;
        
        minimumSpawnTime = 1.0;
        maximumSpawnTime = 3.0;
        
        creatureClass = _creatureClass;
        ocean = _ocean;
        
        creatureLimit = 1;
        creatures = [[NSMutableArray alloc] init];
        nextCreatureSpawnTime = 0;
    }
    
    return self;
}

-(void) startSpawning {
    
    isActive = true;
    
}

-(void) stopSpawning {
    
    isActive = false;
    
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
        
        //[self spawnCreatureWithClass:newCreatureClass Size:[[creatureData valueForKey:@"size"] intValue] Direction:[[creatureData valueForKey:@"direction"] intValue] AtX:[[creatureData valueForKey:@"x"] intValue] AndY:[[creatureData valueForKey:@"y"] intValue]];
        
    }];
}

-(void) spawnCreatureWithSize:(int)size Class:(int)class Direction:(int)direction AtX:(int)x AndY:(int)y {
    
    //NSLog(@"spawning creature: class %i, size %i, direction %i, x %i, y %i",class,size,direction,x,y);
    
    CGPoint newCreaureOrigin = [self pointAtGridX:x AndGridY:y];
    
    SMSeaCreature* creature = [[creatureClass alloc] init];
    
    
    creature.creatureClass = class;
    creature.sizeClass = size;
    creature.position = newCreaureOrigin;
    
    [creature setup];
    
    //SMSeaCreature* creature = [[myClass alloc] initWithCreatureClass:class AndSizeClass:size AtPoint:newCreaureOrigin];
    
    [ocean addChild:creature];
    [ocean.creatures addObject:creature];
    
    [creatures addObject:creature];
    
    creature.ocean = ocean;
    creature.spawner = self;
    
    if (direction!=0) {
        [creature startSwimmingInDirection:direction];
    }
    
}

-(void) spawnCreaturesContinuously {
    
    if (!isActive) {
        return;
    }
    
    double currentTime = CACurrentMediaTime();
    
    if ( currentTime > nextCreatureSpawnTime) {
        
        NSLog(@"creature count: %lu",(unsigned long)[creatures count]);
        
        float timeToNextSpawn = [self randomValueBetween:minimumSpawnTime andValue:maximumSpawnTime];
        
        nextCreatureSpawnTime = currentTime+timeToNextSpawn;
        
        if ([creatures count]<creatureLimit) {
            
            int newCreatureClass = floorf([self randomValueBetween:1 andValue:3]);
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
            
            [self spawnCreatureWithSize:newCreatureSize Class:newCreatureClass Direction:newCreatureDirection AtX:newCreatureX AndY:newCreatureY];
            
        }
       
    }
    
}

-(void) removeCreature:(SMSeaCreature*)creature {
    [creatures removeObject:creature];
    NSLog(@"creature count: %lu",(unsigned long)[creatures count]);
    
}

@end
