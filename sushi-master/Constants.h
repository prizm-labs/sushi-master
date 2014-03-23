//
//  Constants.h
//  sushi-master
//
//  Created by Michael Garrido on 3/3/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#ifndef sushi_master_Constants_h
#define sushi_master_Constants_h


// general layout measurements

#define IS_WIDESCREEN ([UIScreen mainScreen].bounds.size.height==568)

//#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
//#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )


#define IS_IPAD    (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)

#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )

#define DeviceSpecificSetting(iPhone, iPhoneFive, iPad) ((IS_IPAD)?(iPad):((IS_IPHONE_5)?(iPhoneFive):(iPhone)))


#define screenHeight DeviceSpecificSetting(768,320,320)
#define screenWidth DeviceSpecificSetting(1024,568,480)

#define screenCenter CGPointMake(screenWidth/2,screenHeight/2)

#define kTileWidth 15.0
#define screenTileWidth floorf(screenWidth/kTileWidth)
#define screenTileHeight floorf(screenHeight/kTileWidth)


// SKAction keys

#define kActionSwimmingKey "swimming"


// sea creature movement

#define kUpDirection 1
#define kRightDirection 2
#define kDownDirection 3
#define kLeftDirection 4


// node layering

#define zOcean 2
#define zOceanBackground zOcean-0.5
#define zOceanForeground zOcean+0.5

#define zBoat 0
#define zBoatForeground zBoat+0.5
#define zBoatBackground zBoat-0.5


// node names

#define kNodeCreatureName "creature"
#define kNodeCommandName "command"

#define nodeNameHook "hook"
#define nodeNameFish "fish"
#define nodeNameTurtle "turtle"


// sea creature weight classes

#define fishWeight0 10.0
#define fishWeight1 20.0
#define fishWeight2 30.0
#define fishWeight3 40.0
#define fishWeight4 50.0

#define breakawayLimit 2.0
#define chanceLure 0.05


// sprite sizing & layout

#define oceanHeight screenHeight*0.65

#define fishermanWidth 50.0
#define chumPieceWidth 10.0

#define fileFishermanA "cat2.png"
#define fishermanAwidth 55.0
#define fishermanAheight 65.0

#define fileBoat "boat.png"
#define boatWidth 650.0
#define boatHeight 148.0
//#define boatWidth 325.0
//#define boatHeight 74.0

#define fileHook "hook.png"
#define hookWidth 17.0
#define hookHeight 31.0

#define fileTurtle "seaturtle1.png"
#define turtleWidth 132.0
#define turtleHeight 102.0

#define fileFishA "fish1.png"
#define fishAwidth 104.0
#define fishAheight 72.0
#define fishAContactSizeRatio 0.3

#define fishSize0 0.5
#define fishSize1 0.65
#define fishSize2 0.8
#define fishSize3 1.0
#define fishSize4 1.15


// node movement & positions

#define fishHookCastingTime 2.0
#define fishHookDepth -(oceanHeight+fishermanAheight/2)
#define chumDepth 75.0

#define boatDeckHeight -20.0
#define boatAboveWaterHeight -10.0



#endif
