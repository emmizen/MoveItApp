//
//  DataHandler.m
//  MoveIt
//
//  Created by Emmiz on 2015-04-20.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import "DataHandler.h"
#import "A0SimpleKeychain.h"

@interface DataHandler()

@property (nonatomic, readwrite, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation DataHandler

+(DataHandler*)sharedDatahandler
{
    static DataHandler *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataHandler alloc] init];
    });
    return sharedInstance;
}

-(void)test
{
    NSLog(@"app dir: %@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
 
    NSLog(@"**%@", [[A0SimpleKeychain keychain] stringForKey:@"password"]);
   // NSLog(@"%d", [self checkIfCustomerExists:@"testmail@me.se"]);
 // [self createCustomerWithEmail:@"testmail@me.se" password:@"pass" name:@"Kurre" phoneNumber:@"070553355"];
    //[self logOut];
    
//    Order *q = [self createOrderWithQuotation:[[[[self currentCustomer] quotations] allObjects] objectAtIndex:0]];
//    [[self currentCustomer] addOrdersObject:q];
//    [self saveManagedContext:self.context];

    //NSLog(@"%@", [(Quotation*)[[[[self currentCustomer] quotations] allObjects] objectAtIndex:0] customer]);
}

-(BOOL)isAuthenlicated
{
    if ([[A0SimpleKeychain keychain] stringForKey:@"password"]) {
        return true;
    } else {
        return false;
    }
}

-(Customer *)currentCustomer
{
    Customer *customer;
    NSString *email = [[A0SimpleKeychain keychain] stringForKey:@"email"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Customer"];
    request.predicate = [NSPredicate predicateWithFormat:@"eMail == %@" , email];
    NSArray *result = [self.context executeFetchRequest:request error:Nil];
    customer = [result firstObject];
    return customer;
}

#pragma mark - Create CoreData objects

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

-(BOOL)checkIfCustomerExists:(NSString*)mail
{
    Customer *customer;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Customer"];
    request.predicate = [NSPredicate predicateWithFormat:@"eMail == %@" , mail];
    NSArray *result = [self.context executeFetchRequest:request error:Nil];
    customer = [result firstObject];
    return customer ? YES : NO;
}

-(void)createCustomerWithEmail:(NSString *)email password:(NSString *)password name:(NSString *)name phoneNumber:(NSString *)phoneNumber
{
    [[A0SimpleKeychain keychain] setString:password forKey:@"password"];
    [[A0SimpleKeychain keychain] setString:email forKey:@"email"];
    
    if (![self checkIfCustomerExists:email]) {
        Customer *customer = [NSEntityDescription insertNewObjectForEntityForName:@"Customer" inManagedObjectContext:self.context];
        customer.eMail = email;
        customer.name = name;
        customer.phoneNumber = phoneNumber;
        [self saveManagedContext:self.context];
    }
    [self.authenticationDelegate notifyDelegateAuthenticationSuccessful:YES];
}

-(void)logInUserWithEmail:(NSString*)email andPassword:(NSString*)password
{
    if ([self checkIfCustomerExists:email]) {
        [[A0SimpleKeychain keychain] setString:password forKey:@"password"];
        [[A0SimpleKeychain keychain] setString:email forKey:@"email"];
        [self.authenticationDelegate notifyDelegateAuthenticationSuccessful:YES];
    } else {
        [self.authenticationDelegate notifyDelegateAuthenticationSuccessful:NO];
    }
}

-(void)logOut
{
    [[A0SimpleKeychain keychain] deleteEntryForKey:@"password"];
    [[A0SimpleKeychain keychain] deleteEntryForKey:@"email" ];
}
#pragma mark -


-(void)saveQuotation:(Quotation *)quotation
{
    Customer *customer = [self currentCustomer];
    [customer addQuotationsObject:quotation];
    quotation.customer = customer;
    [self saveManagedContext:self.context];
}

-(void)createOrderWithQuotation:(Quotation *)quotation
{
    Customer *customer = [self currentCustomer];
    Order *order = [NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:self.context];
    order.quotation = quotation;
    order.customer = customer;
    
    [customer addOrdersObject:order];
    [self saveManagedContext:self.context];
}

-(NSArray *)savedObjectsForCurrentCustomer
{
    NSMutableArray *objects = [NSMutableArray new];
    if ([[self currentCustomer] quotations]) {
        [objects addObjectsFromArray:[[[self currentCustomer] quotations] allObjects]];
    }
    if ([[self currentCustomer] orders]) {
        [objects addObjectsFromArray:[[[self currentCustomer] orders] allObjects]];
    }
    return [NSArray arrayWithArray:objects];
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

#pragma mark - Public properties
-(NSManagedObjectContext *)context
{
    if(!_context)
    {
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = [self persistentStoreCoordinator];
    }
    return _context;
}

#pragma mark - Private properties
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

#pragma mark - Private helpers
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
