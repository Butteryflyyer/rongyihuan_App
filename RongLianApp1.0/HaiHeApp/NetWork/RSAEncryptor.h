//基于RSA加密、解密、加签、验签；
#import <Foundation/Foundation.h>

@interface RSAEncryptor : NSObject



#pragma mark - Instance Methods
//加载客户端公钥；
//-(void)loadPublicKeyFromFile: (NSString*) derFilePath;
//-(void)loadPublicKeyFromData: (NSData*) derData;
////加载客户端私钥；
//-(void)loadPrivateKeyFromFile: (NSString*) p12FilePath password:(NSString*)p12Password;
//-(void)loadPrivateKeyFromData: (NSData*) p12Data password:(NSString*)p12Password;
////加载服务器端公钥；
//-(void)loadSeverPublicKeyFromFile: (NSString*) derFilePath;
//-(void)loadSeverPublicKeyFromData: (NSData*) derData;

//基于RSA的加密；
-(NSString*)rsaEncryptString:(NSString*)string;
-(NSData*)rsaEncryptData:(NSData*)data ;
//基于RSA的解密；
-(NSString*)rsaDecryptString:(NSString*)string;
-(NSData*)rsaDecryptData:(NSData*)data;
//基于RSA的验证签名；
-(BOOL)rsaSHA1VerifyData:(NSData *) plainData
                     withSignature:(NSData *) signature;
//基于RSA的签名；
-(NSString *)signTheDataSHA1WithRSA:(NSString *)plainText;

#pragma mark - Class Methods

+(void)setSharedInstance: (RSAEncryptor*)instance;
+(RSAEncryptor*) sharedInstance;


//mgz have a chenge

//-(NSString *)signTheDataSHA1WithRSA:(NSString *)plainText;

@end