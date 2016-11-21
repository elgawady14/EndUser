//
//  Helper.m
//  DevBoy
//
//  Created by Ahmad Abdul-Gawad Mahmoud on 11/6/16.
//  Copyright © 2016 Ahmad Abdul-Gawad Mahmoud. All rights reserved.
//

#import "Helper.h"
#import <UIKit/UIKit.h>


@interface Helper ()

@end

@implementation Helper
@synthesize loginView, demoView, userPhoto;

static Helper *helper = nil;

+(Helper*)getInstance{
    
    @synchronized(self)
    {
        if(helper==nil)
        {
            helper = [Helper new];
        }
    }
    return helper;
}

-(void) actionLoginAnonymously {
    
    [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser * _Nullable anonymousUser, NSError * _Nullable error) {
        
        if (error == nil) {
            
            NSLog(@"UserId: %@", anonymousUser.uid);
            
            [self switchToDemoView];
            
        } else {
            
            NSLog(@"%@", error.localizedDescription);
            return;
        }
    }];
}

-(void) loginWithGoogle :(GIDAuthentication*)authentication {
    
    FIRAuthCredential *credential = [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken accessToken:authentication.accessToken];
    
    [[FIRAuth auth] signInWithCredential:(FIRAuthCredential *)credential completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        
        if (error != nil) {
            
            NSLog(@"%@", error.localizedDescription);
            return;
        } else {
            
            NSLog(@"%@", user.email);
            
            NSLog(@"%@", user.displayName);
            
            [self switchToDemoView];
        }
    }];
}


- (void) switchToDemoView {
    
    // switch view by presenting DemoView modally.
    
    [self.loginView presentViewController:[DemoView new] animated:true completion:nil];
}

@end
