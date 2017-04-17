//
//  HelloWorldLayer.h
//  buytest
//
//  Created by 华明 李 on 11-10-29.
//  Copyright Himi 2011年. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import <UIKit/UIKit.h>

#import <StoreKit/StoreKit.h>
enum{
    IAP0p99=10,
    IAP1p99,
    IAP4p99,
    IAP9p99,
    IAP24p99,
}buyCoinsTag;

@interface HelloWorldLayer : CCLayer<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    int buyType;
}

+(CCScene *) scene;
- (void) requestProUpgradeProductData;
-(void)RequestProductData;
-(bool)CanMakePay;
-(void)buy:(int)type;
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction;
-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
-(void)provideContent:(NSString *)product;
-(void)recordTransaction:(NSString *)product;
@end