//
//  Game.m
//  emoji-game
//
//  Created by Tyler Barth on 2013-10-04.
//  Copyright (c) 2013年 cblue. All rights reserved.
//

#import "Game.h"


#define API_URL  @"http://jcham.pagekite.me/games"

@interface Game() <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, weak)id<GameDelegate> delegate;
@property (nonatomic, readonly) NSInteger    gameId;
@property (nonatomic, strong) NSURLConnection *urlConnection;
@end

@implementation Game

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Kill current one
    if (connection == _urlConnection)
        self.urlConnection = nil;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection != _urlConnection)
        return;
    
    // Parse data
    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (!info) {
        NSLog(@"invalid data %@", data);
        return;
    }
    
//    // Update ourselves
//    if ([info objectForKey:@"question"]) {
//        self.question = [info objectForKey:@"question"];
//    }
//    if ([info objectForKey:@"answer"]) {
//        self.answer = [info objectForKey:@"answer"];
//    }
//    if ([info objectForKey:@"last_guess"]) {
//        self.lastGuess = [info objectForKey:@"last_guess"];
//    }
//    if ([info objectForKey:@"question"]) {
//        self.question = [info objectForKey:@"question"];
//    }
//    if ([info objectForKey:@"question"]) {
//        self.question = [info objectForKey:@"question"];
//    }
//    
//    // Nofity delegate
    
    
    // Kill if current one
    if (connection == _urlConnection)
        self.urlConnection = nil;
    
}

-(void)makeGuess:(NSString *)guess
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%d/guess", API_URL, _gameId]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url ];
    
    NSString *data = [NSString stringWithFormat:@"guess=%@", guess];
    [req setValue:[NSString stringWithFormat:@"%d", [data length]]
        forHTTPHeaderField:@"Content-length"];
    [req setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    [req setHTTPMethod:@"PUT"];
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}

-(void)updateBoard:(NSString *)board
{
    self.board = board;
    // Will update the next cycle
}

-(void)updateTimer
{
    if (!self.urlConnection)
        [self requestUpdate];
}

-(void)requestUpdate
{
    if (!_gameId) {
        NSURL *url = [NSURL URLWithString:API_URL];
        NSMutableURLRequest *req = [[NSMutableURLRequest alloc]
                                    initWithURL:url ];
        self.urlConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    }
    else {
        // For now always PUT the board in order to update
        if (self.board) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%d/board", API_URL, _gameId]];
            NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url ];

            NSString *data = [NSString stringWithFormat:@"board=%@", self.board];
            [req setValue:[NSString stringWithFormat:@"%d", [data length]]
                forHTTPHeaderField:@"Content-length"];
            [req setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
            
            [req setHTTPMethod:@"PUT"];
            self.urlConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
        }
        else {
            // Do the GET
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%d", API_URL, _gameId]];
            NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url ];
            
            self.urlConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
        }
    }
}

-(void)setUrlConnection:(NSURLConnection *)urlConnection
{
    [self.urlConnection cancel];
    _urlConnection = urlConnection;
}

+(Game *)gameWithDelegate:(id<GameDelegate>)delegate
{
    Game *game = [[Game alloc] init];
    game.delegate = delegate;
    return game;
}
- (id)init
{
    [NSTimer timerWithTimeInterval:5 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [self requestUpdate];
    
    return self;
}
@end
