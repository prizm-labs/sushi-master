//
//  SMCreatureSpawner.h
//  sushi-master
//
//  Created by Michael Garrido on 3/16/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMOcean,SMSeaCreature;

@interface SMCreatureSpawner : NSObject {
    
    SMOcean* ocean;
    int creatureCategory;
    
    bool isActive;
    
    Class creatureClass;

    double nextCreatureSpawnTime;
    NSMutableArray* creatures;
}

@property float minimumSpawnTime;
@property float maximumSpawnTime;
@property int creatureLimit;

-(id) initWithCreatureCategory:(Class)_creatureClass InOcean:(SMOcean*)_ocean;
-(void) startSpawning;
-(void) spawnCreaturesContinuously;
-(void) removeCreature:(SMSeaCreature*)creature;

@end
