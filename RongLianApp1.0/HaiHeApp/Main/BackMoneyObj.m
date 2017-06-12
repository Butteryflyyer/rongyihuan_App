//
//  BackMoneyObj.m
//  HaiHeApp
//
//  Created by 马广召 on 16/3/4.
//  Copyright © 2016年 马广召. All rights reserved.
//

#import "BackMoneyObj.h"

@implementation BackMoneyObj
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if(![[attributes valueForKey:@"id"]isKindOfClass:[NSNull class]]){
        self.proid = [attributes valueForKey:@"id"];
    }else{
        self.proid = @"";
    }
    if(![[attributes valueForKey:@"hkrq"]isKindOfClass:[NSNull class]]){
        self.hkrq = [attributes valueForKey:@"hkrq"];
    }else{
        self.hkrq = @"";
    }
    
    if(![[attributes valueForKey:@"qs"]isKindOfClass:[NSNull class]]){
        self.qs = [attributes valueForKey:@"qs"];
    }else{
        self.qs = @"";
    }
    if(![[attributes valueForKey:@"bj"]isKindOfClass:[NSNull class]]){
        self.bj = [attributes valueForKey:@"bj"];
    }else{
        self.bj = @"";
    }
    if(![[attributes valueForKey:@"fwf"]isKindOfClass:[NSNull class]]){
        self.fwf = [attributes valueForKey:@"fwf"];
    }else{
        self.fwf = @"";
    }
    if(![[attributes valueForKey:@"yhze"]isKindOfClass:[NSNull class]]){
        self.yhze = [attributes valueForKey:@"yhze"];
    }else{
        self.yhze = @"";
    }
    if(![[attributes valueForKey:@"qtfy"]isKindOfClass:[NSNull class]]){
        self.qtfy = [attributes valueForKey:@"qtfy"];
    }else{
        self.qtfy = @"";
    }
    if(![[attributes valueForKey:@"zt"]isKindOfClass:[NSNull class]]){
        self.zt = [attributes valueForKey:@"zt"];
    }else{
        self.zt = @"";
    }
    if(![[attributes valueForKey:@"ztcode"]isKindOfClass:[NSNull class]]){
        self.ztcode = [attributes valueForKey:@"ztcode"];
    }else{
        self.ztcode = @"";
    }


    
    
    
    
    return self;
}

@end
