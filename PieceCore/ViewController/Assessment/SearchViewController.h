#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SinglePickerViewController.h"

@interface SearchViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *modelNameTf;
@property (weak, nonatomic) IBOutlet UITextField *carriaTf;
@property (weak, nonatomic) IBOutlet UITextField *deviceTf;
@property (nonatomic) NSMutableArray *singlePickerList;
@property (strong, nonatomic) UITextField *activeTf;
@property (nonatomic) bool isDispDatePicker;
@property (nonatomic, retain) SinglePickerViewController *pickerViewController;
@property (nonatomic) NSString *selectCarria;
@property (nonatomic) NSString *selectDevice;
@property (nonatomic) NSMutableArray *carriaList;
@property (nonatomic) NSMutableArray *makerList;
@property(nonatomic, strong) UITapGestureRecognizer *singleTap;
- (IBAction)serchAction:(id)sender;
- (IBAction)setDeviceAction:(id)sender;

@end
