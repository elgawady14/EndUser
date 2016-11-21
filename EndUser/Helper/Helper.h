//
//  Helper.h
//  DevBoy
//
//  Created by Ahmad Abdul-Gawad Mahmoud on 11/6/16.
//  Copyright © 2016 Ahmad Abdul-Gawad Mahmoud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DemoView.h"
#import "LoginView.h"

@import FirebaseAuth;
@import GoogleSignIn;

@interface Helper : NSObject

@property LoginView *loginView;
@property DemoView *demoView;
@property NSURL *userPhoto;


+(Helper*)getInstance;

-(void) actionLoginAnonymously;
-(void) loginWithGoogle :(GIDAuthentication*)authentication;


@end
