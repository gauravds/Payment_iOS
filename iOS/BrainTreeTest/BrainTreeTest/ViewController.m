//
//  ViewController.m
//  BrainTreeTest
//
//  Created by gauravds on 7/1/15.
//  Copyright (c) 2015 GDS. All rights reserved.
//

#import "ViewController.h"
#import <Braintree/Braintree.h>

@interface ViewController () <BTDropInViewControllerDelegate> {
    __weak IBOutlet UIButton *btnPayment;
    __weak NSString *cid;
}
@property (nonatomic, strong) Braintree *braintree;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *clientToken = @"eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiI2Yjk3OGI2ZDUyYTE0MzlmZDU5NjNhZGRkMTdiNWNlN2I0ZjU4YjkxZDZiY2Y0ODYwNWEwNGM4YWM5OGNiMDRifGNyZWF0ZWRfYXQ9MjAxNS0wNy0wMVQxMzoxOTo1MC45NTMzNTEyOTgrMDAwMFx1MDAyNm1lcmNoYW50X2lkPWRjcHNweTJicndkanIzcW5cdTAwMjZwdWJsaWNfa2V5PTl3d3J6cWszdnIzdDRuYzgiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzL2RjcHNweTJicndkanIzcW4vY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIn0sInRocmVlRFNlY3VyZUVuYWJsZWQiOnRydWUsInRocmVlRFNlY3VyZSI6eyJsb29rdXBVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi90aHJlZV9kX3NlY3VyZS9sb29rdXAifSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwibWVyY2hhbnRBY2NvdW50SWQiOiJzdGNoMm5mZGZ3c3p5dHc1IiwiY3VycmVuY3lJc29Db2RlIjoiVVNEIn0sImNvaW5iYXNlRW5hYmxlZCI6dHJ1ZSwiY29pbmJhc2UiOnsiY2xpZW50SWQiOiIxMWQyNzIyOWJhNThiNTZkN2UzYzAxYTA1MjdmNGQ1YjQ0NmQ0ZjY4NDgxN2NiNjIzZDI1NWI1NzNhZGRjNTliIiwibWVyY2hhbnRBY2NvdW50IjoiY29pbmJhc2UtZGV2ZWxvcG1lbnQtbWVyY2hhbnRAZ2V0YnJhaW50cmVlLmNvbSIsInNjb3BlcyI6ImF1dGhvcml6YXRpb25zOmJyYWludHJlZSB1c2VyIiwicmVkaXJlY3RVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbS9jb2luYmFzZS9vYXV0aC9yZWRpcmVjdC1sYW5kaW5nLmh0bWwiLCJlbnZpcm9ubWVudCI6Im1vY2sifSwibWVyY2hhbnRJZCI6ImRjcHNweTJicndkanIzcW4iLCJ2ZW5tbyI6Im9mZmxpbmUiLCJhcHBsZVBheSI6eyJzdGF0dXMiOiJtb2NrIiwiY291bnRyeUNvZGUiOiJVUyIsImN1cnJlbmN5Q29kZSI6IlVTRCIsIm1lcmNoYW50SWRlbnRpZmllciI6Im1lcmNoYW50LmNvbS5icmFpbnRyZWVwYXltZW50cy5zYW5kYm94LkJyYWludHJlZS1EZW1vIiwic3VwcG9ydGVkTmV0d29ya3MiOlsidmlzYSIsIm1hc3RlcmNhcmQiLCJhbWV4Il19fQ==";
//    self.braintree = [Braintree braintreeWithClientToken:clientToken];
    
    // TODO: Switch this URL to your own authenticated API
    NSURL *clientTokenURL = [NSURL URLWithString:@"http://localhost:9999/client_token?cid=12345"];
    NSMutableURLRequest *clientTokenRequest = [NSMutableURLRequest requestWithURL:clientTokenURL];
    [clientTokenRequest setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    btnPayment.hidden = YES;
    [NSURLConnection
     sendAsynchronousRequest:clientTokenRequest
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         // TODO: Handle errors in [(NSHTTPURLResponse *)response statusCode] and connectionError
         NSString *clientToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         
         // Initialize `Braintree` once per checkout session
         self.braintree = [Braintree braintreeWithClientToken:clientToken];
         btnPayment.hidden = NO;
         // As an example, you may wish to present our Drop-In UI at this point.
         // Continue to the next section to learn more...
     }];
}

- (IBAction)paymentTapped {
    
    // If you haven't already, create and retain a `Braintree` instance with the client token.
    // Typically, you only need to do this once per session.
    //self.braintree = [Braintree braintreeWithClientToken:aClientToken];
    
    // Create a BTDropInViewController
    BTDropInViewController *dropInViewController = [self.braintree dropInViewControllerWithDelegate:self];
    // This is where you might want to customize your Drop in. (See below.)
    
    // The way you present your BTDropInViewController instance is up to you.
    // In this example, we wrap it in a new, modally presented navigation controller:
    dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                          target:self
                                                                                                          action:@selector(userDidCancelPayment)];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)userDidCancelPayment {
    NSLog(@"Payment cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod {
    NSLog(@"Payment successful inside delegate");
    [self postNonceToServer:paymentMethod.nonce]; // Send payment method nonce to your server
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    NSLog(@"Payment cancel inside delegate");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postNonceToServer:(NSString *)paymentMethodNonce {
    // Update URL with your server
    NSLog(@"This is for sending to server (nonce) : %@", paymentMethodNonce);
    
    NSURL *paymentURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:9999/payment_methods?payment_method_nonce=%@&amount=10.00", paymentMethodNonce]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:paymentURL];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               // TODO: Handle success and failure
                               if (connectionError) {
                                   NSLog(@"Payment fails");
                               } else {
                                   NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"Payment succssful: %@", response);
                                   
                                   [[[UIAlertView alloc] initWithTitle:@"Braintree payment" message:@"Successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                               }
                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
