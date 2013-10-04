//
//  Game.m
//  emoji-game
//
//  Created by Tyler Barth on 2013-10-04.
//  Copyright (c) 2013年 cblue. All rights reserved.
//

#import "Game.h"


#define API_URL  @"http://jcham.pagekite.me/games"

@interface Game()

@property (nonatomic, readonly) NSInteger    gameId;
@property (nonatomic, strong) NSTimer  *timer;
@property (nonatomic, strong) NSOperationQueue *opQueue;
@property (nonatomic, readwrite) BOOL isGuesser;
@end

@implementation Game

- (void)handleData:(NSData *)data
{
    // Parse data
    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (!info) {
        NSLog(@"invalid data");
        return;
    }
    
    // Always update isConnected
    self.isConnected = YES;
    
    // Update ourselves
    id v = nil;

    v = [info objectForKey:@"id"];
    if (v) {
        NSInteger gid = [v integerValue];
        if (_gameId == 0) {
            _gameId = gid;
        }
        else {
            if (_gameId != gid) {
                NSLog(@"!!!! invalid game id %d, expected %d", gid, _gameId);
                return;
            }
        }
    }

    
    v = [info objectForKey:@"question"];
    if (v) {
        self.question = [v isKindOfClass:[NSNull class]] ? nil : v;
    }
    v = [info objectForKey:@"answer"];
    if (v) {
        self.answer = [v isKindOfClass:[NSNull class]] ? nil : v;
    }
    v = [info objectForKey:@"last_guess"];
    if (v) {
        self.lastGuess =  [v isKindOfClass:[NSNull class]] ? nil : v;
    }
    v = [info objectForKey:@"guesses_count"];
    if (v) {
        self.guessesCount = [v isKindOfClass:[NSNull class]] ? 0 : [v integerValue];
    }
    v = [info objectForKey:@"board"];
    if (v) {
        self.board = [v isKindOfClass:[NSNull class]] ? nil : v;
    }
    v = [info objectForKey:@"is_guessed"];
    if (v) {
        self.isGuessed = [v isKindOfClass:[NSNull class]] ? NO : [v boolValue];
    }

    // Nofity delegate
    [self.delegate gameUpdated:self];
    
}


-(void)makeGuess:(NSString *)guess
{
    NSLog(@"---> sending guess %@", guess);

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%d/guess", API_URL, _gameId]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url ];
    
    NSString *data = [NSString stringWithFormat:@"guess=%@", guess];
    [req setValue:[NSString stringWithFormat:@"%d", [data length]]
        forHTTPHeaderField:@"Content-length"];
    [req setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    [req setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:req queue:[self opQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            [self handleData:data];
        }
    }];
}

-(void)updateBoard:(NSString *)board
{
    self.board = board;
    // Will update the next cycle
}

-(void)updateTimer
{
    [self requestUpdateNewGame:NO];
}

-(void)requestUpdateNewGame:(BOOL)newGame
{
    if (!_gameId) {
        if (newGame) {
            NSLog(@"---> requesting NEW game");
            NSURL *url = [NSURL URLWithString:API_URL];
            NSMutableURLRequest *req = [[NSMutableURLRequest alloc]
                                        initWithURL:url ];
            [req setHTTPMethod:@"POST"];
            [NSURLConnection sendAsynchronousRequest:req queue:[self opQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (!connectionError) {
                    [self handleData:data];
                }
            }];
        }
        else {
            NSLog(@"---> requesting current game");
            NSURL *url = [NSURL URLWithString:API_URL];
            NSMutableURLRequest *req = [[NSMutableURLRequest alloc]
                                        initWithURL:url ];
            [NSURLConnection sendAsynchronousRequest:req queue:[self opQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (!connectionError) {
                    [self handleData:data];
                }
            }];
        }
    }
    else {
        // For now always send the board in order to update
        if (self.board && !self.isGuesser) {
            NSLog(@"---> sending board (%d)", self.board.length);
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%d/board", API_URL, _gameId]];
            NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url ];

            NSString *data = [NSString stringWithFormat:@"board=%@", self.board];
            [req setValue:[NSString stringWithFormat:@"%d", [data length]]
                forHTTPHeaderField:@"Content-length"];
            [req setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
            
            [req setHTTPMethod:@"POST"];
            [NSURLConnection sendAsynchronousRequest:req queue:[self opQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (!connectionError) {
                    [self handleData:data];
                }
            }];
        }
        else {
            NSLog(@"---> getting current state");
            
            // Do the GET
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%d", API_URL, _gameId]];
            NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url ];
            
            [NSURLConnection sendAsynchronousRequest:req queue:[self opQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (!connectionError) {
                    [self handleData:data];
                }
            }];
        }
    }
}

- (void)stop
{
    [self.timer invalidate];
    self.timer = nil;
}
- (id)initNewGame:(BOOL)newGame isGuesser:(BOOL)isGuesser
{
    self.isGuesser = isGuesser;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    self.opQueue = [NSOperationQueue mainQueue];
    [self requestUpdateNewGame:newGame];
    
    return self;
}
@end
