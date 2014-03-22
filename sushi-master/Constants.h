//
//  Constants.h
//  sushi-master
//
//  Created by Michael Garrido on 3/3/14.
//  Copyright (c) 2014 PRZM. All rights reserved.
//

#ifndef sushi_master_Constants_h
#define sushi_master_Constants_h

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

#define kNodeCreatureName "creature"
#define kNodeCommandName "command"

#define kActionSwimmingKey "swimming"

#define kCreatureCategoryBitMask 1


#define kUpDirection 1
#define kRightDirection 2
#define kDownDirection 3
#define kLeftDirection 4

#define oceanHeight screenHeight*0.65

#define boatWidth screenWidth*0.85
#define boatHeight screenHeight*0.15

#define fishermanWidth 50.0

#define chumPieceWidth 10.0
#define fishHookWidth 15.0
#define fishHookCastingTime 2.0
#define fishHookDepth -200.0
#define chumDepth 75.0

#define zOcean 2
#define zOceanBackground zOcean-0.5
#define zOceanForeground zOcean+0.5

#define zBoat 0
#define zBoatForeground zBoat+0.5
#define zBoatBackground zBoat-0.5


#define nodeNameHook "hook"
#define nodeNameFish "fish"
#define nodeNameTurtle "turtle"

#define fishSize0 25.0
#define fishSize1 35.0
#define fishSize2 50.0
#define fishSize3 65.0
#define fishSize4 80.0

#define fishWeight0 10.0
#define fishWeight1 20.0
#define fishWeight2 30.0
#define fishWeight3 40.0
#define fishWeight4 50.0

#define breakawayLimit 2.0
#define chanceLure 0.05

#endif
