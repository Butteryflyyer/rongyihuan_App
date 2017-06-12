#import <Security/Security.h>
#import "RSAEncryptor.h"
#import "Base64.h"
#import <CommonCrypto/CommonCrypto.h>

#define kChosenDigestLength CC_SHA1_DIGEST_LENGTH

@implementation RSAEncryptor


- (SecKeyRef)getSeverPublickey{

    NSString * path = [[NSBundle mainBundle] pathForResource:@"rl2_public_key" ofType:@"der"];
    NSData * derData = [NSData dataWithContentsOfFile:path];
    return [self getPublickeyWithDerData:derData];
}
- (SecKeyRef)getClientPublickey{
   //没用
    NSString * path = [[NSBundle mainBundle] pathForResource:@"rl2_public_key" ofType:@"der"];
    NSData * derData = [NSData dataWithContentsOfFile:path];
    return [self getPublickeyWithDerData:derData];
}

- (SecKeyRef)getPublickeyWithDerData:(NSData *)derData{

    SecCertificateRef myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)derData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);
    }
    SecKeyRef securityKey = SecTrustCopyPublicKey(myTrust);
    CFRelease(myCertificate);
    CFRelease(myPolicy);
    CFRelease(myTrust);
    
    return securityKey;
}

- (SecKeyRef)getClientPrivateKey{

    NSString * path = [[NSBundle mainBundle] pathForResource:@"rl_private_key" ofType:@"p12"];
    NSData * p12Data = [NSData dataWithContentsOfFile:path];
    NSString * password = @"123456";
    SecKeyRef privateKeyRef = NULL;
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    [options setObject: password forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data, (__bridge CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    
    return privateKeyRef;

}

#pragma mark - Private Methods

//-(SecKeyRef)getPublicKeyRefrenceFromeData:(NSData*)derData
//{
//    SecCertificateRef myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)derData);
//    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
//    SecTrustRef myTrust;
//    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
//    SecTrustResultType trustResult;
//    if (status == noErr) {
//        status = SecTrustEvaluate(myTrust, &trustResult);
//    }
//    SecKeyRef securityKey = SecTrustCopyPublicKey(myTrust);
//    CFRelease(myCertificate);
//    CFRelease(myPolicy);
//    CFRelease(myTrust);
//    
//    return securityKey;
//}
//
//
//-(SecKeyRef)getPrivateKeyRefrenceFromData: (NSData*)p12Data password:(NSString*)password
//{
//    SecKeyRef privateKeyRef = NULL;
//    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
//    [options setObject: password forKey:(__bridge id)kSecImportExportPassphrase];
//    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
//    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data, (__bridge CFDictionaryRef)options, &items);
//    if (securityError == noErr && CFArrayGetCount(items) > 0) {
//        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
//        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
//        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
//        if (securityError != noErr) {
//            privateKeyRef = NULL;
//        }
//    }
//    CFRelease(items);
//    
//    return privateKeyRef;
//}
//


#pragma mark - Encrypt

-(NSString*)rsaEncryptString:(NSString*)string {
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encryptedData = [self rsaEncryptData: data];
    NSString* base64EncryptedString = [encryptedData base64EncodedString];
    return base64EncryptedString;
}

// 加密的大小受限于SecKeyEncrypt函数，SecKeyEncrypt要求明文和密钥的长度一致，如果要加密更长的内容，需要把内容按密钥长度分成多份，然后多次调用SecKeyEncrypt来实现
-(NSData*) rsaEncryptData:(NSData*)data {
    SecKeyRef key = [self getSeverPublickey];
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    size_t blockSize = cipherBufferSize - 11;       // 分段加密
    size_t blockCount = (size_t)ceil([data length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init] ;
    for (int i=0; i<blockCount; i++) {
        // mgz have a chenge in there : add three int;
        int bufferSize = MIN((int)blockSize,(int)[data length] - i * (int)blockSize);
        NSData *buffer = [data subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(key, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes], [buffer length], cipherBuffer, &cipherBufferSize);
        if (status == noErr){
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }else{
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer){
        free(cipherBuffer);
    }
    return encryptedData;
}

#pragma mark - Decrypt

-(NSString*) rsaDecryptString:(NSString*)string {

    NSData* data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData* decryptData = [self rsaDecryptData: data];
    NSString* result = [[NSString alloc] initWithData: decryptData encoding:NSUTF8StringEncoding];
    return result;
}

-(NSData*) rsaDecryptData:(NSData*)data {
    SecKeyRef key = [self getClientPrivateKey];
    size_t cipherLen = [data length];
    void *cipher = malloc(cipherLen);
    [data getBytes:cipher length:cipherLen];
    size_t plainLen = SecKeyGetBlockSize(key) - 12;
    void *plain = malloc(plainLen);
    OSStatus status = SecKeyDecrypt(key, kSecPaddingPKCS1, cipher, cipherLen, plain, &plainLen);
    
    if (status != noErr) {
        return nil;
    }
    
    NSData *decryptedData = [[NSData alloc] initWithBytes:(const void *)plain length:plainLen];
    
    return decryptedData;
}

#pragma marke - verify file SHA1 
-(BOOL)rsaSHA1VerifyData:(NSData *)plainData
                     withSignature:(NSData *)signature {
    SecKeyRef publicKey = [self getSeverPublickey];
    size_t signedHashBytesSize = SecKeyGetBlockSize(publicKey);
    const void* signedHashBytes = [signature bytes];
    
    size_t hashBytesSize = CC_SHA1_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA1([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return NO;
    }
    
    OSStatus status = SecKeyRawVerify(publicKey,
                                      kSecPaddingPKCS1SHA1,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);
    
    return status == errSecSuccess;
}

#pragma mark - Class Methods

static RSAEncryptor* sharedInstance = nil;

+(void)setSharedInstance: (RSAEncryptor*)instance
{
    sharedInstance = instance;
}

+(RSAEncryptor*)sharedInstance
{
    return sharedInstance;
}



// mgz have;

- (NSData *)getHashBytes:(NSData *)plainText {
    
    CC_SHA1_CTX ctx;
    
    uint8_t * hashBytes = NULL;
    NSData * hash = nil;
    
    // Malloc a buffer to hold hash.
    hashBytes = malloc( kChosenDigestLength * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, kChosenDigestLength);
    // Initialize the context.
    CC_SHA1_Init(&ctx);
    // Perform the hash.
    // mgz have a chenge in there : add the int;
    CC_SHA1_Update(&ctx, (void *)[plainText bytes],(int)[plainText length]);
    // Finalize the output.
    CC_SHA1_Final(hashBytes, &ctx);
    
    // Build up the SHA1 blob.
    hash = [NSData dataWithBytes:(const void *)hashBytes length:(NSUInteger)kChosenDigestLength];
    // mgz have a chenge in there : add the int;
    if ((int)hashBytes)
        free(hashBytes);
    
    return hash;
}

//RSA 签名；
-(NSString *)signTheDataSHA1WithRSA:(NSString *)plainText{
    uint8_t* signedBytes = NULL;
    size_t signedBytesSize = 0;
    OSStatus sanityCheck = noErr;
    NSData* signedHash = nil;
    
//    NSString * path = [[NSBundle mainBundle]pathForResource:@"SeverPrivate_key" ofType:@"p12"];
//    NSData * data = [NSData dataWithContentsOfFile:path];
//    NSMutableDictionary * options = [[NSMutableDictionary alloc] init]; // Set the private key query dictionary.
//    [options setObject:@"123456" forKey:(__bridge id)kSecImportExportPassphrase];
//    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
//    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) data, (__bridge CFDictionaryRef)options, &items);
//    if (securityError!=noErr) {
//        return nil ;
//    }
//    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
//    SecIdentityRef identityApp =(SecIdentityRef)CFDictionaryGetValue(identityDict,kSecImportItemIdentity);
//    SecKeyRef privateKeyRef=nil;
//    SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
    SecKeyRef privateKeyRef = [self getClientPrivateKey];
    signedBytesSize = SecKeyGetBlockSize(privateKeyRef);
    
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    signedBytes = malloc( signedBytesSize * sizeof(uint8_t) ); // Malloc a buffer to hold signature.
    memset((void *)signedBytes, 0x0, signedBytesSize);
    
    sanityCheck = SecKeyRawSign(privateKeyRef,
                                kSecPaddingPKCS1SHA1,
                                (const uint8_t *)[[self getHashBytes:plainTextBytes] bytes],
                                kChosenDigestLength,
                                (uint8_t *)signedBytes,
                                &signedBytesSize);
    
    if (sanityCheck == noErr)
    {
        signedHash = [NSData dataWithBytes:(const void *)signedBytes length:(NSUInteger)signedBytesSize];
    }
    else
    {
        return nil;
    }
    
    if (signedBytes)
    {
        free(signedBytes);
    }
    NSString *signatureResult=[NSString stringWithFormat:@"%@",[signedHash base64EncodedString]];
    
    signatureResult = [signatureResult stringByReplacingOccurrencesOfString:@"/" withString:@"\\/"];
    
    return signatureResult;
}  // RSA 加密；


@end