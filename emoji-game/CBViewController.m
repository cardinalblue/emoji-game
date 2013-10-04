//
//  CBViewController.m
//  emoji-game
//
//  Created by Tyler Barth on 2013-10-04.
//  Copyright (c) 2013年 cblue. All rights reserved.
//

#import "CBViewController.h"
#import "Game.h"
#import "UIViewController+DisplayPopover.h"
#import "NSString+ContainsEmoji.h"

@interface CBViewController () <GameDelegate,UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>

// Model
@property (nonatomic, assign) BOOL isGuesser;
@property (nonatomic, strong) Game* game;

// View
@property (nonatomic, weak) IBOutlet UITextView *boardField;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;
@property (nonatomic, weak) IBOutlet UILabel *guessNumber;
@property (nonatomic, weak) IBOutlet UITextField *guessField;
@end

@implementation CBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.boardField.delegate = self;
    self.guessField.delegate = self;
    
    // By default
    [self.answerLabel setHidden:YES];
    
    self.game = [[Game alloc] initNewGame:NO isGuesser:YES];
    self.game.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Ask what you want to be.
}

- (void) gameUpdated:(Game *)game
{
    NSLog(@"Game updated");
    
    if (self.isGuesser) {
        self.boardField.text = game.board;
    }
    
    self.guessNumber.text = [NSString stringWithFormat:@"%d",game.guessesCount];
    self.answerLabel.text = game.answer;
    
    if (![self.guessField isFirstResponder]) {
        self.guessField.text = game.lastGuess;
    }
    
    if (game.isGuessed) {
        [self displayPopoverWithMessage:
         [NSString stringWithFormat:@"Guess \"%@\" Won!",game.lastGuess]];

        if (!self.isGuesser) {
            self.game = [[Game alloc] initNewGame:YES isGuesser:self.isGuesser];
            [self.game setDelegate:self];
        } else {
            self.game = [[Game alloc] initNewGame:NO isGuesser:self.isGuesser];
            [self.game setDelegate:self];
        }
    }
}

// Guessfield, update when the user presses Done
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    // Call delegate here
    [self.game makeGuess:textField.text];
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self displayPopoverWithMessage:[NSString stringWithFormat:@"You Guessed:%@",textField.text]];
}

// Board field, update every time.
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text containsOnlyEmoji]) {
        NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        [self.game updateBoard:newString];
        NSLog(@"UPDATING BOARD");
        return YES;
    } else {
        [self displayPopoverWithMessage:@"ONLY EMOJI ALLOWED!!"];
        return NO;
    }
}

- (IBAction)test:(id)sender
{
    [self askUserPreference];
}

#pragma mark - Action sheet stuff

- (void) askUserPreference
{
    UIActionSheet *preference = [[UIActionSheet alloc] initWithTitle:@"Role?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Guesser", @"Asker", nil];
    [preference showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
#ifdef DEBUG
    NSLog(@"Pressed index %d",buttonIndex);
#endif
    switch (buttonIndex) {
        case 0:
            [self setIsGuesser:YES];
            break;
        case 1:
            [self setIsGuesser:NO];
            break;
        default:
            break;
    }
}

- (void) setIsGuesser:(BOOL)isGuesser
{
    if (isGuesser) {
        
        [self.guessField setBackgroundColor:[UIColor clearColor]];
        [self.guessField setUserInteractionEnabled:YES];
        
        [self.answerLabel setHidden:YES];
        
        [self.boardField setEditable:NO];
    } else {
        [self.guessField setBackgroundColor:[UIColor grayColor]];
        [self.guessField setUserInteractionEnabled:NO];
        
        [self.answerLabel setHidden:NO];
        
        [self.boardField setEditable:YES];
    }
    
    self.game = [[Game alloc] initNewGame:NO isGuesser:isGuesser];
    _isGuesser = isGuesser;
}

- (void) setGame:(Game *)game
{
    [_game stop];
    
    _game = game;
}


@end
