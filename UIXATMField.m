//
//  UIXATMField.m
//  UIXATMFieldDemo
//
//  Created by Guy Umbright on 5/23/13.
//  Copyright (c) 2013 Salesforce.com. All rights reserved.
//

#import "UIXATMField.h"

static UIToolbar* sInputAccessoryView;

@interface UIXATMField () <UITextFieldDelegate>
@property (nonatomic, strong) NSString* actualStringValue;
@property (nonatomic, assign) NSUInteger fractionDigits;
@property (nonatomic, strong) NSCharacterSet* validationCharacterSet;
//@property (nonatomic, assign) NSUInteger numDecimalDigits;
@end

@implementation UIXATMField

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
+ (void) initialize
{
    sInputAccessoryView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    sInputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
    [sInputAccessoryView sizeToFit];
    
    //to use
    //    self.edit.inputAccessoryView = sNumberPadToolbar;

}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) configureInputAccessoryView
{
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:3];
    
    if (self.showCancel)
    {
        [items addObject:[[UIBarButtonItem alloc]initWithTitle:@"Cancel"
                                                         style:UIBarButtonItemStyleDone
                                                        target:self
                                                        action:@selector(accessoryCancelPressed:)]];
    }
    
    [items addObject:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                  target:nil
                                                                  action:nil]];
    
    if (self.showDone)
    {
        [items addObject:[[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                         style:UIBarButtonItemStyleDone
                                                        target:self
                                                        action:@selector(accessoryDonePressed:)]];
    }
    sInputAccessoryView.items = items;
    
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) commonInit
{
    self.textAlignment = NSTextAlignmentRight;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
    
    self.delegate = self;
    self.actualStringValue = @"";
    
    self.fractionDigits = 0;
    
    self.validationCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    self.value = 0;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
//- (id)initWithFrame:(CGRect)frame andMode:(UIXATMFieldMode)mode
//{
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        _mode = mode;
//        switch (_mode)
//        {
//            case UIXATMFieldModeCurrentCurrency:
//            {
//                [self setCurrencyMode];
//            }
//                break;
//                
//            case UIXATMFieldModePercentage:
//            {
//                [self setPercentMode];
//            }
//                break;
//                
//            default:
//                break;
//        }
//
//        [self commonInit];
//    }
//    return self;
//}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) awakeFromNib
{
    [self commonInit];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
//- (void) setCurrencyMode
//{
//    self.keyboardType = UIKeyboardTypeNumberPad;
//    self.rightView = nil;
//    
//    self.formatter = [[NSNumberFormatter alloc] init];
//    self.formatter.numberStyle = NSNumberFormatterCurrencyStyle;
////    _numDecimalDigits = [self.formatter maximumFractionDigits];
//}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
//- (void) setPercentMode
//{
//    self.keyboardType = UIKeyboardTypeNumberPad;
//    
//    UILabel* l = [[UILabel alloc] initWithFrame:CGRectZero];
//    l.text = @"%";
//    l.font = self.font;
//    l.textColor = self.textColor;
//    l.backgroundColor = [UIColor clearColor];  //black box if set to bg of self
//    [l sizeToFit];
//    self.rightView = l;
//    self.rightViewMode = UITextFieldViewModeAlways;
//    
//    self.formatter = [[NSNumberFormatter alloc] init];
//    self.formatter.numberStyle = NSNumberFormatterDecimalStyle;
//    self.formatter.maximumFractionDigits = self.fractionDigits;
//}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
//- (void) setMode:(UIXATMFieldMode)mode
//{
//    _mode = mode;
//    
//    switch (_mode)
//    {
//        case UIXATMFieldModeCurrentCurrency:
//        {
//            [self setCurrencyMode];
//        }
//            break;
//            
//        case UIXATMFieldModePercentage:
//        {
//            [self setPercentMode];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    [self updateCurrentValue];
//    [self updateDisplay];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void) updateDisplay
{
//    if (self.text.length == 0)
//    {
//        self.text = [self.formatter stringFromNumber:[NSNumber numberWithFloat:0.0]];
//    }
//    else
//    {
        self.text = [self.formatter stringFromNumber:self.decimalValue];
//    }
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void) contentChanged:(NSNotification*) notification
{
    [self updateCurrentValue];
    [self updateDisplay];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) updateCurrentValue
{
    NSDecimalNumber* num;
    if (self.actualStringValue.length == 0)
    {
        num = [NSDecimalNumber zero];
    }
    else
    {
        num = [NSDecimalNumber decimalNumberWithString:self.actualStringValue];
    }
    
    NSDecimalNumber* scale = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:10] decimalValue]];
    scale = [scale decimalNumberByRaisingToPower:self.formatter.minimumFractionDigits];
    _decimalValue = [num decimalNumberByDividingBy:scale];
    
//    if (self.mode == UIXATMFieldModePercentage)
//    {
//        [_decimalValue decimalNumberByMultiplyingByPowerOf10:-2];
//    }
    
//    [self updateFloatValue];
    
    NSLog(@"float=%f dec=%@",self.value, self.decimalValue);
    
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
//- (void) updateFloatValue
//{
//    double d = [self.decimalValue doubleValue];
//    _value = (float) d;
//}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) actualFromDisplay
{
    if ([self.decimalValue floatValue] == 0.0)
    {
        self.actualStringValue = @"";
    }
    else
    {
        NSCharacterSet* set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSArray* arr = [self.text componentsSeparatedByCharactersInSet:set];
        NSString* newActual = [arr componentsJoinedByString:@""];
        self.actualStringValue  = newActual;
    }
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) actualFromDecimal
{
    NSString* s = [self.decimalValue stringValue];
    
    NSCharacterSet* set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* arr = [s componentsSeparatedByCharactersInSet:set];
    NSString* newActual = [arr componentsJoinedByString:@""];
    self.actualStringValue  = newActual;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.showCancel || self.showDone)
    {
        [self configureInputAccessoryView];
        self.inputAccessoryView = sInputAccessoryView;
    }
    
    return YES;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //first lets make sure we have no inappropriate characters
    
    if ([string rangeOfCharacterFromSet:self.validationCharacterSet].location != NSNotFound)
    {
        //invalid char - dont do nothing
    NSLog(@"Oh no you dont -- %@",string);
        return NO;
    }
    
    NSRange modRange;
    BOOL update = YES;
    
    if (range.length == 1)
    {
        if (self.actualStringValue.length == 0)
        {
            update = NO;
        }
        else
        {
            modRange = NSMakeRange(self.actualStringValue.length-1, range.length);
        }
        
    }
    else
    {
        //adjust by the diff between field & actual
        NSInteger diff = self.text.length - self.actualStringValue.length;
        modRange = NSMakeRange(range.location - diff, range.length);
    }
    
    if (update)
    {
        NSLog(@"range=%@ repl=<%@> -- modRange=%@ currentText=%@ actual=%@",NSStringFromRange(range),string,NSStringFromRange(modRange),self.text,self.actualStringValue);
        self.actualStringValue = [self.actualStringValue stringByReplacingCharactersInRange:modRange withString:string];
        [self updateCurrentValue];
        [self updateDisplay];
        
        if (self.atmFieldDelegate && [self.atmFieldDelegate respondsToSelector:@selector(UIXATMFieldChanged:)])
        {
            [self.atmFieldDelegate  UIXATMFieldChanged:self];
        }
    }
    return NO;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) setValue:(float)value
{
    self.decimalValue = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:value] decimalValue]];
    
//    [self updateDisplay];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (float) getValue
{
    double d = [self.decimalValue doubleValue];
    return (float) d;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) setDecimalValue:(NSDecimalNumber *)decimalValue
{
    _decimalValue = [decimalValue copy];
    
    [self updateDisplay];
//    [self actualFromDecimal];
    [self actualFromDisplay];
//    [self updateFloatValue];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) setCustomFormatter:(NSNumberFormatter *)formatter
{
    self.formatter = formatter;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (IBAction) accessoryDonePressed:(id)sender
{
    if (self.atmFieldDelegate && [self.atmFieldDelegate respondsToSelector:@selector(UIXATMFieldDonePressed:)])
    {
        [self.atmFieldDelegate UIXATMFieldDonePressed:self];
    }
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (IBAction) accessoryCancelPressed:(id)sender
{
    if (self.atmFieldDelegate && [self.atmFieldDelegate respondsToSelector:@selector(UIXATMFieldCancelPressed:)])
    {
        [self.atmFieldDelegate UIXATMFieldCancelPressed:self];
    }
}

@end

#pragma mark UIXCurrencyATMField
@implementation UIXCurrencyATMField

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) commonInit
{
    [super commonInit];
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.rightView = nil;
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.value = 0;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) awakeFromNib
{
    [self commonInit];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) updateCurrentValue
{
    [super updateCurrentValue];
    [self.decimalValue decimalNumberByMultiplyingByPowerOf10:-2];
}

@end

#pragma mark UIXPercentageATMField
@implementation UIXPercentageATMField

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) commonInit
{
    [super commonInit];
    self.keyboardType = UIKeyboardTypeNumberPad;
    
    UILabel* l = [[UILabel alloc] initWithFrame:CGRectZero];
    l.text = @"%";
    l.font = self.font;
    l.textColor = self.textColor;
    l.backgroundColor = [UIColor clearColor];  //black box if set to bg of self
    [l sizeToFit];
    self.rightView = l;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.formatter.maximumFractionDigits = self.fractionDigits;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) awakeFromNib
{
    [self commonInit];
}

@end

