//
//  ViewController.m
//  UIXATMFieldDemo
//
//  Created by Guy Umbright on 5/23/13.
//  Copyright (c) 2013 Salesforce.com. All rights reserved.
//

#import "ViewController.h"
#import "UIXATMField.h"

@interface ViewController () <UIXATMFieldDelegate>

@property (nonatomic, weak) IBOutlet UIXATMField* currencyField;
@property (nonatomic, weak) IBOutlet UIXATMField* percentField;
@property (nonatomic, weak) IBOutlet UIXATMField* percentField2;
@property (nonatomic, weak) IBOutlet UIXATMField* customField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //currency
    self.currencyField.mode = UIXATMFieldModeCurrentCurrency;
//    float f = 12.34;
//    self.currencyField.value = f;
    self.currencyField.atmFieldDelegate = self;
    
    //percentage
    self.percentField.mode = UIXATMFieldModePercentage;
    self.percentField.decimalValue = [NSDecimalNumber decimalNumberWithString:@"87"];
    
    //percentage
    self.percentField2.mode = UIXATMFieldModePercentage;
    self.percentField2.formatter.minimumFractionDigits = 3;
    self.percentField2.formatter.maximumFractionDigits = 3;
    self.percentField2.decimalValue = [NSDecimalNumber decimalNumberWithString:@"23"];
    
    //custom
//    self.customField.numDecimalDigits = 3;
    self.customField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gauge"]];
    self.customField.leftViewMode = UITextFieldViewModeAlways;
    NSNumberFormatter* fmt = [[NSNumberFormatter alloc] init];
    fmt.positiveFormat = @"$#,##0";
    self.customField.formatter = fmt;
    self.customField.decimalValue = [NSDecimalNumber zero];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) UIXATMFieldChanged:(UIXATMField *)atmField
{
    NSLog(@"changed");
}
@end
