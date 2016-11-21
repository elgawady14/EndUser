//
//  LoginView.m
//  DevBoy
//
//  Created by Ahmad Abdul-Gawad Mahmoud on 11/6/16.
//  Copyright © 2016 Ahmad Abdul-Gawad Mahmoud. All rights reserved.
//

#import "LoginView.h"
#import "Helper.h"
@import FirebaseAuth;
@import GoogleSignIn;

#define CLIENT_ID @"259213873134-n588m77bmt3kk2lj2r1occ65p5g3gqg5.apps.googleusercontent.com"

@interface LoginView () <GIDSignInDelegate, GIDSignInUIDelegate>
{
    UIButton *buttonLogInAnony;
    UIButton *buttonLogInGoogle;
    GIDSignIn *shard;
    Helper *helper;
}
@end

@implementation LoginView

- (void)viewDidLoad {
    
    [super viewDidLoad];

    shard = [GIDSignIn sharedInstance];

    [self preSettings];
}

// MARK: - VIEW ACTIONS

-(void) preSettings {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    buttonLogInAnony = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 80, 200, 160, 40)];
    [buttonLogInAnony setTitle:@"Anonymous" forState:UIControlStateNormal];
    buttonLogInAnony.layer.borderWidth = 0.5;
    buttonLogInAnony.layer.borderColor = [[UIColor whiteColor] CGColor];

    buttonLogInGoogle = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 80, 250, 160, 30)];
    [buttonLogInGoogle setTitle:@"Google+" forState:UIControlStateNormal];
    buttonLogInGoogle.layer.borderWidth = 0.5;
    buttonLogInGoogle.layer.borderColor = [[UIColor whiteColor] CGColor];

    
    [buttonLogInAnony addTarget:self action:@selector(actionLoginAnonymously:) forControlEvents:UIControlEventTouchUpInside];
    [buttonLogInGoogle addTarget:self action:@selector(actionLoginGoogle:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:buttonLogInAnony];
    [self.view addSubview:buttonLogInGoogle];
    
    shard.clientID = CLIENT_ID;
    
    
    shard.uiDelegate = self;
    
    shard.delegate = self;
    
    helper = [Helper getInstance];
}

// MARK: -  UI ACTIONS

- (void) actionLoginAnonymously: (id)sender {
    
    NSLog(@"login anonymously did taped");
    
    //anonymously log users in
    
    helper.loginView = self;
    
    [helper actionLoginAnonymously];
}

-(void) actionLoginGoogle: (id)sender {
    
    [[GIDSignIn sharedInstance] signIn];
}

- (void) signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    if (error != nil) {
        
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    NSLog(@"%@", user.authentication);
    
    helper.userPhoto = [user.profile imageURLWithDimension:0];
    
    //Google+ log users in
    
    helper.loginView = self;
    
    [helper loginWithGoogle: user.authentication];
}


@end
