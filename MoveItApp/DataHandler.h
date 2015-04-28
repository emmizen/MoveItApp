//
//  DataHandler.h
//  MoveIt
//
//  Created by Emmiz on 2015-04-20.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Address.h"
#import "User.h"
#import "Quotation.h"
#import "Order.h"
#import "A0SimpleKeychain.h"

@protocol DataHandlerDelegate <NSObject>

@optional

-(void)notifyDelegateAuthenticationSuccessful:(BOOL)isAuthenticated;

@end

@interface DataHandler : NSObject

@property (nonatomic) id<DataHandlerDelegate> authenticationDelegate;

+(DataHandler*)sharedDatahandler;
-(BOOL)isAuthenlicated;
-(User*)currentUser;

-(Address*)createAddressWithStreet:(NSString*)street postalCode:(NSString*)postalCode city:(NSString*)city longitude:(float)longitude andLatitude:(float)latitude;

-(Quotation*)createQuotationWithPrice:(int)price livingArea:(int)livingArea storageArea:(int)storageArea fromAddress:(Address*)from toAddress:(Address*)to distance:(double)distance piano:(BOOL)inclPiano;

-(void)createOrderWithQuotation:(Quotation*)quotation;
-(void)saveQuotation:(Quotation*)quotation;
-(NSArray*)savedObjectsForCurrentUser;

-(void)createUserWithEmail:(NSString *)email password:(NSString *)password name:(NSString *)name phoneNumber:(NSString *)phoneNumber;
-(void)logInUserWithEmail:(NSString*)email andPassword:(NSString*)password;
-(void)logOut;

-(void)test;

@end
