//
//  AuthViewController.m
//  AppApp
//
//  Created by Zach Holmquist on 8/10/12.
//  Copyright (c) 2012 Sneakyness. All rights reserved.
//

#import "AuthViewController.h"

@implementation AuthViewController
@synthesize authWebView;

- (id)init
{
    self = [super initWithNibName:@"AuthViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //TODO: MOVE OUT OF HERE
    NSString *clientID = @"RG2Brqye96rLZQtjwRenVZsBrMtpYXYP";
    NSString *redirectURI = @"appapp://callmemaybe";
    
    NSString *scopes = @"stream write_post";
    NSString *authURLstring = [NSString stringWithFormat:@"https://alpha.app.net/oauth/authenticate?client_id=%@&response_type=token&redirect_uri=%@&scope=%@",clientID, redirectURI, scopes];
    NSURL *authURL = [NSURL URLWithString:[authURLstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:authURL];
    
    [authWebView loadRequest:requestObj];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSArray *components = [[request URL].absoluteString  componentsSeparatedByString:@"#"];
    
    if([components count]) {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        for (NSString *component in components) {
            
            if([[component componentsSeparatedByString:@"="] count] > 1) {
            [parameters setObject:[[component componentsSeparatedByString:@"="] objectAtIndex:1] forKey:[[component componentsSeparatedByString:@"="] objectAtIndex:0]];
            }
        }
        
        if([parameters objectForKey:@"access_token"]) {
            
            //TODO: move me.
            NSString *token = [parameters objectForKey:@"access_token"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:token forKey:@"access_token"];
            [defaults synchronize];
            
            
            [self dismissAuthenticationViewController:nil];
        }
    }

    return YES;
}

-(IBAction)dismissAuthenticationViewController:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
