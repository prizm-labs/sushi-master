//
//  SMCreatureSpawner.h
//  sushi-master
// 
//  Created by Michael Garrido on 3/16/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMCreatureSpawner : NSObject {
    
    int speciesCategory;
    float minimumSpawnTime;
    float maximumSpawnTime;
    
    int creatureLimit;
}

@end
