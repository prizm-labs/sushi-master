//
//  SMFishingScene.m
//  sushi-master
//
//  Created by Michael Garrido on 3/2/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#import "SMFishingScene.h"
#import "SMOcean.h"
#import "SMFish.h"
#import "SMSeaTurtle.h"
#import "SMBoat.h"
#import "SMFisherman.h"
#import "SMCreatureSpawner.h"

#import "VisitablePhysicsBody.h"

@implementation SMFishingScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        self.physicsWorld.contactDelegate = self;
        
        
        
        ocean = [[SMOcean alloc] init];
        
        [self addChild:ocean];
        
        //create creature spawners
        SMCreatureSpawner* tunaCreatureSpawner = [[SMCreatureSpawner alloc] initWithCreatureCategory:[SMFish class] InOcean:ocean];
        tunaCreatureSpawner.creatureLimit = 3;
        
        SMCreatureSpawner* turtleCreatureSpawner = [[SMCreatureSpawner alloc] initWithCreatureCategory:[SMSeaTurtle class] InOcean:ocean];
        turtleCreatureSpawner.creatureLimit = 1;
        
        creatureSpawners = [[NSMutableArray alloc] initWithObjects:turtleCreatureSpawner, tunaCreatureSpawner, nil];
        
        [creatureSpawners enumerateObjectsUsingBlock:^(id _spawner, NSUInteger idx, BOOL *stop) {
            
            SMCreatureSpawner* spawner = (SMCreatureSpawner*)_spawner;
            [spawner startSpawning];
            
        }];
        
        gameStarted = NO;
        
        timerLabel = [SKLabelNode node];
        timerLabel.fontColor = [SKColor whiteColor];
        timerLabel.fontSize = 40.0;
        timerLabel.zPosition = zOceanForeground;
        timerLabel.position = CGPointMake(40.0, screenHeight-40.0)
        ;
        
        [self addChild:timerLabel];
        
        weightLabel = [SKLabelNode node];
        weightLabel.fontColor = [SKColor whiteColor];
        weightLabel.fontSize = 40.0;
        weightLabel.zPosition = zOceanForeground;
        weightLabel.position = CGPointMake(screenWidth-40.0, screenHeight-40.0)
        ;
        
        [self addChild:weightLabel];
        
        //TODO start game from overlay?
        
        startGameLabel = [SKLabelNode node];
        startGameLabel.text = @"START";
        startGameLabel.fontColor = [SKColor whiteColor];
        startGameLabel.fontSize = 60.0;
        startGameLabel.zPosition = zOceanForeground;
        startGameLabel.position = CGPointMake(300, 100)
        ;
        
        [self addChild:startGameLabel];
        
        
    }
    return self;
}

-(void) updateTimer {
    
    timeAmount-=1;
    timerLabel.text = [NSString stringWithFormat:@"%i",timeAmount];
    
    if (timeAmount==0) {
        [self endGame];
    }
}

-(void) updateWeightCounter:(float)addedWeight {
    
    NSLog(@"adding weight to counter: %f",addedWeight);
    
    weightCount+=addedWeight;
    
    //TODO animate weight counter increase
    
    weightLabel.text = [NSString stringWithFormat:@"%i kg",(int)weightCount];
}

-(void) startGame {
    
    [self resetGame];
    
    NSLog(@"startingGame");
    
    gameStarted = YES;
    startGameLabel.hidden = YES;
    
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

-(void) addTime:(int)amount {
    
    timeAmount+=amount;
}

-(void) endGame {
    
    gameStarted = NO;
    startGameLabel.hidden = NO;
    
    if ([countdownTimer isValid]) {
        [countdownTimer invalidate];
        countdownTimer = nil;
    }
    
    // tally fish
    
}


-(void) resetGame {
    
    weightCount = 0;
    timeAmount = 60;
    
    //[ocean removeAllFish];
    //[boat removeAllFish];
    [ocean.boat dumpCatch];
}

-(void) highlightImminentBite {
    
    
}

-(void) showHookedFish {
    
    
}

-(void) showMissedFish {
    
    
}

#pragma mark Contact Handling

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    // Inspect these closely, they're actually private class instances of PKPhysicsBody
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
    
    NSLog(@"didBeginContact 1st Body: %@",firstBody.node.name);
    NSLog(@"didBeginContact 2nd Body: %@",secondBody.node.name);


    VisitablePhysicsBody *firstVisitableBody = [[VisitablePhysicsBody alloc] initWithBody:firstBody];
    VisitablePhysicsBody *secondVisitableBody = [[VisitablePhysicsBody alloc] initWithBody:secondBody];
    
    [firstVisitableBody acceptVisitor:[ContactVisitor contactVisitorWithBody:secondBody forContact:contact]];
    [secondVisitableBody acceptVisitor:[ContactVisitor contactVisitorWithBody:firstBody forContact:contact]];
}


#pragma mark Touch Handling

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ([self nodeAtPoint:location]==startGameLabel) {
            
            if (!gameStarted) {
                [self startGame];
            }
            
        }
        
        
    }
}

#pragma mark Animation Handling

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    //[ocean spawnCreaturesContinuously];
    
    [creatureSpawners enumerateObjectsUsingBlock:^(id _spawner, NSUInteger idx, BOOL *stop) {
        
        SMCreatureSpawner* spawner = (SMCreatureSpawner*)_spawner;
        [spawner spawnCreaturesContinuously];
        
    }];
    
    // creature movement and commands
    
    
    [ocean.creatures enumerateObjectsUsingBlock:^(id _creature, NSUInteger idx, BOOL *stop) {
    //[ocean enumerateChildNodesWithName:@nodeNameFish usingBlock:^(SKNode *nodeB, BOOL *stop) {
        
       
        SMSeaCreature* creature = (SMSeaCreature*)_creature;
        
        // TODO checks according to creature species
        
        //[ocean checkChumLuredFish:creature];
        //[ocean checkChumWillBeEatenByFish:creature];
        
        [creature wrapMovement];
        
        [ocean.boat.fishermen enumerateObjectsUsingBlock:^(id _fisherman, NSUInteger idx, BOOL *stop) {
            
            
            if ([creature isMemberOfClass:[SMFish class]]) {
                SMFisherman* fisherman = (SMFisherman*)_fisherman;
                
                //TODO let contact delegate check hook
                //[fisherman checkHookedFish:(SMFish*)creature];
            }
            
            
        }];
    }];
    
    
}
@end
