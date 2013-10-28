//
//  CBViewController.m
//  emoji-game
//
//  Created by Tyler Barth on 2013-10-04.
//  Copyright (c) 2013年 cblue. All rights reserved.
//

#import "CBViewController.h"
#import "Game.h"

@interface CBViewController () <UITextViewDelegate>

// Model
@property (nonatomic, assign) BOOL isGuesser;
@property (nonatomic, strong) Game* game;;

// View
@property (nonatomic, weak) IBOutlet UITextView *boardView;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;
@property (nonatomic, weak) IBOutlet UILabel *guessNumber;
@property (nonatomic, weak) IBOutlet UITextField *guessField;

@end

@implementation CBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Ask what you want to be.
    
    // Create emojiNetwork
}


- (void) setIsGuesser:(BOOL)isGuesser
{
    if (isGuesser) {
        
    } else {
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
