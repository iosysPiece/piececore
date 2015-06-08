#import "AppDelegate.h"
#import "FlyerViewController.h"
#import "InfoListViewController.h"
#import "CategoryViewController.h"
#import "TabbarViewController.h"
#import "SearchViewController.h"
#import "CsvConnecter.h"
#import "DBManager.h"
#import "BuyListDao.h"


@implementation AppDelegate


-(void)setConfig{
    [PieceCoreConfig setShopId:@"OtokomaeKetai"];
    [PieceCoreConfig setAppKey:@"ba2b6159bfac1f3f22486b2c32a0b29d"];
    [PieceCoreConfig setAppId:@""];
    DBManager *dbManager = [[DBManager alloc]init];
    [PieceCoreConfig setSplashInterval:[NSNumber numberWithFloat:2.0f]];
    [dbManager createDB];
}

-(void)setThemeColor{
    ThemeData *theme = [[ThemeData alloc]initThemeDefault];
    theme.navigationBarColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
    //theme.navigationTitleColor = [UIColor whiteColor];
    //theme.navigationTitleShadowColor = [UIColor whiteColor];
    theme.tabBarBackColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
    //    theme.tabBarSelectColor = [UIColor whiteColor];
    //    theme.tabTitleNomalColor = [UIColor lightGrayColor];
    //    theme.tabTitleSelectColor = [UIColor whiteColor];
    self.theme = theme;
}

//UITabBarController初期化
- (NSMutableArray *)getTabbarDataList
{
    NSMutableArray *tabbarDataList = [NSMutableArray array];
    [tabbarDataList addObject:[[TabbarData alloc]initWithViewController:
                               [[FlyerViewController alloc] initWithNibName:@"FlyerViewController" bundle:nil]
                                                                imgName:@"tab_icon_flyer.png"
                                                          selectImgName:@"tab_icon_flyer.png"
                                                               tabTitle:@"Flyer"
                                                                  title:@"FLYER"]];
    [tabbarDataList addObject:[[TabbarData alloc]initWithViewController:
                               [[InfoListViewController alloc] initWithNibName:@"InfoListViewController" bundle:nil]
                                                                imgName:@"tab_icon_news.png"
                                                          selectImgName:@"tab_icon_news.png"
                                                               tabTitle:@"Info"
                                                                  title:@"INFO"]];
    [tabbarDataList addObject:[[TabbarData alloc]initWithViewController:
                               [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil url:@"http://store.shopping.yahoo.co.jp/outlet-mobile/"]
                                                                imgName:@"tab_icon_shopping.png"
                                                          selectImgName:@"tab_icon_shopping.png"
                                                               tabTitle:@"Shopping"
                                                                  title:@"SHOPPING"]];
    [tabbarDataList addObject:[[TabbarData alloc]initWithViewController:
                               [[CouponViewController alloc] initWithNibName:@"CouponViewController" bundle:nil isDispGetBtn:NO]
                                                                imgName:@"tab_icon_coupon.png"
                                                          selectImgName:@"tab_icon_coupon.png"
                                                               tabTitle:@"Coupon"
                                                                  title:@"COUPON"]];
    [tabbarDataList addObject:[[TabbarData alloc]initWithViewController:
                               [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil]
                                                                imgName:@"tab_icon_calc.png"
                                                          selectImgName:@"tab_icon_calc.png"
                                                               tabTitle:@"Assessment"
                                                                  title:@"ASSESSMENT"]];
    [self getCsv];
    return tabbarDataList;
}





- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application

{
    [super applicationDidBecomeActive:application];
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)getCsv{
    CsvConnecter *conecter = [CsvConnecter alloc];
    conecter.delegate = self;
    [conecter sendActionWithUrl:@""];
}

-(void)receiveSucceedWithCsvData:(NSMutableArray *)array sendId:(NSString *)sendId{
    BuyListDao *dao = [[BuyListDao alloc]init];
    [dao deleteAll];
    [dao insertWithArray:array];
    NSLog(@"csvok");
}
-(void)receiveError:(NSError *)error sendId:(NSString *)sendId{
    NSLog(@"csvng");
}

@end
