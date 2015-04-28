//
//  LogInViewController.m
//  MoveIt
//
//  Created by Emma Johansson on 24/04/15.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import "LogInViewController.h"
#import "CreateQuotationViewController.h"
#import "OrdersTableViewController.h"
#import "DataHandler.h"

@interface LogInViewController ()<DataHandlerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIButton *toggleButton;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic) BOOL isLogin;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLogin = YES;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.button setTitle: @"Logga in" forState: UIControlStateNormal];
    [self.toggleButton setTitle:@"Jag är ny användare" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleCreateUserAndLogin:(id)sender
{
    self.isLogin = !self.isLogin;
    if (self.isLogin){
        [self.button setTitle: @"Logga in" forState: UIControlStateNormal];
        [self.toggleButton setTitle:@"Jag är ny användare" forState:UIControlStateNormal];
    } else {
        [self.button setTitle: @"Skapa ny" forState: UIControlStateNormal];
        [self.toggleButton setTitle:@"Jag vill logga in" forState:UIControlStateNormal];
    }
    self.phoneNumberTextField.hidden = !self.phoneNumberTextField.hidden;
    self.nameTextField.hidden = !self.nameTextField.hidden;
}

- (IBAction)LoginButtonPressed:(id)sender
{
    [DataHandler sharedDatahandler].authenticationDelegate = self;
    if (self.isLogin) {
        [[DataHandler sharedDatahandler] logInUserWithEmail:self.emailTextField.text andPassword:self.passwordTextField.text];
    }else {
        [[DataHandler sharedDatahandler] createCustomerWithEmail:self.emailTextField.text password:self.passwordTextField.text name:self.nameTextField.text phoneNumber:self.phoneNumberTextField.text];
    }
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)notifyDelegateAuthenticationSuccessful:(BOOL)isAuthenticated
{
    NSLog(@"Auth %d", isAuthenticated);
    if (isAuthenticated) {
        [self.sourceViewController performSelector:@selector(authenticatedUserToSavedObjects)];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

@end
