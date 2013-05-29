//
//  ViewController.m
//  UIXATMFieldDemo
//
//  Created by Guy Umbright on 5/23/13.
//  Copyright (c) 2013 Salesforce.com. All rights reserved.
//

#import "ViewController.h"
#import "UIXATMField.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIXATMField* currencyField;
@property (nonatomic, weak) IBOutlet UIXATMField* percentField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currencyField.mode = UIXATMFieldModeCurrentCurrency;
    float f = 12.34;
    self.currencyField.value = f;
    
    self.percentField.mode = UIXATMFieldModePercentage;
    self.percentField.decimalValue = [NSDecimalNumber decimalNumberWithString:@"87"];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
