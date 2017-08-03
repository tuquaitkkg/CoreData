//
//  ViewController.m
//  CoreData
//
//  Created by DucLT on 8/3/17.
//  Copyright © 2017 DucLT. All rights reserved.
//

#import "ViewController.h"
#import "NEDBAccessor.h"
#import "UserEntity.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveData:(id)sender {
    [self.tfName resignFirstResponder];
    [self.tfPhoneNumber resignFirstResponder];
    UserEntity *userEntity = [UserEntity fetchOrCreateByUserJID:self.tfName.text andPhoneNumber:self.tfPhoneNumber.text];
    userEntity.name = self.tfName.text;
    userEntity.phoneNumber = self.tfPhoneNumber.text;
    [userEntity saveEntity];
    NSLog(@"");
}


@end
