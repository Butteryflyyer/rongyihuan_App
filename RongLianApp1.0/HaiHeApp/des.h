//
//  des.h
//  HaiHeApp
//
//  Created by 信昊 on 16/4/26.
//  Copyright © 2016年 马广召. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface des : NSObject

//加密解密

/**
 *     kCCEncrypt = 0,
       kCCDecrypt,
 *
*/

+(NSString*)encryptWithContent:(NSString*)content type:(CCOperation)type key:(NSString*)aKey;
@end
