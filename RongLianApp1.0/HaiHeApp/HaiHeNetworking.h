//
//  HaiHeNetworking.h
//  SignNameTest
//
//  Created by 马广召 on 15/8/3.
//  Copyright (c) 2015年 马广召. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^dicBlock)(NSDictionary * dic,NSString * errorCode);
@interface HaiHeNetworking : NSObject<NSXMLParserDelegate>

@property(nonatomic,retain)NSMutableString * getMessage;
//@property (nonatomic,retain)NSDictionary * returnDic;
+ (instancetype)sharedHaiheNet;

//- (void)haveaTry;

- (void)sendRequestWithSendMessage:(NSString *)sendMessage WithSuccess:(dicBlock)messageDic;
@end
