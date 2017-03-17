//
//  ViewController.m
//  ExampleActivationCodeTextfield
//
//  Created by Sandeep Aggarwal on 17/03/17.
//
//

#import "ViewController.h"
#import "ActivationCodeTextField.h"

@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) ActivationCodeTextField* textField;;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger numDigits = 6;
    
    UILabel* label = [UILabel new];
    [label setText:[NSString stringWithFormat:@"Please enter the %ld digit code below:",numDigits]];
    [label setTextAlignment:(NSTextAlignmentCenter)];
    self.label = label;
    [self.view addSubview:label];
    
    ActivationCodeTextField* textField = [ActivationCodeTextField new];
    textField.maxCodeLength = numDigits;
    textField.customPlaceholder = @"😀";
    textField.delegate = self;
    [textField setTextColor:[UIColor blackColor]];
    self.textField = textField;
    [self.view addSubview:textField];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.label sizeToFit];
    CGRect frame = self.label.frame;
    frame.origin.y = 100.0f;
    frame.origin.x = (self.view.bounds.size.width - self.label.bounds.size.width)/2.0f;
    self.label.frame = frame;
    
    frame = self.textField.frame;
    frame.size.width = [self.textField minWidthTextField];
    frame.size.height = MAX(self.textField.bounds.size.height, 44.0f);
    frame.origin.x = (self.view.bounds.size.width - frame.size.width)/2.0f;
    frame.origin.y = self.label.frame.origin.y + self.label.bounds.size.height + 40.0f;
    self.textField.frame = frame;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.textField becomeFirstResponder];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* acceptableCharacters = @"0123456789";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:acceptableCharacters] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
}

@end
