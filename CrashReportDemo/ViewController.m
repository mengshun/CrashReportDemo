//
//  ViewController.m
//  CrashReportDemo
//
//  Created by mengshun on 2022/6/13.
//

#import "ViewController.h"
#import "CrashReportDemo-Swift.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *showText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _showText.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"crash_info"]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"crash_info"];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

- (IBAction)ocAction:(id)sender {
    NSMutableDictionary *dict = @{};
    [dict setObject:@"1" forKey:@"2"];
}
- (IBAction)bridgeAction:(id)sender {
    [SwiftObj action];
}

- (IBAction)swiftAction:(id)sender {
    [self presentViewController:NewVCViewController.new animated:YES completion:nil];
}

@end
