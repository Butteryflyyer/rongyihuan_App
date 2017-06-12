//
//  HaiHeNetworking.m
//  SignNameTest
//
//  Created by 马广召 on 15/8/3.
//  Copyright (c) 2015年 马广召. All rights reserved.
//

#import "HaiHeNetworking.h"
//#import "RSAEncryptor.h"
#import "AFNetworking.h"
@implementation HaiHeNetworking
static id _haiheNet;
+ (instancetype)sharedHaiheNet{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _haiheNet = [[HaiHeNetworking alloc] init];
    });
    return _haiheNet;
}

- (void)sendRequestWithSendMessage:(NSString *)sendMessage WithSuccess:(dicBlock)messageDic{

    //真实地址：http://ryh.zyskcn.com:8092/WebService/RYH_Interface.asmx
    //测试地址：http://192.168.13.15:8007/WebService/RYH_Interface.asmx
    
    static NSString * wsURL = @"http://ryh.zyskcn.com:8092/WebService/RYH_Interface.asmx";
//    NSString *soapMessage = [NSString stringWithFormat:
//                             @"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
//                            "<soap:Body>"
//                             "<ns2:PublicMethod xmlns:ns2=\"http://tempuri.org/\">"
//                             "<arg0>%@</arg0>"
//                             "</ns2:PublicMethod>"
//                             "</soap:Body>\n"
//                             "</soap:Envelope>",sendMessage];
//    
//    NSString *str = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
//                     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//                     "<soap:Body>"
//                     "<PublicMethodResponse xmlns=\"http://tempuri.org/\">"
//                     "<PublicMethodResult>string</PublicMethodResult>"
//                     "</PublicMethodResponse>"
//                     "</soap:Body>"
//                     "</soap:Envelope>"];
    
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                    "<soap:Body>"
                    "<PublicMethod xmlns=\"http://tempuri.org/\">"
                    "<json>%@</json>"
                    "</PublicMethod>"
                    "</soap:Body>\n"
                    "</soap:Envelope>",sendMessage];
    //_getMessage	__NSCFString *	@"{\"khlx\":\"0\",\"respCodeDesc\":\"操作成功\",\"userName\":\"zhangsan123\",\"respCode\":\"000\",\"signValue\":\"yBYXeGBYCG7GyG60QDUqeHb28ehCIVaKE63DiHe6RcHX11TullpHP/tBcJ6QckbIMYFNqYLi/MlbEs3+UTC10g==\",\"trueName\":\"张三\",\"messageType\":\"UserLogin\",\"userId\":\"E4B5CEF4-37BE-49BF-97AA-F87B4B278EE2\"}"	0x00007f9f9c106db0
    
    //NSLog(@"调用webserivce的字符串是:%@",soapMessage);
    //请求发送到的路径
    NSString *msgLength = [NSString stringWithFormat:@"%ld", [soapMessage length]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",wsURL]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.timeoutInterval = 30;
    //以下对请求信息添加属性前四句是必有的，
    [urlRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
     [urlRequest addValue:@"http://tempuri.org/PublicMethod" forHTTPHeaderField:@"SOAPAction"];
   // NSLog(@"SOAPAction is %@ ",@"http://tempuri.org/Logon");
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"%@",soapMessage);
    //soapMessage	__NSCFString *	@"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Header><authHeader><userName>username</userName><password>password</password></authHeader></soap:Header><soap:Body><ns2:PublicMethod xmlns:ns2=\"http://tempuri.org/\"><arg0>{\"version\":\"10\",\"projectFlag\":\"rl\", \"messageType\":\"UserLogin\",\"userName\":\"zhangsan123\",\"loginPassword\":\"e10adc3949ba59abbe56e057f20f883e\",\"phoneType\":\"002\",\"signValue\":\"Uz43Au4wZBfDxXr3RALT0yx3YGMzLi/xW4CWcx0yVfY=\"}</arg0></ns2:PublicMethod></soap:Body>\n</soap:Envelope>"	0x00007fbecbf35fc0
       //请求
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    //https必须添加的属性;
    [operation.securityPolicy setAllowInvalidCertificates:YES];
    //end
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSXMLParser * xmlparser = responseObject;
        [xmlparser setDelegate:self];
        [xmlparser setShouldProcessNamespaces:NO];
        [xmlparser setShouldReportNamespacePrefixes:NO];
        [xmlparser setShouldResolveExternalEntities:NO];
        [xmlparser parse];
        NSLog(@"%@",_getMessage);
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[_getMessage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"最终的字典是：%@",dic);
        messageDic(dic,NULL);
        
        //_getMessage	__NSCFString *	@"{\"respCodeDesc\":\"操作成功\",\"pageCount\":1,\"respCode\":\"000\",\"currentPage\":1,\"signValue\":\"bClml9X3WEUZZFxVoIwsXsGixpy/+JwheUO47RTDFY5OZz5G+/KrQclv+fIrYb2MdIBzjtCzZNjKPmo24Dn6IA==\",\"incomeType\":\"\",\"kyye\":\"496.00\",\"dataList\":[{\"rowNum\":1,\"czDay\":\"2016-04-18\",\"czTime\":\"\",\"ddh1\":\"10003\",\"ddh2\":\"10003\",\"czjg\":\"已支付\",\"beizhu\":\"\"}],\"totalCount\":1,\"messageType\":\"UserRechargeRecord\",\"userId\":\"193BF748-F71D-41B5-B327-777173D2A4EC\"}"	0x00007fc99bdc2eb0
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//在此做网络请求的判断以及返回情况；
        if([error code]&&[error code]== -1001){
            messageDic(nil,@"网络请求超时");
        }else{
            NSLog(@"%@",error);
            
            messageDic(nil,@"网络请求错误");
        }
    }];
    [operation start];
}


//xml 解析；
//开始解析前，在这里可以做一些初始化工作
// 假设已声明有实例变量 dataDict，parserObject
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    _getMessage = [[NSMutableString alloc] init];
}
//当解析器对象遇到xml的开始标记时，调用这个方法。
//获得结点头的值
//解析到一个开始tag，开始tag中可能会有properpies，例如<book catalog="Programming">
//所有的属性都存储在attributeDict中
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
}
//当解析器找到开始标记和结束标记之间的字符时，调用这个方法。
//解析器，从两个结点之间读取具体内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //记录所取得的文字列
    //NSLog(@"正在解析的数据：%@",string);
    NSString * str = [_getMessage stringByAppendingString:string];
    _getMessage = [NSMutableString stringWithString:str];
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    //NSLog(@"cData:%@",[NSString stringWithUTF8String:[CDATABlock bytes]]);
}
//当解析器对象遇到xml的结束标记时，调用这个方法。
//获取结点结尾的值，此处为一Tag的完成
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
}
//xml解析结束后的一些操作可在此
- (void)parserDidEndDocument:(NSXMLParser *)parser {
     //NSLog(@"最终的返回字符串是:%@",_getMessage);
//    _returnDic = [NSJSONSerialization JSONObjectWithData:[_getMessage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
//    NSLog(@"最终的字典是：%@",_returnDic);
}
//验证证书；
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
//{
//    NSLog(@"处理证书");
//    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
//}
//
////忽略ssl证书验证；
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    //NSLog(@"didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
        
    }
}


@end
