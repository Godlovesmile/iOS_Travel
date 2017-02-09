//
//  ICETutorialController.m
//
//
//  Created by Patrick Trillsam on 25/03/13.
//  Copyright (c) 2013 Patrick Trillsam. All rights reserved.
//

#import "ICETutorialController.h"

#import "RootTabBarController.h"

#import "RegisterViewController.h"


@interface ICETutorialController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation ICETutorialController
@synthesize autoScrollEnabled = _autoScrollEnabled;
@synthesize autoScrollLooping = _autoScrollLooping;
@synthesize autoScrollDurationOnPage = _autoScrollDurationOnPage;
@synthesize commonPageSubTitleStyle = _commonPageSubTitleStyle;
@synthesize commonPageDescriptionStyle = _commonPageDescriptionStyle;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        _autoScrollEnabled = YES;
        _autoScrollLooping = YES;
        _autoScrollDurationOnPage = TUTORIAL_DEFAULT_DURATION_ON_PAGE;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             andPages:(NSArray *)pages{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        _pages = pages;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                pages:(NSArray *)pages
         button1Block:(ButtonBlock)block1
         button2Block:(ButtonBlock)block2{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil andPages:pages];
    if (self){
        _button1Block = block1;
        _button2Block = block2;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor blackColor]];
    
    _windowSize = [[UIScreen mainScreen] bounds].size;
    
    // ScrollView configuration.
    [_scrollView setContentSize:CGSizeMake([self numberOfPages] * _windowSize.width,
                                           _scrollView.contentSize.height)];
    [_scrollView setPagingEnabled:YES];
    
    // PageControl configuration.
    [_pageControl setNumberOfPages:[self numberOfPages]];
    [_pageControl setCurrentPage:0];
    
    // Overlays.
    [self setOverlayTexts];
    
    // Preset the origin state.
    [self setOriginLayersState];

    // Run the auto-scrolling.
    [self autoScrollToNextPage];
    
    //输入框签订代理对象
    self.username.delegate = self;
    self.password.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions
- (void)setButton1Block:(ButtonBlock)block{
    _button1Block = block;
}

- (void)setButton2Block:(ButtonBlock)block{
    _button2Block = block;
}

//点击了登录按钮
- (IBAction)didClickOnButton1:(id)sender{
    if (_button1Block)
        _button1Block(sender);
    
    
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    if (username.length == 0 || password.length == 0) {
        
        //输入框不能为空
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户名密码不能为空" message:@"请输入" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:action0];
        [alert addAction:action1];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    //登录的block中使用了self全局变量,造成self的引用计数加一
    //解决办法:
    __weak ICETutorialController *weakSelf = self;
    //xmpp登录
    XMPPManager *manager = [XMPPManager shareManager];
    [manager loginWithUsername:username password:password success:^{
        
        //登录成功
        //动画翻转到朋友列表界面
        //UINavigationController *navigationCtrl = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"kUserListViewCtrl"];
        RootTabBarController *rootCtrl = [[RootTabBarController alloc] init];
        
//        [UIView transitionWithView:weakSelf.view.window duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
//            weakSelf.view.window.rootViewController = rootCtrl;
//        } completion:nil];
        
        weakSelf.view.window.rootViewController = rootCtrl;
        
    } faile:^(NSString *info) {
        
        NSLog(@"登录失败!!!原因:%@",info);
    }];
}

//点击了注册按钮
- (IBAction)didClickOnButton2:(id)sender{
    if (_button2Block)
        _button2Block(sender);
    
    RegisterViewController *registerCtrl = [[RegisterViewController alloc] init];
    
    //registerCtrl.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_register_background@3x"]];
    [self presentViewController:registerCtrl animated:YES completion:nil];
}

- (IBAction)didClickOnPageControl:(UIPageControl *)sender {
    _currentState = ScrollingStateManual;
    
    // Make the scrollView animation.
    [_scrollView setContentOffset:CGPointMake(sender.currentPage * _windowSize.width,0)
                         animated:YES];
    
    // Set the PageControl on the right page.
    [_pageControl setCurrentPage:sender.currentPage];
}

#pragma mark - Pages
// Set the list of pages (ICETutorialPage)
- (void)setPages:(NSArray *)pages{
    _pages = pages;
}

- (NSUInteger)numberOfPages{
    if (_pages)
        return [_pages count];
    
    return 0;
}

#pragma mark - Animations
- (void)animateScrolling{
    if (_currentState & ScrollingStateManual)
        return;
    
    // Jump to the next page...
    int nextPage = _currentPageIndex + 1;
    if (nextPage == [self numberOfPages]){
        // ...stop the auto-scrolling or...
        if (!_autoScrollLooping){
            _currentState = ScrollingStateManual;
            return;
        }
        
        // ...jump to the first page.
        nextPage = 0;
        _currentState = ScrollingStateLooping;
        
        // Set alpha on layers.
        [self setLayersPrimaryAlphaWithPageIndex:0];
        [self setBackLayerPictureWithPageIndex:-1];
    } else {
        _currentState = ScrollingStateAuto;
    }
    
    // Make the scrollView animation.
    [_scrollView setContentOffset:CGPointMake(nextPage * _windowSize.width,0)
                         animated:YES];
    
    // Set the PageControl on the right page.
    [_pageControl setCurrentPage:nextPage];
    
    // Call the next animation after X seconds.
    [self autoScrollToNextPage];
}

// Call the next animation after X seconds.
- (void)autoScrollToNextPage{
    if (_autoScrollEnabled)
        [self performSelector:@selector(animateScrolling)
                   withObject:nil
                   afterDelay:_autoScrollDurationOnPage];
}

#pragma mark - Scrolling management
// Run it.
- (void)startScrolling{
    [self autoScrollToNextPage];
}

// Manually stop the scrolling
- (void)stopScrolling{
    _currentState = ScrollingStateManual;
}

#pragma mark - State management
// State.
- (ScrollingState)getCurrentState{
    return _currentState;
}

#pragma mark - Overlay management
// Setup the Title Label.
- (void)setOverlayTitle{
    // ...or change by an UIImageView if you need it.
    [_overlayTitle setText:@"Welcome"];
}

// Setup the SubTitle/Description style/text.
- (void)setOverlayTexts{
    int index = 0;    
    for(ICETutorialPage *page in _pages){
        // SubTitles.
        if ([[[page subTitle] text] length]){
            UILabel *subTitle = [self overlayLabelWithText:[[page subTitle] text]
                                                     layer:[page subTitle]
                                               commonStyle:_commonPageSubTitleStyle
                                                     index:index];
            [_scrollView addSubview:subTitle];
        }
        // Description.
        if ([[[page description] text] length]){
            UILabel *description = [self overlayLabelWithText:[[page description] text]
                                                        layer:[page description]
                                                  commonStyle:_commonPageDescriptionStyle
                                                        index:index];
            [_scrollView addSubview:description];
        }
        
        index++;
    }
}

- (UILabel *)overlayLabelWithText:(NSString *)text
                            layer:(ICETutorialLabelStyle *)style
                      commonStyle:(ICETutorialLabelStyle *)commonStyle
                            index:(NSUInteger)index{
    // SubTitles.
    UILabel *overlayLabel = [[UILabel alloc] initWithFrame:CGRectMake((index  * _windowSize.width),
                                                                      _windowSize.height - [commonStyle offset],
                                                                      _windowSize.width,
                                                                      TUTORIAL_LABEL_HEIGHT)];
    [overlayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [overlayLabel setNumberOfLines:[commonStyle linesNumber]];
    [overlayLabel setBackgroundColor:[UIColor clearColor]];
    [overlayLabel setTextAlignment:NSTextAlignmentCenter];  

    // Datas and style.
    [overlayLabel setText:text];
    [style font] ? [overlayLabel setFont:[style font]] :
                   [overlayLabel setFont:[commonStyle font]];
    if ([style textColor])
        [overlayLabel setTextColor:[style textColor]];
    else
        [overlayLabel setTextColor:[commonStyle textColor]];
  
    [_scrollView addSubview:overlayLabel];
    return overlayLabel;
}

#pragma mark - Layers management
// Handle the background layer image switch.
- (void)setBackLayerPictureWithPageIndex:(NSInteger)index{
    [self setBackgroundImage:_backLayerView withIndex:index + 1];
}

// Handle the front layer image switch.
- (void)setFrontLayerPictureWithPageIndex:(NSInteger)index{
    [self setBackgroundImage:_frontLayerView withIndex:index];
}

// Handle page image's loading
- (void)setBackgroundImage:(UIImageView *)imageView withIndex:(NSInteger)index{
    if (index >= [_pages count]){
        [imageView setImage:nil];
        return;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@",[[_pages objectAtIndex:index] pictureName]];
    [imageView setImage:[UIImage imageNamed:imageName]];
}

// Setup layer's alpha.
- (void)setLayersPrimaryAlphaWithPageIndex:(NSInteger)index{
    [_frontLayerView setAlpha:1];
    [_backLayerView setAlpha:0];
}

// Preset the origin state.
- (void)setOriginLayersState{
    _currentState = ScrollingStateAuto;
    [_backLayerView setBackgroundColor:[UIColor blackColor]];
    [_frontLayerView setBackgroundColor:[UIColor blackColor]];
    [self setLayersPicturesWithIndex:0];
}

// Setup the layers with the page index.
- (void)setLayersPicturesWithIndex:(NSInteger)index{
    _currentPageIndex = (int)index;
    [self setLayersPrimaryAlphaWithPageIndex:index];
    [self setFrontLayerPictureWithPageIndex:index];
    [self setBackLayerPictureWithPageIndex:index];
}

// Animate the fade-in/out (Cross-disolve) with the scrollView translation.
- (void)disolveBackgroundWithContentOffset:(float)offset{
    if (_currentState & ScrollingStateLooping){
        // Jump from the last page to the first.
        [self scrollingToFirstPageWithOffset:offset];
    } else {
        // Or just scroll to the next/previous page.
        [self scrollingToNextPageWithOffset:offset];
    }
}

// Handle alpha on layers when the auto-scrolling is looping to the first page.
- (void)scrollingToFirstPageWithOffset:(float)offset{
    // Compute the scrolling percentage on all the page.
    offset = (offset * _windowSize.width) / (_windowSize.width * [self numberOfPages]);
    
    // Scrolling finished...
    if (offset == 0){
        // ...reset to the origin state.
        [self setOriginLayersState];
        return;
    }
    
    // Invert alpha for the back picture.
    float backLayerAlpha = (1 - offset);
    float frontLayerAlpha = offset;
    
    // Set alpha.
    [_backLayerView setAlpha:backLayerAlpha];
    [_frontLayerView setAlpha:frontLayerAlpha];
}

// Handle alpha on layers when we are scrolling to the next/previous page.
- (void)scrollingToNextPageWithOffset:(float)offset{
    // Current page index in scrolling.
    NSInteger page = (int)(offset);
    
    // Keep only the float value.
    float alphaValue = offset - (int)offset;
    
    // This is only when you scroll to the right on the first page.
    // That will fade-in black the first picture.
    if (alphaValue < 0 && _currentPageIndex == 0){
        [_backLayerView setImage:nil];
        [_frontLayerView setAlpha:(1 + alphaValue)];
        return;
    }
    
    // Switch pictures, and imageView alpha.
    if (page != _currentPageIndex)
        [self setLayersPicturesWithIndex:page];
    
    // Invert alpha for the front picture.
    float backLayerAlpha = alphaValue;
    float frontLayerAlpha = (1 - alphaValue);
    
    // Set alpha.
    [_backLayerView setAlpha:backLayerAlpha];
    [_frontLayerView setAlpha:frontLayerAlpha];
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // Get scrolling position, and send the alpha values.
    float scrollingPosition = scrollView.contentOffset.x / _windowSize.width;
    [self disolveBackgroundWithContentOffset:scrollingPosition];
    
    if (_scrollView.isTracking)
        _currentState = ScrollingStateManual;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // Update the page index.
    [_pageControl setCurrentPage:_currentPageIndex];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark - 触摸其他地方隐藏键盘
//触摸其他地方是结束编辑
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}
@end
