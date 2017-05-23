//
//  RechargeObj.m
//  HaiHeApp
//
//  Created by 马广召 on 15/10/29.
//  Copyright © 2015年 马广召. All rights reserved.
//
#define  PageSize (@"9")
#import "RechargeObj.h"
#import "HaiHeNetBridge.h"

@implementation RechargeObj
- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
//    @property (nonatomic, retain)NSString * txTime;
//    @property (nonatomic, retain)NSString * czje;
//    @property (nonatomic, retain)NSString * liushuihao;
//    @property (nonatomic, retain)NSString * czjg;
    
    self.txTime = [NSString stringWithFormat:@"%@ %@",[attributes valueForKey:@"czDay"],[attributes valueForKey:@"czTime"]];
    if(![[attributes valueForKey:@"czje"]isKindOfClass:[NSNull class]]){
        self.czje = [attributes valueForKey:@"czje"];
    }else{
        self.czje = @"";
    }
//    if(![[attributes valueForKey:@"ttje"]isKindOfClass:[NSNull class]]){
//        self.ttje = [attributes valueForKey:@"ttje"];
//    }else{
//        self.ttje = @"空";
//    }
    self.liushuihao = [NSString stringWithFormat:@"%@%@",[attributes valueForKey:@"ddh1"],[attributes valueForKey:@"ddh2"]];
    
    if(![[attributes valueForKey:@"czjg"]isKindOfClass:[NSNull class]]){
        self.czjg = [attributes valueForKey:@"czjg"];
    }else{
        self.czjg = @"";
    }
    
    
    return self;
}


+ (void)globalTimelineWithDrawRecordWithUserId:(NSString *)userid andWithStartPage:(NSString *)startpage andWithPresentStatus:(NSString *)status andWithBlock:(void (^)(NSArray *invests, NSString *errorStr,NSString * currentPage))block{
    
    [[HaiHeNetBridge sharedManager] userRechargeRecordRequestWithUserId:userid andWithStartPage:startpage andWithPageSize:PageSize andWithRechargeStatus:status WithSuccess:^(NSString *respString, NSDictionary *datadic) {
        if(!respString){
            NSString * currentStr = [datadic objectForKey:@"currentPage"];
            NSArray *postsFromResponse = [datadic objectForKey:@"dataList"];
            NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
            for (NSDictionary *attributes in postsFromResponse) {
                RechargeObj * rechargeobject = [[RechargeObj alloc] initWithAttributes:attributes];
                [mutablePosts addObject:rechargeobject];
            }
            block(mutablePosts,nil,currentStr);
            
        }else{
            block(nil,respString,nil);
        }
    }];
    
}

@end
