//
//  gaode_Location.h
//  HaiHeApp
//
//  Created by 信昊 on 17/5/22.
//  Copyright © 2017年 马广召. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

typedef void(^LocationBlock)(CLLocation *,AMapLocationReGeocode *);
@interface gaode_Location : NSObject

@property (nonatomic, strong) AMapLocationManager *locationManager;

-(void)getLocation:(LocationBlock) block;

+(id)shareInstance;
@end
