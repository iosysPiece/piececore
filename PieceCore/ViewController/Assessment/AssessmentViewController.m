
#import "AssessmentViewController.h"
#import "WebviewController.h"

@interface AssessmentViewController ()

@end

@implementation AssessmentViewController

- (void)viewDidAppearLogic{
    //[self syncAction];
    [self setDataWithRecipient:nil sendId:nil];
    
}
-(void)syncAction{
    
    NetworkConecter *conecter = [NetworkConecter alloc];
    conecter.delegate = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValue:self.model_id forKey:@"model_id"];
    [param setValue:self.rank forKey:@"rank"];
    [conecter sendActionSendId:@"assessment/index.php?Action=getPrice" param:param];
    
}

-(void)setDataWithRecipient:(AssessmentPriceRecipient *)recipient sendId:(NSString *)sendId{
    self.priceRecipient = recipient;
    
    if (self.price < 0){
        self.price = 0;
    }
    self.priceLbl.text = [NSString stringWithFormat:@"%d",self.price];
}

-(BaseRecipient *)getDataWithSendId:(NSString *)sendId{
    return [AssessmentPriceRecipient alloc];
}
- (IBAction)assessmentAction:(id)sender {
    WebViewController *vc = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil url:@"http://otokomae-keitai.co.jp/order/"];
    vc.title = @"ASSESSMENT";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)hawtowAction:(id)sender {
    WebViewController *vc = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil url:@"http://otokomae-keitai.co.jp/process/"];
    vc.title = @"ASSESSMENT";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
