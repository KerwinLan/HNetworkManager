//
//  ViewController.m
//  example
//
//  Created by 兰志 on 2019/3/19.
//  Copyright © 2019 Kerwin. All rights reserved.
//

#import "ViewController.h"
#import "DemoNetworkManager.h"

@interface ViewController ()<HNetworkCacheManager>

@property (nonatomic, strong) DemoNetworkManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)action1:(id)sender {
    self.manager.allowMultiRequest = NO;
    [self.manager fetch];
}
- (IBAction)action2:(id)sender {
    self.manager.allowMultiRequest = YES;
    [self.manager fetch];
}
- (IBAction)action3:(id)sender {
    self.manager.allowMultiRequest = NO;
    self.manager.cachePolicy = HNetworkCachePolicyLocalAndRemote;
    self.manager.cacheManager = self;
    [self.manager fetch];
}

- (NSData *)cacheManagerFetchInstanceForIdentifier:(NSString *)identifier {
    NSLog(@"fetch data from cache");
    return nil;
}

- (void)cacheManagerSaveInstance:(NSData *)instance forIdentifier:(NSString *)identifier {
    NSLog(@"save data");
}

- (DemoNetworkManager *)manager {
    if (!_manager) {
        _manager = [[DemoNetworkManager alloc] init];
        [_manager setCallResult:^(id  _Nullable model, id  _Nullable parameter, NSError * _Nullable error) {
            
        }];
    }
    return _manager;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
