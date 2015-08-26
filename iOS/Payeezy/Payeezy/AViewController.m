//
//  ViewController.m
//  Payeezy
//
//  Created by gauravds on 8/19/15.
//  Copyright (c) 2015 GDS. All rights reserved.
//

#import "AViewController.h"
#import "PayeezySDK.h"
#import "CreditCardInfo.h"

#define KApiKey @"HuHiBP6bKdkSl49VG51W3tMzueKh6ssx"
#define KApiSecret @"08c8a95873b406774c3c77ed174e5507c38d52ed46a6484b6c211ed2168d0592"
#define KToken @"fdoa-a480ce8951daa73262734cf102641994c1e55e7cdf4c02b6"
#define KURL @"https://api-cert.payeezy.com/v1/transactions"

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CreditCardInfo *creditCard = [CreditCardInfo new];
    creditCard.cardNo = @"";
    creditCard.cardExpMonth = 11;
    creditCard.cardExpYear = 2015;
    creditCard.cardCVV = 123;
    
    NSDictionary* credit_card = @{
                                  @"type":@"visa", @"cardholder_name":@"Jacob Test", @"card_number":@"4012000033330026", @"exp_date":@"0416",
                                  @"cvv":@"123"
                                  // Transaction info
                                  };
    NSDictionary* transaction_info = @{ @"currencyCode":@"USD",
                                        @"amount":@"10", @"merchantRefForProcessing":@"abc1412096293369"
                                        };
    PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:KToken url:KURL];
    [myClient submitAuthorizeTransactionWithCreditCardDetails:credit_card[@"type"]
                                               cardHolderName:credit_card[@"cardholder_name"]
                                                   cardNumber:credit_card[@"card_number"]
                                      cardExpirymMonthAndYear:credit_card[@"exp_date"]
                                                      cardCVV:credit_card[@"cvv"]
                                                 currencyCode:transaction_info[@"currencyCode"]
                                                  totalAmount:transaction_info[@"amount"]
                                     merchantRefForProcessing:transaction_info[@"merchantRefForProcessing"]
                                                   completion:^(NSDictionary *dict, NSError *error) {
                                                       NSString *authStatusMessage = nil;
                                                       // handle error and response
                                                       if (error == nil) {
                                                           authStatusMessage = [NSString stringWithFormat:@"Transaction Successful\rType:%@\rTransaction ID:%@\rTransaction Tag:%@\rCorrelation Id:%@\rBank Response Code:%@",[dict objectForKey:@"transaction_type"], [dict objectForKey:@"transaction_id"], [dict objectForKey:@"transaction_tag"], [dict objectForKey:@"correlation_id"], [dict objectForKey:@"bank_resp_code"]];
                                                           
                                                       } else {
                                                           authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                                                       }
                                                   }];
                                             
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
