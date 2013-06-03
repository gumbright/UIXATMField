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

@property (nonatomic, weak) IBOutlet UIXCurrencyATMField* currencyField;
@property (nonatomic, weak) IBOutlet UIXPercentageATMField* percentField;
@property (nonatomic, weak) IBOutlet UIXPercentageATMField* percentField2;
@property (nonatomic, weak) IBOutlet UIXCurrencyATMField* accessoryField;
@property (nonatomic, weak) IBOutlet UIXATMField* customField;
@property (nonatomic, weak) IBOutlet UIXUnfixedDecimalATMField* unfixedField;
@property (nonatomic, weak) IBOutlet UIView* dynamicContainer;
@property (nonatomic, strong) UIXATMField* dynamicField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //currency
//    self.currencyField.mode = UIXATMFieldModeCurrentCurrency;
//    float f = 12.34;
//    self.currencyField.value = 12.34;
    self.currencyField.atmFieldDelegate = self;
    
    //percentage
//    self.percentField.mode = UIXATMFieldModePercentage;
    self.percentField.decimalValue = [NSDecimalNumber decimalNumberWithString:@"87"];
    
    //percentage
//    self.percentField2.mode = UIXATMFieldModePercentage;
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
    
    self.accessoryField.showCancel = YES;
    self.accessoryField.showDone = YES;
    self.accessoryField.atmFieldDelegate = self;
    
    UILabel* l = [[UILabel alloc] initWithFrame:CGRectZero];
    l.text = self.customField.formatter.percentSymbol;
    l.font = self.unfixedField.font;
    l.textColor = self.unfixedField.textColor;
    [l sizeToFit];
    self.unfixedField.rightView = l;
    self.unfixedField.rightViewMode = UITextFieldViewModeAlways;
    self.unfixedField.value = 54.3;
    
    self.dynamicField = [[UIXATMField alloc] initWithFrame:self.dynamicContainer.bounds];
    fmt = [[NSNumberFormatter alloc] init];
    fmt.positiveFormat = @"$#,##0";
    self.dynamicField.formatter = fmt;
    self.dynamicField.decimalValue = [NSDecimalNumber zero];
    [self.dynamicContainer addSubview:self.dynamicField];
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

- (void) UIXATMFieldDonePressed:(UIXATMField*) atmField
{
    [atmField resignFirstResponder];
}

- (void) UIXATMFieldCancelPressed:(UIXATMField*) atmField
{
    [atmField resignFirstResponder];
}
@end
