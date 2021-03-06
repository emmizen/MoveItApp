//
//  DataHandler.m
//  MoveIt
//
//  Created by Emmiz on 2015-04-20.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import "DataHandler.h"
#import "A0SimpleKeychain.h"
#import <Parse/Parse.h>

@interface DataHandler()

@property (nonatomic, readwrite, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation DataHandler
{
    int updatedUserValuesCount;
}

+(DataHandler*)sharedDatahandler
{
    static DataHandler *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataHandler alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        updatedUserValuesCount = 0;
    }
    return self;
}


#pragma mark - create user and Authenication methods

-(void)createUserWithEmail:(NSString *)email password:(NSString *)password name:(NSString *)name phoneNumber:(NSString *)phoneNumber
{
    if (![self checkIfUserExists:email] && password && email) {
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.context];
        user.eMail = email;
        user.name = name;
        user.phoneNumber = phoneNumber;
        
        PFUser *parseUser = [PFUser user];
        parseUser.username = email;
        parseUser.password = password;
        parseUser[@"phoneNumber"] = phoneNumber;
        parseUser[@"name"] = name;
        
        [parseUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                
                [[A0SimpleKeychain keychain] setString:password forKey:@"password"];
                [[A0SimpleKeychain keychain] setString:email forKey:@"email"];
                
                [self saveManagedContext:self.context];
                [self.authenticationDelegate notifyDelegateAuthenticationSuccessful:YES];
            } else{
                NSLog(@"Error sign in %@", error);
                [self.authenticationDelegate notifyDelegateAuthenticationSuccessful:NO];
            }
        }];
    } else {
        [self logInUserWithEmail:email andPassword:password];
    }
}

-(void)logInUserWithEmail:(NSString*)email andPassword:(NSString*)password
{
    if ([self checkIfUserExists:email] && password) {
        [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error) {
            if (user) {
                [[A0SimpleKeychain keychain] setString:password forKey:@"password"];
                [[A0SimpleKeychain keychain] setString:email forKey:@"email"];
                [self createUser:user];
                [self fetchUsersData:user];
                
                [self.authenticationDelegate notifyDelegateAuthenticationSuccessful:YES];
            } else {
                NSLog(@"Error: %@", error);
                [self.authenticationDelegate notifyDelegateAuthenticationSuccessful:NO];
            }
        }];
    } else {
        [self.authenticationDelegate notifyDelegateAuthenticationSuccessful:NO];
    }
}

-(void)logOut
{
    if ([self currentUser]) {
        [self.context deleteObject:[self currentUser]];
    }
    [[A0SimpleKeychain keychain] deleteEntryForKey:@"password"];
    [[A0SimpleKeychain keychain] deleteEntryForKey:@"email" ];
    [PFUser logOut];
}

#pragma mark - Create CoreData objects

-(Address *)createAddressWithStreet:(NSString *)street postalCode:(NSString *)postalCode city:(NSString *)city longitude:(float)longitude andLatitude:(float)latitude
{
    Address *address = [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:self.context];
    address.streetAddress = street;
    address.postalCode = postalCode;
    address.city = city;
    address.longitude = [NSNumber numberWithFloat:longitude];
    address.latitude = [NSNumber numberWithFloat:latitude];

    return address;
}

-(Quotation *)createQuotationWithPrice:(int)price livingArea:(int)livingArea storageArea:(int)storageArea fromAddress:(Address *)from toAddress:(Address *)to distance:(double)distance piano:(BOOL)inclPiano
{
    Quotation *quotation = [NSEntityDescription insertNewObjectForEntityForName:@"Quotation" inManagedObjectContext:self.context];
    quotation.price = [NSNumber numberWithInt:price];
    quotation.livingArea = [NSNumber numberWithInt:livingArea];
    quotation.storageArea = [NSNumber numberWithInt:storageArea];
    quotation.fromAddress = from;
    quotation.toAddress = to;
    quotation.distance = [NSNumber numberWithDouble:distance];
    quotation.piano = [NSNumber numberWithBool:inclPiano];
    
    return quotation;
}

#pragma mark - Create and Save

-(void)saveQuotation:(Quotation *)quotation
{
    User *user = [self currentUser];
    [user addQuotationsObject:quotation];
    quotation.user = user;
    [self saveManagedContext:self.context];
    
    PFObject *object = [self quotationAsParseObject:quotation];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Saved Quotation to parse");
        } else {
            NSLog(@"Error saving Quotation to parse: %@", error);
        }
    }];
}

-(void)createOrderWithQuotation:(Quotation *)quotation
{
    User *user = [self currentUser];
    Order *order = [NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:self.context];
    order.quotation = quotation;
    order.user = user;
    
    [user addOrdersObject:order];
    [self saveManagedContext:self.context];
    
    
    PFObject *object = [PFObject objectWithClassName:@"Order"];
    object[@"quotation"] = [self quotationAsParseObject:quotation];
    object[@"user"] = [PFUser currentUser];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Saved Order to parse");
        } else {
            NSLog(@"Error saving to parse: %@", error);
        }
    }];
}

#pragma mark - Saved

-(NSArray *)savedObjectsForCurrentUser
{
    NSMutableArray *objects = [NSMutableArray new];
    if ([[self currentUser] quotations]) {
        [objects addObjectsFromArray:[[[self currentUser] quotations] allObjects]];
    }
    if ([[self currentUser] orders]) {
        [objects addObjectsFromArray:[[[self currentUser] orders] allObjects]];
    }
    return [NSArray arrayWithArray:objects];
}

#pragma mark - Public Help methods

-(BOOL)isAuthenlicated
{
    if ([[A0SimpleKeychain keychain] stringForKey:@"password"]) {
        return true;
    } else {
        return false;
    }
}

-(User *)currentUser
{
    User *user;
    NSString *email = [[A0SimpleKeychain keychain] stringForKey:@"email"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"eMail == %@" , email];
    NSArray *result = [self.context executeFetchRequest:request error:Nil];
    user = [result firstObject];
    return user;
}

#pragma mark - Private Help methods

-(Quotation*)quotationFromParseObject:(PFObject*)object
{
    Quotation *quotation = [NSEntityDescription insertNewObjectForEntityForName:@"Quotation" inManagedObjectContext:self.context];
    quotation.price = [object objectForKey:@"price"];
    quotation.livingArea = [object objectForKey:@"livingArea"];
    quotation.storageArea = [object objectForKey:@"storageArea"];
    quotation.fromAddress = [self addressFromParseObject:[object objectForKey:@"fromAddress"]];
    quotation.toAddress = [self addressFromParseObject:[object objectForKey:@"toAddress"]];
    quotation.distance = [object objectForKey:@"distance"];
    quotation.piano = [object objectForKey:@"piano"];

    return quotation;
}

-(Order*)orderFromParseObject:(PFObject*)object
{
    Order *order = [NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:self.context];
    Quotation *quotation = [self quotationFromParseObject:[object objectForKey:@"quotation"]];
    order.quotation = quotation;

    return order;
}

-(Address*)addressFromParseObject:(PFObject*)object
{
    Address *address = [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:self.context];
    address.streetAddress = [object objectForKey:@"streetAddress"];
    address.postalCode = [object objectForKey:@"postalCode"];
    address.city = [object objectForKey:@"city"];
    address.longitude = [object objectForKey:@"longitude"];
    address.latitude = [object objectForKey:@"latitude"];
    return address;
}

-(NSArray*)pfQuotatonsArrayToCoreQuotationsArray:(NSArray*)quotations
{
    NSMutableArray *result = [NSMutableArray new];
    for (PFObject *q in quotations) {
        [result addObject:[self quotationFromParseObject:q]];
    }
    return result;
}

-(NSArray*)pfOrdersArrayToCoreOrdersArray:(NSArray*)orders
{
    NSMutableArray *array = [NSMutableArray new];
    for (PFObject *order in orders) {
        [array addObject:[self orderFromParseObject:order]];
    }
    return array;
}

-(void)haveUpdate
{
    updatedUserValuesCount++;
    if (updatedUserValuesCount == 2) {
        updatedUserValuesCount = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:self];
    }
}

-(void)updateCustomerWithQuotations:(NSArray*)quotations
{
    User *current = [self currentUser];
    [current addQuotations:[NSSet setWithArray:[self pfQuotatonsArrayToCoreQuotationsArray:quotations]]];
    NSError *error;
    if ([self.context save:&error]) {
        [self haveUpdate];
    } else {
        NSLog(@"Could not save context. Error: %@", [error localizedDescription]);
    }
}

-(void)updateCustomerWithOrders:(NSArray*)orders
{
    User *current = [self currentUser];
    NSArray *a = [self pfOrdersArrayToCoreOrdersArray:orders];
    [current addOrders:[NSSet setWithArray:a]];
    NSError *error;
    if ([self.context save:&error]) {
        [self haveUpdate];
    } else {
        NSLog(@"Could not save context. Error: %@", [error localizedDescription]);
    }
}

-(void)createUser:(PFUser*)user
{
    User *coreUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.context];
    coreUser.eMail = user.username;
    coreUser.name = [user objectForKey:@"name"];
    coreUser.phoneNumber = [user objectForKey:@"phoneNumber"];
    [self saveManagedContext:self.context];
}

-(void)fetchUsersData:(PFUser*)user
{
    PFQuery *ordersQuery = [PFQuery queryWithClassName:@"Order"];
    [ordersQuery includeKey:@"quotation"];
    [ordersQuery includeKey:@"quotation.fromAddress"];
    [ordersQuery includeKey:@"quotation.toAddress"];
    [ordersQuery whereKey:@"user" equalTo:user];
    
    [ordersQuery findObjectsInBackgroundWithBlock:^(NSArray *orders, NSError *error) {
        if (!error) {

            NSMutableArray *array = [NSMutableArray new];
            for (PFObject *o in orders) {
                PFObject *obj = [o objectForKey:@"quotation"];
                [array addObject:obj.objectId];
            }
    
            PFQuery *quotationQuery = [PFQuery queryWithClassName:@"Quotation"];
            [quotationQuery includeKey:@"fromAddress"];
            [quotationQuery includeKey:@"toAddress"];
            [quotationQuery whereKey:@"objectId" notContainedIn:array];
            [quotationQuery whereKey:@"user" equalTo:user];
            
            [quotationQuery findObjectsInBackgroundWithBlock:^(NSArray *quotations, NSError *error) {
                if (!error) {
                    [self updateCustomerWithQuotations:quotations];
                } else {
                    NSLog(@"Error%@", error);
                }
            }];
            [self updateCustomerWithOrders:orders];
        } else {
            NSLog(@"Error%@", error);
        }
    }];
}

-(PFObject*)addressAsParseObject:(Address*)address
{
    PFObject *object = [PFObject objectWithClassName:@"Address"];
    object[@"streetAddress"] = address.streetAddress;
    object[@"postalCode"] = address.postalCode;
    object[@"city"] = address.city;
    object[@"longitude"] = address.longitude;
    object[@"latitude"] = address.latitude;
    return object;
}

-(PFObject*)quotationAsParseObject:(Quotation*)quotation
{
    PFObject *object = [PFObject objectWithClassName:@"Quotation"];
    object[@"price"] = quotation.price;
    object[@"livingArea"] = quotation.livingArea;
    object[@"storageArea"] = quotation.storageArea;
    object[@"distance"] = quotation.distance;
    object[@"piano"] = quotation.piano;
    object[@"fromAddress"] = [self addressAsParseObject:quotation.fromAddress];
    object[@"toAddress"] = [self addressAsParseObject:quotation.toAddress];
    object[@"user"] = [PFUser currentUser];
    return object;
}

-(BOOL)checkIfUserExists:(NSString*)mail
{
    User *user;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"eMail == %@" , mail];
    NSArray *result = [self.context executeFetchRequest:request error:Nil];
    user = [result firstObject];
    if (!user) {
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
        
        [query whereKey:@"username" equalTo:mail];
        NSArray *arr = [query findObjects];
        PFObject *parseUser = [arr firstObject];
        return parseUser ? YES : NO;
    }
    return user ? YES : NO;
}

-(void) saveManagedContext:(NSManagedObjectContext*) context
{
    NSError *error;
    if ([context save:&error]) {
        NSLog(@"Context saved!");
    }
    else {
        NSLog(@"Could not save context. Error: %@", [error localizedDescription]);
    }
}

#pragma mark - Private Core Data properties

-(NSManagedObjectContext *)context
{
    if(!_context)
    {
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = [self persistentStoreCoordinator];
    }
    return _context;
}

-(NSManagedObjectModel *)model
{
    if(!_model)
    {
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[self modelPath]];
    }
    return _model;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(!_persistentStoreCoordinator)
    {
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        NSError *error;
        
        if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error])
        {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"Could not create persistent store."
                                         userInfo:error.userInfo];
        }
        _persistentStoreCoordinator = psc;
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Private Core data helpers
-(NSString*) modelName
{
    return @"MoveIt";
}

-(NSURL*) modelPath
{
    return [[NSBundle mainBundle] URLForResource:[self modelName] withExtension:@"momd"];
}

-(NSString*) storeFileName
{
    return [[self modelName]stringByAppendingPathExtension:@"sqlite"];
}

-(NSURL*) storeURL
{
    return[[self documentDirectory] URLByAppendingPathComponent:[self storeFileName]];
}

-(NSURL*) documentDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentDirectoryURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return documentDirectoryURL;
}

@end
