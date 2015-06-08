
#import "SelectDeviceViewController.h"
#import "QuestionViewController.h"


@interface SelectDeviceViewController ()

@end

@implementation SelectDeviceViewController

- (void)loadView {
    [[NSBundle mainBundle] loadNibNamed:@"SelectDeviceViewController" owner:self options:nil];
}
- (void)viewDidAppearLogic{
    //[self syncAction];
    //[self.table reloadData];
    
}
-(void)syncAction{
    
    NetworkConecter *conecter = [NetworkConecter alloc];
    conecter.delegate = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    NSString *deviceType = @"";
    if (self.selectDevice != 0) {
        deviceType = [NSString stringWithFormat:@"%d", self.selectDevice];
    }
    NSString *carriaType = @"";
    if (self.selectCarria != 0) {
        carriaType = [NSString stringWithFormat:@"%d", self.selectCarria];
    }
    
    [param setValue:deviceType forKey:@"device_type"];
    [param setValue:carriaType forKey:@"carrier_type"];
    [param setValue:self.modelName forKey:@"model_name"];
    [conecter sendActionSendId:@"assessment/index.php?Action=getModel" param:param];
    
}

-(void)setDataWithRecipient:(AssessmentModelRecipient *)recipient sendId:(NSString *)sendId{
    self.assessmentRecipient = recipient;
    [self.table reloadData];
}

-(BaseRecipient *)getDataWithSendId:(NSString *)sendId{
    return [AssessmentModelRecipient alloc];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CreateCell%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    BuyListData *data = [self.buyDatas objectAtIndex:indexPath.row];
    
    
    NSString *imgName = @"";
    if ([data.carria isEqualToString:@"docomo"]) {
        imgName = @"docomo.png";
    } else if ([data.carria isEqualToString:@"au"]){
        imgName = @"au.png";
    } else if ([data.carria isEqualToString:@"SoftBank"]){
        imgName = @"softbank.png";
    }
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    iv.frame = CGRectMake(self.viewSize.width - 50,10,40,20);
    [cell.contentView addSubview:iv];
    
    UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(20,10,self.viewSize.width - 80,80)];
    textLbl.text = data.model;
    textLbl.font = [UIFont fontWithName:@"AppleGothic" size:15];
    textLbl.alpha = 1.0f;
    textLbl.backgroundColor = [UIColor clearColor];
    textLbl.numberOfLines = 4;
    [cell.contentView addSubview:textLbl];
    
    //}
    return cell;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90.0f;
    } else {
        return 60.0f;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.buyDatas.count;
    } else {
        return 0;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionViewController *vc = [[QuestionViewController alloc] initWithNibName:@"QuestionViewController" bundle:nil];
    BuyListData *data = [self.buyDatas objectAtIndex:indexPath.row];
    //    AssessmentModelData *data = [self.assessmentRecipient.list objectAtIndex:indexPath.row];
    vc.title = @"ASSESSMENT";
    vc.data = data;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
