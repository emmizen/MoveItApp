//
//  OrderViewController.m
//  MoveIt
//
//  Created by Emmiz on 2015-04-21.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import "OrderViewController.h"

@interface OrderViewController ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _priceLabel.text = [self.quotation.price stringValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
