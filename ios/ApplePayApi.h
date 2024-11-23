//
//  ApplePayApi.h
//  ApplePay
//
//  Created by Younis Rahman on 9/11/24.
//


#import <PassKit/PassKit.h>
#ifdef RCT_NEW_ARCH_ENABLED

@interface ApplePayApi : NSObject <NativeApplePayApiSpec, PKPaymentAuthorizationViewControllerDelegate>
#else
#import <React/RCTBridgeModule.h>

@interface ApplePayApi : NSObject <RCTBridgeModule, PKPaymentAuthorizationViewControllerDelegate>
#endif

@end
