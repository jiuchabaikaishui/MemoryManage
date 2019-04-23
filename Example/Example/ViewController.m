//
//  ViewController.m
//  Example
//
//  Created by 綦帅鹏 on 2019/4/23.
//  Copyright © 2019年 QSP. All rights reserved.
//

#import "ViewController.h"
#import "MainTableViewCell.h"
#import "MRCObject.h"
#import "ARCObject.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MainModel *mainModel;

@end

@implementation ViewController

- (MainModel *)mainModel {
    if (_mainModel == nil) {
        _mainModel = [MainModel modelWithTitle:@"Objective-C内存管理"];
        
        SectionModel *mrc = [SectionModel modelWithTitle:@"MRC手动引用计数"];
//        [mrc addRowModelWithTitle:@"自己生成并持有对象" detail:@"因为持有，不会打印销毁信息，会导致内存泄漏。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
//            [MRCObject generateAndHoldObject];
//        }];
//        [mrc addRowModelWithTitle:@"不是自己生成的对象也能持有" detail:@"因为持有，不会打印销毁信息，会导致内存泄漏。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
//            [MRCObject holdObject];
//        }];
//        [mrc addRowModelWithTitle:@"不在需要自己持有的对象时释放" detail:@"因为释放了，会打印销毁信息。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
//            [MRCObject releaseNoNeedObject];
//        }];
//        [mrc addRowModelWithTitle:@"无法释放自己没有持有的对象" detail:@"因为没有持有，会奔溃，会造成野指针操作。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
//            [MRCObject releaseNoHoldObject];
//        }];
//        [mrc addRowModelWithTitle:@"NSAutoreleasePool的使用" detail:@"autorelease像c语言的自动变量来对待对象实例，当超出其作用域（相当于变量作用域），对象实例的release方法被调用。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
//            [MRCObject autoreleaseUse];
//        }];
        [_mainModel addSectionModel:mrc];
        
        SectionModel *arc = [SectionModel modelWithTitle:@"ARC自动引用计数"];
//        [arc addRowModelWithTitle:@"__strong修饰符" detail:@"超出作用域或重新复制会废弃__strong变量。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
//
//        }];
//        [arc addRowModelWithTitle:@"__weak修饰符" detail:@"对象相互强引用，会产生循环引用将导致对象不会被释放，__weak修饰符不持有对象，因此可以打破对象循环引用。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
//
//        }];
//        [arc addRowModelWithTitle:@"__unsafe_unretained修饰符" detail:@"__unsafe_unretained不是安全的，修饰的对象在销毁时并不会对其置为nil，因此会产生垂悬指针，如果该内存地址被覆盖就会造成奔溃。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
//
//        }];
//        [arc addRowModelWithTitle:@"__outoreleasing修饰符" detail:@"__outoreleasing修饰符用来代替调用outorelease方法，也就是说对象被注册到autoreleasepool中。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
//            @autoreleasepool {
//                ARCObject __autoreleasing *obj1 = [ARCObject allocObject];
//                NSLog(@"autoreleasepool块最后一行%@", obj1);
//            }
//            NSLog(@"autoreleasepool块已经结束");
//        }];
//        [arc addRowModelWithTitle:@"非显示的使用__outoreleasing修饰符" detail:@"cocoa中由于编译器会检查方法名是否以alloc/new/copy/mutableCopy开始，如果不是则自动将返回值的对象注册到outoreleasepool中。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
//
//        }];
//        [arc addRowModelWithTitle:@"c静态数组" detail:@"各修饰符与修饰OC对象一样没有区别。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
//
//        }];
//        [arc addRowModelWithTitle:@"c动态数组" detail:@"各修饰符与修饰OC对象一样没有区别。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
//
//        }];
        [_mainModel addSectionModel:arc];
    }
    
    return _mainModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = self.mainModel.title;
}
- (BOOL)performOperationWithError:(ARCObject **)obj {
    *obj = [ARCObject object];
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.mainModel sectionCount];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mainModel rowCountOfSetion:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MainTableViewCell cellWithTableView:tableView indexPath:indexPath model:[self.mainModel rowModelOfIndexPath:indexPath]];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    SectionModel *model = [self.mainModel sectionModelOfSection:section];
    return model.title;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RowModel *model = [self.mainModel rowModelOfIndexPath:indexPath];
    if (model.selectedAction) {
        model.selectedAction(self, tableView, indexPath);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
