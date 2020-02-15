//
//  KJCommonCryptoVC.m
//  KJWorkboxDemo
//
//  Created by 杨科军 on 2020/1/17.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "KJCommonCryptoVC.h"
#import "KJCommonCryptoTool.h"
@interface KJCommonCryptoVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;

@end

@implementation KJCommonCryptoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.keyTextField.text = @"77。";
    [self.textView becomeFirstResponder];
}
// 秘钥加密
- (IBAction)md5:(id)sender {
    self.keyTextField.text = [KJCommonCryptoTool kj_MD5:self.keyTextField.text];
}
// 加密
- (IBAction)encryptBase64:(id)sender {
    self.textView.text = [KJCommonCryptoTool kj_Base64Encrypt:self.textView.text];
}
- (IBAction)encryptDES:(id)sender {
    self.textView.text = [KJCommonCryptoTool kj_DESEncrypt:self.textView.text key:self.keyTextField.text];
}
- (IBAction)encryptAES:(id)sender {
    self.textView.text = [KJCommonCryptoTool kj_AESEncrypt:self.textView.text key:self.keyTextField.text];
}

// 解密
- (IBAction)decryptBase64:(id)sender {
    self.textView.text = [KJCommonCryptoTool kj_Base64Decrypt:self.textView.text];
}
- (IBAction)decryptDES:(id)sender {
    self.textView.text = [KJCommonCryptoTool kj_DESDecrypt:self.textView.text key:self.keyTextField.text];
}
- (IBAction)decryptAES:(id)sender {
    self.textView.text = [KJCommonCryptoTool kj_AESDecrypt:self.textView.text key:self.keyTextField.text];
}

@end
