//
//  ViewController.m
//  StripePaymentTest
//
//  Created by gauravds on 6/30/15.
//  Copyright (c) 2015 GDS. All rights reserved.
//

#import "ViewController.h"
#import <Stripe/Stripe.h>

@interface ViewController () <STPCheckoutViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [Stripe setDefaultPublishableKey:@"pk_test_OPLb6oNcvPk8arQ09NtBgZfY"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkoutForPayment:(id)sender {
    STPCheckoutOptions *options = [[STPCheckoutOptions alloc] initWithPublishableKey:[Stripe defaultPublishableKey]];
    options.purchaseDescription = @"Restaurant Payment";
    options.purchaseAmount = 45050; // this is in cents
    options.logoColor = [UIColor darkGrayColor]; //-- pass this color 0x3A94E5
    
    
    STPCheckoutViewController *checkoutViewController = [[STPCheckoutViewController alloc] initWithOptions:options];
    checkoutViewController.checkoutDelegate = self;
    [self presentViewController:checkoutViewController animated:YES completion:nil];
}

- (void)checkoutController:(stp_nonnull STPCheckoutViewController *)controller
            didCreateToken:(stp_nonnull STPToken *)token
                completion:(stp_nonnull STPTokenSubmissionHandler)completion {
    [self createBackendChargeWithToken:token completion:completion];
}

- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion {
//    NSDictionary *chargeParams = @{ @"stripeToken": token.tokenId, @"amount": @"1000" };
    
    // server posting about payment success.
    completion(STPBackendChargeResultSuccess, nil);
//    completion(STPBackendChargeResultFailure, error); 
    
}


- (void)checkoutController:(stp_nonnull STPCheckoutViewController *)controller
       didFinishWithStatus:(STPPaymentStatus)status
                     error:(stp_nullable NSError *)error {
    switch (status) {
        case STPPaymentStatusSuccess:
            NSLog(@"Payment success");
            break;
        case STPPaymentStatusError:
            NSLog(@"Payment error");
            break;
        case STPPaymentStatusUserCancelled:
            NSLog(@"Payment cancel");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
