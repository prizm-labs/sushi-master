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
#define boatHeight screenHeight*0.25

#define fishermanWidth 40.0

#define chumPieceWidth 10.0
#define fishHookWidth 15.0
#define fishHookDepth 100.0

#define zOcean 2
#define zOceanBackground zOcean-0.5
#define zOceanForeground zOcean+0.5

#define zBoat 0
#define zBoatForeground zBoat+0.5
#define zBoatBackground zBoat-0.5

#define bitmaskCategoryNeutral 32
#define bitmaskCategoryCreature 1
#define bitmaskCategoryHook 2
#define bitmaskCategoryChum 3


#define nodeNameHook "hook"
#define nodeNameFish "fish"
#define fishWidth0 
#define fishWidth1
#define fishWidth2
#define fishWidth3



#endif
