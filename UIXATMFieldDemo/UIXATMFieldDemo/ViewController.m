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
    
    self.percentField.mode = UIXATMFieldModePercentage;
    
	// Do any additional setup after loading the view, typically from a nib.
    
//    self.field.clearButtonMode = UITextFieldViewModeAlways;
//    UILabel* l = [[UILabel alloc] initWithFrame:CGRectZero];
//    l.font = self.field.font;
//    l.text = @"boo";
//    [l sizeToFit];
//    
//    self.field.rightView = l;
//    self.field.rightViewMode = UITextFieldViewModeAlways;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
