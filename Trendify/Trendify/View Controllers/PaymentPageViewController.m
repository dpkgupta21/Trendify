//
//  ViewController.m
//  PaymentGateway
//
//  Created by Suraj on 22/07/15.
//  Copyright (c) 2015 Suraj. All rights reserved.
//

#import "PaymentPageViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface PaymentPageViewController () <UIWebViewDelegate, UIAlertViewDelegate> {
    UIActivityIndicatorView *activityIndicatorView;
    NSString *strMIHPayID;
}

@property (nonatomic, weak) IBOutlet UIWebView *webviewPaymentPage;

@end

@implementation PaymentPageViewController



#define Merchant_Key @"KtqxYg"
#define Salt @"dPASVtX2"

//#define Base_URL @"https://test.payu.in"
#define Base_URL @"https://secure.payu.in"
#define Success_URL @"http://trendyfy.com/SuccessPage.aspx"
#define Failure_URL @"http://trendyfy.com/SuccessPage.aspx"
//#define Product_Info @"Denim Jeans"
//#define Paid_Amount @"1549.00"
//#define Payee_Name @"NK TRADE BUZZ PRIVATE LIMITED"

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self setTitle:@"Make A Payment"];
    [self initPayment];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self setTitle:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    activityIndicatorView.center = self.view.center;
    [activityIndicatorView setColor:[UIColor blackColor]];
    [self.view addSubview:activityIndicatorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initPayment {
    int i = arc4random() % 9999999999;
    NSString *strHash = [self createSHA512:[NSString stringWithFormat:@"%d%@",i,[NSDate date]]];// Generatehash512(rnd.ToString() + DateTime.Now);
    NSString *txnid1 = [strHash substringToIndex:20];
    strMIHPayID = txnid1;
    NSString *key = Merchant_Key;
    NSString *amount = self.amount;
    NSString *productInfo = self.productInfo;
    NSString *firstname = self.firstname;
    NSString *email = [NSString stringWithFormat:@"%@",self.email]; // Generated a fake mail id for testing
    NSString *phone = self.phone;
    NSString *serviceprovider = @"payu_paisa";
    
    NSString *hashValue = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|||||||||||%@",key,txnid1,amount,productInfo,firstname,email,Salt];
    
   // NSString *hashValue = [NSString stringWithFormat:@"%@|%@|%@|%@|||||||||||||%@",key,txnid1,amount,productInfo,Salt];
    
    NSString *hash = [self createSHA512:hashValue];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:txnid1,key,amount,productInfo,firstname,email,phone,Success_URL,Failure_URL,hash,serviceprovider
                                                                    , nil] forKeys:[NSArray arrayWithObjects:@"txnid",@"key",@"amount",@"productinfo",@"firstname",@"email",@"phone",@"surl",@"furl",@"hash",@"service_provider", nil]];
    __block NSString *post = @"";
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([post isEqualToString:@""]) {
            post = [NSString stringWithFormat:@"%@=%@",key,obj];
        } else {
            post = [NSString stringWithFormat:@"%@&%@=%@",post,key,obj];
        }
    }];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/_payment",Base_URL]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    
    [_webviewPaymentPage loadRequest:request];
    [activityIndicatorView startAnimating];
}

-(NSString *)createSHA512:(NSString *)string {
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* output = [NSMutableString  stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

#pragma UIWebView - Delegate Methods
-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"WebView started loading");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicatorView stopAnimating];
    
    if (webView.isLoading) {
        return;
    }
    
    NSURL *requestURL = [[_webviewPaymentPage request] URL];
    NSLog(@"WebView finished loading with requestURL: %@",requestURL);
    
    NSString *getStringFromUrl = [NSString stringWithFormat:@"%@",requestURL];
    
    if ([self containsString:getStringFromUrl :Success_URL]) {
        [self performSelector:@selector(delayedDidFinish:) withObject:getStringFromUrl afterDelay:0.0];
    } else if ([self containsString:getStringFromUrl :Failure_URL]) {
        // FAILURE ALERT
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry !!!" message:@"Your transaction failed. Please try again!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alert.tag = 1;
        [alert show];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [activityIndicatorView stopAnimating];
    NSURL *requestURL = [[_webviewPaymentPage request] URL];
    NSLog(@"WebView failed loading with requestURL: %@ with error: %@ & error code: %ld",requestURL, [error localizedDescription], (long)[error code]);
    if (error.code == -1009 || error.code == -1003 || error.code == -1001) { //error.code == -999
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops !!!" message:@"Please check your internet connection!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alert.tag = 1;
        [alert show];
    }
}

- (void)delayedDidFinish:(NSString *)getStringFromUrl {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *mutDictTransactionDetails = [[NSMutableDictionary alloc] init];
        [mutDictTransactionDetails setObject:strMIHPayID forKey:@"Transaction_ID"];
        [mutDictTransactionDetails setObject:@"Success" forKey:@"Transaction_Status"];
        [mutDictTransactionDetails setObject:self.firstname forKey:@"Payee_Name"];
        [mutDictTransactionDetails setObject:self.productInfo forKey:@"Product_Info"];
        [mutDictTransactionDetails setObject:self.amount forKey:@"Paid_Amount"];
        
        [self navigateToPaymentStatusScreen:mutDictTransactionDetails];
    });
}

#pragma UIAlertView - Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1 && buttonIndex == 0) {
        // Navigate to Payment Status Screen
        NSMutableDictionary *mutDictTransactionDetails = [[NSMutableDictionary alloc] init];
        [mutDictTransactionDetails setObject:self.firstname forKey:@"Payee_Name"];
        [mutDictTransactionDetails setObject:self.productInfo forKey:@"Product_Info"];
        [mutDictTransactionDetails setObject:self.amount forKey:@"Paid_Amount"];
        [mutDictTransactionDetails setObject:strMIHPayID forKey:@"Transaction_ID"];
        [mutDictTransactionDetails setObject:@"Failed" forKey:@"Transaction_Status"];
        [self navigateToPaymentStatusScreen:mutDictTransactionDetails];
    }
}

- (BOOL)containsString: (NSString *)string : (NSString*)substring {
    return [string rangeOfString:substring].location != NSNotFound;
}

- (void)navigateToPaymentStatusScreen: (NSMutableDictionary *)mutDictTransactionDetails {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",mutDictTransactionDetails);
        [self.navigationController popViewControllerAnimated:true];
//        PaymentStatusViewController *paymentStatusViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentStatusScreenID"];
//        paymentStatusViewController.mutDictTransactionDetails = mutDictTransactionDetails;
//        [self.navigationController pushViewController:paymentStatusViewController animated:YES];
    });
}

@end
