//
//  Game.m
//  emoji-game
//
//  Created by Tyler Barth on 2013-10-04.
//  Copyright (c) 2013年 cblue. All rights reserved.
//

#import "Game.h"

@interface Game  ()

@property (nonatomic, strong) NSString *currentBoard;
@property (nonatomic, strong) NSString *currentGuess;
@property (nonatomic, weak) id<GameDelegate> delegate;

@property (nonatomic, strong) NSURL* networkURL;

@end

@implementation Game


-(void)makeGuess:(NSString*)guess
{
    
}

-(void)updateBoard:(NSString*)board
{
    
}


// As soon as you create a network, it begins polling and
// will start updating your delegate
+(Game *) gameWithURL:(NSURL*)url andDelegate:(id<GameDelegate>)delegate;
{
    Game *game = [[Game alloc] init];
    
    game.delegate = delegate;
    game.networkURL = url;
    
    return game;
}

@end
