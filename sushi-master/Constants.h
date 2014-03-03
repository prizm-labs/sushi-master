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

#define DeviceSpecificSetting(iPhone, iPhoneFive, iPad) ((IS_IPAD) ? (iPad) : ((IS_IPHONE_5) ? (iPhoneFive) : (iPhone)))


#define screenHeight DeviceSpecificSetting(768,320,320)
#define screenWidth DeviceSpecificSetting(1024,568,480)

#define screenCenter CGPointMake(screenWidth/2,screenHeight/2)

#endif
