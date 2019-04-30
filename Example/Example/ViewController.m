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
        [mrc addRowModelWithTitle:@"自己生成并持有对象" detail:@"因为持有，不会打印销毁信息，会导致内存泄漏。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject generateAndHoldObject];
        }];
        [mrc addRowModelWithTitle:@"不是自己生成的对象也能持有" detail:@"因为持有，不会打印销毁信息，会导致内存泄漏。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject holdObject];
        }];
        [mrc addRowModelWithTitle:@"不在需要自己持有的对象时释放" detail:@"因为释放了，会打印销毁信息。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject releaseNoNeedObject];
        }];
        [mrc addRowModelWithTitle:@"无法释放自己没有持有的对象" detail:@"因为没有持有，会奔溃，会造成野指针操作。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject releaseNoHoldObject];
        }];
        [mrc addRowModelWithTitle:@"NSAutoreleasePool的使用" detail:@"autorelease像c语言的自动变量来对待对象实例，当超出其作用域（相当于变量作用域），对象实例的release方法被调用。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            [MRCObject autoreleaseUse];
        }];
        [_mainModel addSectionModel:mrc];
        
        SectionModel *arc = [SectionModel modelWithTitle:@"ARC自动引用计数"];
        [arc addRowModelWithTitle:@"__strong修饰符" detail:@"超出作用域或重新赋值会废弃__strong变量。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            ARCObject *obj = [[ARCObject alloc] init];
            obj = nil;
            {
                ARCObject *obj1 = [[ARCObject alloc] init];
            }
        }];
        [arc addRowModelWithTitle:@"__weak修饰符" detail:@"对象相互强引用，会产生循环引用将导致对象不会被释放，__weak修饰符不持有对象，因此可以打破对象循环引用。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            ARCObject *obj = [[ARCObject alloc] init];
            ARCObject *obj1 = [[ARCObject alloc] init];
            
            [obj setStrongObject:obj];
            [obj1 setWeakObject:obj1];
        }];
        [arc addRowModelWithTitle:@"__unsafe_unretained修饰符" detail:@"__unsafe_unretained不是安全的，修饰的对象在销毁时并不会对其置为nil，因此会产生垂悬指针，如果该内存地址被覆盖就会造成奔溃。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            ARCObject __unsafe_unretained *obj;
            {
                ARCObject *obj1 = [[ARCObject alloc] init];
                obj = obj1;
            }
            NSLog(@"%@", obj);
        }];
        [arc addRowModelWithTitle:@"__autoreleasing修饰符" detail:@"__autoreleasing修饰符用来代替调用autorelease方法，也就是说对象被注册到autoreleasepool中。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            ARCObject __weak *obj;
            @autoreleasepool {
                obj = [ARCObject object];
            }
        }];
        typedef struct {
            ARCObject *obj;
        } AStruct;
        [arc addRowModelWithTitle:@"OC对象变量不能作为c语言共用体的成员" detail:@"要把对象类型变量加入到共用体中，需强制转为void *或者前面附加__unsafe_unretained修饰符。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
//            union ErrorUnion {
//                ARCObject *obj;
//            };
            union CorrectUnion {
                void *data;
                ARCObject __unsafe_unretained *obj;
            } union1, union2, union3, union4;
            {
                ARCObject *obj1 = [[ARCObject alloc] init];
                ARCObject *obj2 = [[ARCObject alloc] init];
                ARCObject *obj3 = [[ARCObject alloc] init];
                ARCObject *obj4 = [[ARCObject alloc] init];
                union1.data = (__bridge void *)obj1;
                union2.data = (__bridge_retained void *)obj2;
                union3.data = CFBridgingRetain(obj3);
                union4.obj = obj4;
            }
            (__bridge_transfer ARCObject *)union2.data;
            CFBridgingRelease(union3.data);
        }];
        [arc addRowModelWithTitle:@"c静态数组" detail:@"各修饰符与修饰OC对象一样没有区别。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            {
                ARCObject *array[1];
                array[0] = [[ARCObject alloc] init];
            }
        }];
        [arc addRowModelWithTitle:@"c动态数组" detail:@"calloc函数分配的就是nil初始化后的内存，malloc函数分配内存后必须使用memset将内存填充为0(nil)。因为动态数组的生命周期由开发者管理，编译器不能确定销毁动态数组内元素的时机。所以必须置空_strong修饰符的态数数组内的元素，使其强引用失效，元素才能释放。" selectedAction:^(UIViewController *controller, UITableView *tableView, NSIndexPath *indexPath) {
            ARCObject * __strong *array = nil;
            array = (ARCObject * __strong *)calloc(2, sizeof(ARCObject *));
            array[0] = [[ARCObject alloc] init];
            array[1] = [[ARCObject alloc] init];
            
            array[0] = nil;
            free(array);
        }];
        [_mainModel addSectionModel:arc];
    }
    
    return _mainModel;
}

- (void)aaa:(ARCObject **)obj {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = self.mainModel.title;
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
