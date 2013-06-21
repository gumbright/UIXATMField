//
//  UIXATMField.m
//  UIXATMFieldDemo
//
//  Created by Guy Umbright on 5/23/13.
//  Copyright (c) 2013 Salesforce.com. All rights reserved.
//

#import "UIXATMField.h"

static UIToolbar* sInputAccessoryView;

@class UIXATMFieldInternalDelegate;

@interface UIXATMField () <UITextFieldDelegate>
@property (nonatomic, strong) NSString* actualStringValue;
@property (nonatomic, assign) NSUInteger fractionDigits;
@property (nonatomic, strong) NSCharacterSet* validationCharacterSet;
@property (nonatomic, strong) UIXATMFieldInternalDelegate* internalDelegate;

//@property (nonatomic, assign) NSUInteger numDecimalDigits;
- (void) configureInputAccessoryView;

@end

/////////////////////////////////////////////////////
//
// I had to take this route to get it to play nice with 5.1.  5.1
// did NOT like the UIXATMField being its own delegate AT ALL.
// Would cause it to crash in the depths of Quartz
//
/////////////////////////////////////////////////////
@interface UIXATMFieldInternalDelegate : NSObject <UITextFieldDelegate>
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
    self.borderStyle = UITextBorderStyleRoundedRect;
    
    self.internalDelegate = [[UIXATMFieldInternalDelegate alloc] init];
    self.delegate = self.internalDelegate;
    
    self.actualStringValue = @"";
    
    self.fractionDigits = 0;
    
    self.validationCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    self.value = 0;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (id) initWithFrame:(CGRect)frame
{
    if (self =  [super initWithFrame:frame])
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
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void) updateDisplay
{
    self.text = [self.formatter stringFromNumber:_decimalValue];
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
    _decimalValue = [self decimalNumberFromString:self.actualStringValue];
    
    NSLog(@"float=%f dec=%@",self.value, self.decimalValue);
    
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (NSDecimalNumber*) decimalNumberFromString:(NSString*) string
{
    NSDecimalNumber* num;

    if (string.length == 0)
    {
        num = [NSDecimalNumber zero];
    }
    else
    {
        num = [NSDecimalNumber decimalNumberWithString:string];
    }
    
    NSDecimalNumber* scale = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:10] decimalValue]];
    scale = [scale decimalNumberByRaisingToPower:self.formatter.minimumFractionDigits];
    num = [num decimalNumberByDividingBy:scale];
    return num;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) actualFromDisplay
{
    if ([_decimalValue floatValue] == 0.0)
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
    
    //    NSCharacterSet* set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];  //??shoudl this be validation set?
    NSCharacterSet* set = [self.validationCharacterSet invertedSet];  //??shoudl this be validation set?
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
- (BOOL) shouldChangeValueTo:(NSDecimalNumber*) newValue
{
    return YES;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (BOOL) validateInput:(NSString*) string
{
    BOOL result = ([string rangeOfCharacterFromSet:self.validationCharacterSet].location == NSNotFound);
    return result;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //first lets make sure we have no inappropriate characters
    
    if (![self validateInput:string])
    {
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
        
        NSString* proposedActualStringValue = [self.actualStringValue stringByReplacingCharactersInRange:modRange
                                                                                              withString:string];
        NSDecimalNumber* proposedValue = [self decimalNumberFromString:proposedActualStringValue];
        
        if ([self shouldChangeValueTo:proposedValue])
        {
            BOOL valueValid = YES;
            if (self.atmFieldDelegate && [self.atmFieldDelegate respondsToSelector:@selector(UIXATMField:shouldChangeValueTo:)])
            {
                valueValid = [self.atmFieldDelegate UIXATMField:self
                                            shouldChangeValueTo:proposedValue];
            }
            
            if (valueValid)
            {
                self.actualStringValue = proposedActualStringValue;
                [self updateCurrentValue];
                [self updateDisplay];
                
                if (self.atmFieldDelegate && [self.atmFieldDelegate respondsToSelector:@selector(UIXATMFieldChanged:)])
                {
                    [self.atmFieldDelegate  UIXATMFieldChanged:self];
                }
            }
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
    [self actualFromDisplay];
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
//- (void) updateCurrentValue
//{
//    [super updateCurrentValue];
//    [self.decimalValue decimalNumberByMultiplyingByPowerOf10:-2];
//}


@end

#pragma mark UIXPercentageATMField
@implementation UIXPercentageATMField

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) commonInit
{
    [super commonInit];
//    self.keyboardType = UIKeyboardTypeNumberPad;
    
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

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (BOOL) shouldChangeValueTo:(NSDecimalNumber*) newValue
{
    if ([newValue floatValue] < 0 || [newValue floatValue] > 100)
    {
        return NO;
    }
    return YES;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
//- (NSDecimalNumber*) decimalNumberFromString:(NSString*) string
//{
//    return [[super decimalNumberFromString:string] decimalNumberByMultiplyingByPowerOf10:-2];
//}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (NSDecimalNumber*) decimalValue
{
    return [[super decimalValue] decimalNumberByMultiplyingByPowerOf10:-2];
}
@end

#pragma mark UIXUnfixedDecimalATMField
@implementation UIXUnfixedDecimalATMField

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) commonInit
{
    [super commonInit];
    self.keyboardType = UIKeyboardTypeDecimalPad;
    
    NSMutableCharacterSet* set = [NSCharacterSet decimalDigitCharacterSet];
    [set addCharactersInString:@"."];
    self.validationCharacterSet = [set invertedSet];
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = NSNumberFormatterDecimalStyle;
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

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void) setDecimalValue:(NSDecimalNumber *)decimalValue
{
    self.actualStringValue = decimalValue.stringValue;
    [super setDecimalValue:decimalValue];
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void) updateDisplay
{
    self.text = self.actualStringValue;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (BOOL) validateInput:(NSString*) string
{
    BOOL valid = [super validateInput:string];
    if (valid)
    {
        if ([string rangeOfString:self.formatter.decimalSeparator].location != NSNotFound)
        {
            if ([self.actualStringValue rangeOfString:self.formatter.decimalSeparator].location != NSNotFound)
            {
                valid = NO;
            }
        }
    }
    
    return valid;
}
@end

///////////////
///////////////
///////////////


@implementation UIXATMFieldInternalDelegate

- (id) init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contentChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:self];
        
    }
    
    return self;
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIXATMField* atmField = (UIXATMField*) textField;
    
    if (atmField.showCancel || atmField.showDone)
    {
        [atmField configureInputAccessoryView];
        atmField.inputAccessoryView = sInputAccessoryView;
    }
    
    return YES;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //first lets make sure we have no inappropriate characters
    UIXATMField* atmField = (UIXATMField*) textField;
    
    if (![atmField validateInput:string])
    {
        return NO;
    }
    
    NSRange modRange;
    BOOL update = YES;
    
    if (range.length == 1)
    {
        if (atmField.actualStringValue.length == 0)
        {
            update = NO;
        }
        else
        {
            modRange = NSMakeRange(atmField.actualStringValue.length-1, range.length);
        }
        
    }
    else
    {
        //adjust by the diff between field & actual
        NSInteger diff = atmField.text.length - atmField.actualStringValue.length;
        modRange = NSMakeRange(range.location - diff, range.length);
    }
    
    if (update)
    {
        NSLog(@"range=%@ repl=<%@> -- modRange=%@ currentText=%@ actual=%@",NSStringFromRange(range),string,NSStringFromRange(modRange),atmField.text,atmField.actualStringValue);
        
        NSString* proposedActualStringValue = [atmField.actualStringValue stringByReplacingCharactersInRange:modRange
                                                                                              withString:string];
        NSDecimalNumber* proposedValue = [atmField decimalNumberFromString:proposedActualStringValue];
        
        if ([atmField shouldChangeValueTo:proposedValue])
        {
            BOOL valueValid = YES;
            if (atmField.atmFieldDelegate && [atmField.atmFieldDelegate respondsToSelector:@selector(UIXATMField:shouldChangeValueTo:)])
            {
                valueValid = [atmField.atmFieldDelegate UIXATMField:atmField
                                            shouldChangeValueTo:proposedValue];
            }
            
            if (valueValid)
            {
                atmField.actualStringValue = proposedActualStringValue;
                [atmField updateCurrentValue];
                [atmField updateDisplay];
                
                if (atmField.atmFieldDelegate && [atmField.atmFieldDelegate respondsToSelector:@selector(UIXATMFieldChanged:)])
                {
                    [atmField.atmFieldDelegate  UIXATMFieldChanged:atmField];
                }
            }
        }
    }
    return NO;
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void) contentChanged:(NSNotification*) notification
{
    [notification.object updateCurrentValue];
    [notification.object updateDisplay];
}

@end

