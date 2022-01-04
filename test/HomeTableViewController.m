//
//  HomeTableViewController.m
//  test
//
//  Created by 袁明洋 on 2021/12/21.
//  Copyright © 2021 A589. All rights reserved.
//

#import "HomeTableViewController.h"
#import "UIWebViewController.h"
#import "WKWebViewController.h"

@interface HomeTableViewController ()

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UIWebViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        WKWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WKWebViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
