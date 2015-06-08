
#import "SearchViewController.h"
#import "CoreDelegate.h"
#import "SelectDeviceViewController.h"
#import "BuyListDao.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)loadView {
    [[NSBundle mainBundle] loadNibNamed:@"SearchViewController" owner:self options:nil];
}

- (void)viewDidLoadLogic{
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTap];
    
    self.modelNameTf.delegate = self;
    self.deviceTf.delegate = self;
    self.carriaTf.delegate = self;
}

-(void)setDeviceInfo{
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *deviceName = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    NSLog(@"デバイス名:%@", deviceName);
    
    NetworkConecter *conecter = [NetworkConecter alloc];
    conecter.delegate = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValue:deviceName forKey:@"device_version"];
    [conecter sendActionSendId:@"assessment/index.php?Action=getIosDevice" param:param];
    
    
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    
    if ([carrier.carrierName isEqualToString:@"ソフトバンクモバイル"]) {
        self.carriaTf.text = @"SoftBank";
        self.selectCarria = @"SoftBank";
    } else if ([carrier.carrierName isEqualToString:@"KDDI"]) {
        self.carriaTf.text = @"au";
        self.selectCarria = @"au";
    } else if ([carrier.carrierName isEqualToString:@"ドコモ"]) {
        self.carriaTf.text = @"docomo";
        self.selectCarria = @"docomo";
    }
    
    NSLog(@"carrierName:%@",carrier.carrierName);
    NSLog(@"carrierName: %@", carrier.carrierName);
    NSLog(@"mobileCountryCode: %@", carrier.mobileCountryCode);
    NSLog(@"mobileNetworkCode: %@", carrier.mobileNetworkCode);
    NSLog(@"isoCountryCode: %@", carrier.isoCountryCode);
    NSLog(@"allowsVOIP: %hhd", carrier.allowsVOIP);
}


-(void)onSingleTap:(UITapGestureRecognizer *)recognizer {
    [self.activeTf resignFirstResponder];
}


-(void)viewWillAppearLogic{
    BuyListDao *dao = [[BuyListDao alloc]init];
    self.carriaList = [dao selectCarria];
    self.makerList = [dao selectMaker];
}
- (IBAction)serchAction:(id)sender {
    SelectDeviceViewController *vc = [[SelectDeviceViewController alloc] initWithNibName:@"SelectDeviceViewController" bundle:nil];
    
    BuyListData *data = [[BuyListData alloc]init];
    data.model = self.modelNameTf.text;
    data.carria = self.selectCarria;
    data.maker = self.selectDevice;
    
    NSMutableArray *results = [[BuyListDao alloc]selectWithData:data];
    
    
    if (results.count == 0) {
        [[[UIAlertView alloc] initWithTitle:@"検索件数０件"
                                    message:@"買取可能な端末がHITしませんでした。"
                                   delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:nil, nil] show];
        return;
    }
    
    
    vc.buyDatas = results;
    vc.title = @"SELECT DEVICE";
    // 画面をPUSHで遷移させる
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)setDeviceAction:(id)sender {
    [self setDeviceInfo];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.activeTf resignFirstResponder];
    self.activeTf = textField;
    
    if (textField == self.carriaTf) {
        self.pickerViewController = [[SinglePickerViewController alloc] initWithNibName:@"SinglePickerViewController" bundle:nil];
        self.pickerViewController.delegate = self;
        self.pickerViewController.dataList = self.carriaList;
        self.isDispDatePicker = YES;
        [self showModal:self.pickerViewController.view];
        
        return NO;
        
    } else if (textField == self.deviceTf){
        self.pickerViewController = [[SinglePickerViewController alloc] initWithNibName:@"SinglePickerViewController" bundle:nil];
        self.pickerViewController.delegate = self;
        self.pickerViewController.dataList = self.makerList;
        self.isDispDatePicker = YES;
        [self showModal:self.pickerViewController.view];
        
        return NO;
    }
    //1:フューチャーフォン 2:android携帯 3:androidタブレット 4:ios携帯 5:iosタブレット
    return YES;
}

- (void) showModal:(UIView *) modalView
{
    UIWindow *mainWindow = (((CoreDelegate *) [UIApplication sharedApplication].delegate).window);
    
    CGPoint offScreenCenter = CGPointMake(self.viewSize.width * 0.5f, self.viewSize.height * 1.5f);
    modalView.center = offScreenCenter;
    modalView.frame = CGRectMake(0, 0, self.viewSize.width, self.viewSize.height);
    [mainWindow addSubview:modalView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    modalView.center = CGPointMake(self.viewSize.width * 0.5f, self.viewSize.height * 0.5f);
    [UIView commitAnimations];
}

- (void) hideModal:(UIView*) modalView
{
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width * 0.5f, offSize.height * 1.5f);
    [UIView beginAnimations:nil context:(__bridge_retained void *)(modalView)];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideModalEnded:finished:context:)];
    modalView.center = offScreenCenter;
    [UIView commitAnimations];
}


- (void) hideModalEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    UIView *modalView = (__bridge_transfer UIView *)context;
    [modalView removeFromSuperview];
}

- (BOOL) textViewShouldBeginEditing: (UITextView*) textView
{
    self.activeTf = nil;
    return YES;
}

- (void)didCommitButtonClickedSinglePicker:(SinglePickerViewController *)controller select:(NSString *)select{
    [self hideModal:controller.view];
    self.activeTf.text = select;
    
    NSInteger selectedRow = [controller.pickerView selectedRowInComponent:0] + 1;
    if (self.activeTf == self.carriaTf) {
        self.selectCarria = select;
    } else if (self.activeTf == self.deviceTf){
        self.selectDevice = select;
    }
    DLog(@"%ld",(long)selectedRow);
}
- (void)didCancelButtonClickedSinglePicker:(SinglePickerViewController *)controller{
    [self hideModal:controller.view];
}

-(void)receiveSucceed:(NSDictionary *)receivedData sendId:(NSString *)sendId{
    self.isResponse = YES;
    NSString *modelName =[receivedData objectForKey:@"model_name"];
    self.modelNameTf.text = modelName;
}
@end
