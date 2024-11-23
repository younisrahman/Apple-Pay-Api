//
//  ApplePayApi.m
//  ApplePay
//
//  Created by Younis Rahman on 9/11/24.
//

#import <Foundation/Foundation.h>

#import "ApplePayApi.h"
#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>

@interface ApplePayApi ()
@property (nonatomic, copy) RCTPromiseResolveBlock paymentPromiseResolver;
@property (nonatomic, copy) RCTPromiseRejectBlock paymentPromiseRejecter;
@property (nonatomic) BOOL userClosedPaymentView;
@property (nonatomic, copy) NSString *authToken;
@property (nonatomic, copy) NSString *apiUrl;
@property (nonatomic, assign) BOOL shouldReturn;
@property (nonatomic, assign) BOOL isRejectApi;
@property (nonatomic, assign) BOOL isSimulator;
@property (nonatomic, copy) NSDictionary *extraData;
@end

@implementation ApplePayApi
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(getApplePayApi:(double)amount
                  charge:(double)charge
                  total:(double)total
                  countryCode:(NSString *)countryCode
                  currencyCode:(NSString *)currencyCode
                  label:(NSString *)label
                  title:(NSString *)title
                  cardTypes:(NSArray *)cardTypes
                  authToken:(NSString *)authToken
                  apiUrl:(NSString *)apiUrl
                  shouldReturnDetails:(BOOL)shouldReturnDetails
                  isReject:(BOOL)isReject
                  isSimulator:(BOOL)isSimulator
                  extraData:(NSDictionary *)extraData
                  resolve:(RCTPromiseResolveBlock)resolve 
                  reject:(RCTPromiseRejectBlock)reject) {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *infoDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];

    NSString *countryC = countryCode;
    NSString *currencyC = currencyCode;

    NSString *applePayMerchantIdentifier = infoDict[@"ApplePayMerchantIdentifier"];

    self.authToken= authToken;
    self.apiUrl = apiUrl;
    self.shouldReturn = shouldReturnDetails;
    self.isRejectApi = isReject;
    self.isSimulator = isSimulator;
    self.extraData = extraData;
  
    
    if (!applePayMerchantIdentifier || (applePayMerchantIdentifier && [applePayMerchantIdentifier isEqualToString:@""])) {
        reject(@"APPLE_PAY_MERCHANT_ID_NOT_SET", @"Apple Pay Merchand Identifier is not provided.", nil);
        return;
    }
  
    // Map card types to PKMerchantCapability enums
    PKMerchantCapability merchantCapabilities = 0;
    for (NSString *cardType in cardTypes) {
          if ([cardType isEqualToString:@"3DS"]) {
              merchantCapabilities |= PKMerchantCapability3DS;
          } else if ([cardType isEqualToString:@"Debit"]) {
              merchantCapabilities |= PKMerchantCapabilityDebit;
          } else if ([cardType isEqualToString:@"Credit"]) {
              merchantCapabilities |= PKMerchantCapabilityCredit;
          }
          // Add more conditions for other card types if needed
      }
    
    if ([PKPaymentAuthorizationViewController canMakePayments]) {
        PKPaymentRequest *paymentRequest = [[PKPaymentRequest alloc] init];
      
      
      PKPaymentSummaryItem *grossamount = [PKPaymentSummaryItem summaryItemWithLabel:label amount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat: @"%f", amount]]];
             
      PKPaymentSummaryItem *addedcharge = [PKPaymentSummaryItem summaryItemWithLabel:@"Apple Pay charges (2.55%)" amount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat: @"%f", charge]]];
      
        
      PKPaymentSummaryItem *totalItem = [PKPaymentSummaryItem summaryItemWithLabel:title amount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat: @"%f", total]]];
      
      
        paymentRequest.paymentSummaryItems=@[grossamount,addedcharge, totalItem];
        paymentRequest.merchantIdentifier = applePayMerchantIdentifier;
        paymentRequest.supportedNetworks = @[PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex];
     
        paymentRequest.merchantCapabilities = merchantCapabilities;

        paymentRequest.countryCode = countryC;
        paymentRequest.currencyCode = currencyC;

       
        PKPaymentAuthorizationViewController *paymentViewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];

        self.userClosedPaymentView = YES;
        
        paymentViewController.delegate = self; // Assuming 'self' is an instance of RTNApplePay

        
        if (paymentViewController) {

            self.paymentPromiseResolver = resolve; // Store the resolver for later use
            self.paymentPromiseRejecter = reject;
          // Present the Apple Pay view controller from your React Native UIViewController
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
                [rootViewController presentViewController:paymentViewController animated:YES completion:nil];
            });
        } else {
          reject(@"APPLE_PAY_NOT_AVAILABLE", @"Apple Pay is not available on this device.", nil);
        }
      } else {
        reject(@"APPLE_PAY_NOT_SUPPORTED", @"Apple Pay is not supported on this device.", nil);
      }
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment handler:(void (^)(PKPaymentAuthorizationResult * _Nonnull))completion {
    
    self.userClosedPaymentView = NO;
    NSError *error;

    if(self.isSimulator){

        NSDictionary *paymentData;

        if (self.extraData) {
                paymentData = @{
                    @"type": @"applepay",
                    @"token_data": @{
                        @"version": @"EC_v1",
                        @"data": @"Encrypted Data",
                        @"signature": @"Encrypted Signature",
                        @"header": @{
                            @"ephemeralPublicKey": @"Encrypted ephemeralPublicKey",
                            @"publicKeyHash": @"Encrypted publicKeyHash",
                            @"transactionId": @"Encrypted transactionId",
                        }
                    },
                    @"isRejectApi": @(self.isRejectApi),
                    @"txId": @"Encrypted txId",
                    @"data": self.extraData,
                };
            } else {
                paymentData = @{
                    @"type": @"applepay",
                    @"token_data": @{
                        @"version": @"EC_v1",
                        @"data": @"Encrypted Data",
                        @"signature": @"Encrypted Signature",
                        @"header": @{
                            @"ephemeralPublicKey": @"Encrypted ephemeralPublicKey",
                            @"publicKeyHash": @"Encrypted publicKeyHash",
                            @"transactionId": @"Encrypted transactionId",
                        }
                    },
                    @"isRejectApi": @(self.isRejectApi),
                    @"txId": @"Encrypted txId",
                };
            }

        if (self.shouldReturn) {
            if (self.paymentPromiseResolver) {
                PKPaymentAuthorizationResult *result = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusSuccess errors:nil];
                completion(result);
                
                self.paymentPromiseResolver(paymentData);
                self.paymentPromiseResolver = nil;
                self.paymentPromiseRejecter = nil;
            }
        } else {
             
            // Otherwise, make an API call to process the payment
            NSData *postData = [NSJSONSerialization dataWithJSONObject:paymentData options:0 error:&error];
            
            NSURL *url = [NSURL URLWithString:self.apiUrl];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            // Add Authorization header with Bearer token
            NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", self.authToken];
            [request setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error) {
                    // Handle API call failure
                    [self updateApplePayUIWithApiResponse:@"API call failed"];
                } else {
                    // Process API response
                    NSString *apiResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    BOOL declined = [self processApiResponse:apiResponse];

                    if (declined) {

                        [self updateApplePayUIWithApiResponse:@"Payment failed"];
                        PKPaymentAuthorizationResult *result = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusFailure errors:nil];
                        completion(result);
                        self.paymentPromiseResolver(apiResponse);
                    } else {
                        // Update UI for successful payment
                        [self updateApplePayUIWithApiResponse:@"Payment successful"];
                        PKPaymentAuthorizationResult *result = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusSuccess errors:nil];
                        completion(result);
                        self.paymentPromiseResolver(apiResponse);
                    }
                }
            }];
            [dataTask resume];
        }
    }

    else{
        NSData *encryptedPaymentData = payment.token.paymentData;
        NSString *decryptedPaymentData = [[NSString alloc] initWithData:encryptedPaymentData encoding:NSUTF8StringEncoding];
        
        NSData *decryptedData = [decryptedPaymentData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *decryptedDictionary = [NSJSONSerialization JSONObjectWithData:decryptedData options:kNilOptions error:&error];
    
        NSString *txId = payment.token.transactionIdentifier;

        if (!error) {
            NSDictionary *paymentData;
            
            if (self.extraData) {
                paymentData = @{
                    @"type": @"applepay",
                    @"token_data": @{
                        @"version": @"EC_v1",
                        @"data": decryptedDictionary[@"data"],
                        @"signature": decryptedDictionary[@"signature"],
                        @"header": @{
                            @"ephemeralPublicKey": decryptedDictionary[@"header"][@"ephemeralPublicKey"],
                            @"publicKeyHash": decryptedDictionary[@"header"][@"publicKeyHash"],
                            @"transactionId": decryptedDictionary[@"header"][@"transactionId"]
                        }
                    },
                    @"data": self.extraData,
                    @"isRejectApi": @(self.isRejectApi),
                    @"txId": txId
                };
            } else {
                paymentData = @{
                    @"type": @"applepay",
                    @"token_data": @{
                        @"version": @"EC_v1",
                        @"data": decryptedDictionary[@"data"],
                        @"signature": decryptedDictionary[@"signature"],
                        @"header": @{
                            @"ephemeralPublicKey": decryptedDictionary[@"header"][@"ephemeralPublicKey"],
                            @"publicKeyHash": decryptedDictionary[@"header"][@"publicKeyHash"],
                            @"transactionId": decryptedDictionary[@"header"][@"transactionId"]
                        }
                    },
                    @"isRejectApi": @(self.isRejectApi),
                    @"txId": txId
                };
            }
            
            // If user opted for returning payment details directly
            if (self.shouldReturn) {
                if (self.paymentPromiseResolver) {
                    PKPaymentAuthorizationResult *result = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusSuccess errors:nil];
                    completion(result);
                    
                    self.paymentPromiseResolver(paymentData);
                    self.paymentPromiseResolver = nil;
                    self.paymentPromiseRejecter = nil;
                }
            } else {
             
                // Otherwise, make an API call to process the payment
                NSData *postData = [NSJSONSerialization dataWithJSONObject:paymentData options:0 error:&error];
                
                NSURL *url = [NSURL URLWithString:self.apiUrl];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                [request setHTTPMethod:@"POST"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:postData];
                
                // Add Authorization header with Bearer token
                NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", self.authToken];
                [request setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
                
                NSURLSession *session = [NSURLSession sharedSession];
                NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (error) {
                        // Handle API call failure
                        [self updateApplePayUIWithApiResponse:@"API call failed"];
                    } else {
                        // Process API response
                        NSString *apiResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        BOOL declined = [self processApiResponse:apiResponse];

                        if (declined) {

                            [self updateApplePayUIWithApiResponse:@"Payment failed"];
                            PKPaymentAuthorizationResult *result = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusFailure errors:nil];
                            completion(result);
                            self.paymentPromiseResolver(apiResponse);
                        } else {
                            // Update UI for successful payment
                            [self updateApplePayUIWithApiResponse:@"Payment successful"];
                            PKPaymentAuthorizationResult *result = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusSuccess errors:nil];
                            completion(result);
                            self.paymentPromiseResolver(apiResponse);
                        }
                    }
                }];
                [dataTask resume];
        }
        } else {
            NSLog(@"Error creating JSON data: %@", error);
        }
    }
}


- (BOOL)processApiResponse:(NSString *)apiResponse {
    @try {
        NSData *data = [apiResponse dataUsingEncoding:NSUTF8StringEncoding];

        NSError *error;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (error) {
            return YES;
        }
        
        // Check if the 'status' field indicates a successful payment
        return responseDict[@"status"] == nil || [responseDict[@"status"] isEqualToString:@"DECLINED"];
    } @catch (NSException *exception) {
        // Handle the exception as needed (log, display error, etc.)
        return YES; // or return an appropriate value indicating an error occurred
    }
}


- (void)updateApplePayUIWithApiResponse:(NSString *)apiResponse {
    // Update your Apple Pay UI based on the API response
    // This might involve displaying a message indicating the payment status to the user
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Payment Status" message:apiResponse preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [rootViewController presentViewController:alertController animated:YES completion:nil];
}


- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    // This method is called when the payment sheet is dismissed
    if (self.userClosedPaymentView) {
        // The user pressed the cross button to close the view controller
        // Handle this case as needed
        self.paymentPromiseRejecter(@"APPLE_PAY_CANCELLED", @"Apple Pay was cancelled.", nil);
    }
    // Dismiss the Apple Pay view controller
    [controller dismissViewControllerAnimated:YES completion:nil];
}

RCT_EXPORT_METHOD(canMakePayments: (RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    BOOL result =[PKPaymentAuthorizationViewController canMakePayments];
    resolve(@(result)) ;
}

RCT_EXPORT_METHOD(canSetupCards: (RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    BOOL result =![PKPaymentAuthorizationViewController canMakePayments];
    resolve(@(result)) ;
}

RCT_EXPORT_METHOD(navigateToSetup:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    [self showSetupApplePayOptions];
}

- (void)showSetupApplePayOptions {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *appleWalletURL = [NSURL URLWithString:@"shoebox://applepay/setup"];
        
        if ([[UIApplication sharedApplication] canOpenURL:appleWalletURL]) {
            // Open the Apple Wallet app to the setup cards section
            [[UIApplication sharedApplication] openURL:appleWalletURL options:@{} completionHandler:nil];
        } else {
            // Handle the case where the Apple Wallet app cannot be opened (e.g., older devices)
            NSLog(@"Unable to open Apple Wallet for card setup.");
        }
    });
}


@end
