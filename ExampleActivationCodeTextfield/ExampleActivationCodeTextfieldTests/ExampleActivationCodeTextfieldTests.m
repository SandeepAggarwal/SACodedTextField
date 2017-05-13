//
//  ExampleActivationCodeTextfieldTests.m
//  ExampleActivationCodeTextfieldTests
//
//  Created by Sandeep Aggarwal on 08/04/17.
//
//

#import <XCTest/XCTest.h>
#import <SACodedTextField/ActivationCodeTextField.h>

@interface ExampleActivationCodeTextfieldTests : XCTestCase<ActivationCodeTextFieldDelegate>
{
    XCTestExpectation *delegateMethodExpectation;
}

@property (nonatomic, strong) ActivationCodeTextField *textField;

@end

@interface ActivationCodeTextField ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation ExampleActivationCodeTextfieldTests

- (void)setUp
{
    [super setUp];
   
    self.textField = [ActivationCodeTextField new];
}

- (void)tearDown
{
    self.textField = nil;
    [super tearDown];
}

- (void)testDefaultCodeLength
{
    XCTAssertEqual(self.textField.maxCodeLength, 6);
}

- (void)testMinWidthGreaterThanZeroForDefaults
{
    XCTAssertGreaterThan(self.textField.minWidthTextField, 0);
}

- (void)testMinWidthGreaterThanZeroForDifferentCodeLength
{
    self.textField.maxCodeLength = 7;
    XCTAssertGreaterThan(self.textField.minWidthTextField, 0);
}

- (void)testMinWidthGreaterThanZeroForCustomPlaceholder
{
    self.textField.customPlaceholder = @"__";
    XCTAssertGreaterThan(self.textField.minWidthTextField, 0);
}

- (void)testMinWidthGreaterThanZeroForCustomPlaceholderAndForDifferentCodeLength
{
    self.textField.maxCodeLength = 7;
    self.textField.customPlaceholder = @"__";
    XCTAssertGreaterThan(self.textField.minWidthTextField, 0);
}

- (void)testDelegateFiring
{
    delegateMethodExpectation = [self expectationWithDescription:@"Delegate method"];
    self.textField.maxCodeLength = 6;
    self.textField.activationCodeTFDelegate = self;
    [self.textField setText:@"123456"];
    
    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error)
    {
        if (error)
        {
            XCTFail("Expected delegate to be called");
        }
    }];
}

- (void)testUpdationOfTextField
{
    [self.textField setText:@"123"];
    [self.textField setText:@"456"];
    XCTAssertTrue([self.textField.text isEqualToString:@"456"]);
}

- (void)testFont
{
    UIFont* font = [UIFont systemFontOfSize:12];
    [self.textField setFont:font];
    XCTAssertTrue([self.textField.label.font isEqual:font]);
}

- (void)testWidthForCodeLengthZero
{
    self.textField.maxCodeLength = 0;
    XCTAssertEqual(self.textField.minWidthTextField, 0);
}


#pragma mark - <ActivationCodeTextFieldDelegate>

- (void)fillingCompleteForTextField:(ActivationCodeTextField *)textField
{
    [delegateMethodExpectation fulfill];
}

@end
