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

@synthesize bodyNode;

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
        
        creatureLimit = 2;
        creatures = [[NSMutableArray alloc] init];
        nextCreatureSpawnTime = 0;
        
        // start game
        
        [self addFishingBoat];
        //[self spawnCreaturesContinuously];
        
    }
    
    return self;
}

-(void) addFishingBoat {
    
    SMBoat* boat = [[SMBoat alloc] init];
    boat.position = CGPointMake(0,baseHeight/2);
    [bodyNode addChild:boat];
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        NSLog(@"ocean touched: %f,%f",location.x,location.y);
        
        [self addChumAtLocation:location];
    }
}

-(void) addChumAtLocation:(CGPoint)location {
    
    
    SMChumPiece* chumPiece = [[SMChumPiece alloc] init];
    chumPiece.zPosition = zOceanForeground;
    chumPiece.position = location;
    
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
    
    NSLog(@"creatures data: %@",creaturesData);
    
    [creaturesData enumerateObjectsUsingBlock:^(id creatureData, NSUInteger idx, BOOL *stop) {
        
        int newCreatureClass = [[creatureData valueForKey:@"class"] intValue];
        
        [self spawnCreatureWithClass:newCreatureClass Size:[[creatureData valueForKey:@"size"] intValue] Direction:[[creatureData valueForKey:@"direction"] intValue] AtX:[[creatureData valueForKey:@"x"] intValue] AndY:[[creatureData valueForKey:@"y"] intValue]];
        
    }];
}

-(void) spawnCreatureWithClass:(int)class Size:(int)size Direction:(int)direction AtX:(int)x AndY:(int)y {
    
    NSLog(@"spawning creature: class %i, size %i, direction %i, x %i, y %i",class,size,direction,x,y);
    
    CGPoint newCreaureOrigin = [self pointAtGridX:x AndGridY:y];
    
    SMFish* creature = [[SMFish alloc] initWithCreatureClass:class AndSizeClass:size AtPoint:newCreaureOrigin];

    
    [self addChild:creature];
    [creatures addObject:creature];
    
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
        int newCreatureY = floorf([self randomValueBetween:0 andValue:8]);
        int newCreatureDirection = 2;
        
        [self spawnCreatureWithClass:newCreatureClass Size:newCreatureSize Direction:newCreatureDirection AtX:newCreatureX AndY:newCreatureY];
    }
    
}


@end
