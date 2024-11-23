//
//  ApplePayApi.h
//  ApplePay
//
//  Created by Younis Rahman on 9/11/24.
//


#import <PassKit/PassKit.h>
#if __has_include("NativeApplePayApiSpec.h")
  #import "NativeApplePayApiSpec.h"
#endif
#import <React/RCTBridgeModule.h>

@interface ApplePayApi : NSObject <RCTBridgeModule, PKPaymentAuthorizationViewControllerDelegate>
@end
