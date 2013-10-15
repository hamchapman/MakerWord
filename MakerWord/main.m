//
//  main.m
//  MakerWord
//
//  Created by Hamilton Chapman on 28/09/2013.
//  Copyright (c) 2013 Hamilton Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum difficulties {
    remedial = 1, easy, medium, hard, insane, impossible
    
} Difficulty;

NSMutableArray *difficultyArrayCreator(Difficulty, NSDictionary *);
NSInteger numberOfLettersInSet(NSString *);
NSArray *letters(NSString *);
bool lettersAreInWord (NSString *, NSString *);
NSArray *createArrayOfAppropriateDifficultyAndLengthSetsOfLetters(Difficulty, NSInteger);

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *myFile = [mainBundle pathForResource: @"ValidTriples"
                                                ofType: @"txt"];
        
        NSString *dictionary = [mainBundle pathForResource: @"dictionary"
                                                ofType: @"txt"];
        
        NSString *wordString = [NSString stringWithContentsOfFile:dictionary
                                                         encoding: NSUTF8StringEncoding
                                                            error:NULL];    // Creates a string containing all words in the dictionary
        
        NSArray *words = [wordString componentsSeparatedByString:@"\n"];    // Creates an array with all of the words in the dictionary
        
        changeNumOfLetters:;
        
        char number[100];
        NSLog(@"Please choose how many letters you would like to be given to form a word using (2, 3, or 4):\n");
        scanf("%s", number);
        NSString *chosenNumberOfLetters = [NSString stringWithUTF8String:number];
        NSInteger numberOfLettersChosen = [chosenNumberOfLetters integerValue];
        
        changeDifficulty:;
        
        NSLog(@"Please choose your difficulty by typing the approrpiate number:\nremedial = 1 \neasy = 2 \nmedium = 3 \nhard = 4 \ninsane = 5 \nimpossible = 6 \nYour difficulty:");
        
        Difficulty chosenDifficulty;
        scanf("%d", &chosenDifficulty);
        
        NSArray *arrayOfAppropriateDifficultyAndLengthSetsOfLetters = createArrayOfAppropriateDifficultyAndLengthSetsOfLetters(chosenDifficulty, numberOfLettersChosen);
        
        bool playAgain = true;
        
        while(playAgain)
        {
            
            u_int32_t rand = arc4random_uniform((u_int32_t) [arrayOfAppropriateDifficultyAndLengthSetsOfLetters count]);
            NSString *randomSetOfLettersWithOccurrences = [arrayOfAppropriateDifficultyAndLengthSetsOfLetters objectAtIndex:rand];
            NSString *randomSetOfLetters = [randomSetOfLettersWithOccurrences substringToIndex:((numberOfLettersChosen * 2) - 1)];
            
            NSLog(@"Here are your letters to try and make a word (with the letters being used in the given order): %@", randomSetOfLetters);
            
            bool guessIsCorrect = false;
            
            while(!guessIsCorrect)
            {
                
                char string[100];
                NSLog(@"Enter your attempt (or type n for a new set of letters, or tellme for an answer):\n");
                scanf("%s", string);
                
                NSString *guess = [NSString stringWithUTF8String:string];
                
                if([guess isEqual: @"n"])
                    break;
                
                if([guess isEqual: @"tellme"])
                {
                    NSMutableArray *possibleAnswers = [[NSMutableArray alloc] init];
                    
                    for(NSString *word in words)
                    {
                        if(lettersAreInWord(word, randomSetOfLetters))
                        {
                            [possibleAnswers addObject:word];   // Creates an array of all possible answers given a triple
                        }
                    }
                    
                    u_int32_t randomAnswerIndex = arc4random_uniform((u_int32_t) [possibleAnswers count]);
                    NSString *possibleAnswer = [possibleAnswers objectAtIndex:randomAnswerIndex];   // Picks a random possible solution to the given triple
                    
                    NSLog(@"%@", possibleAnswer);
                    break;
                }
                
                NSLog(@"%@", guess);
                
                bool guessIsInDictionary = false;
                
                for(NSString *w in words)
                {
                    if([w caseInsensitiveCompare:guess] == NSOrderedSame)       // Checking to see if the guess is in the dictionary
                    {
                        guessIsInDictionary = true;
                    }
                }
                
                if(guessIsInDictionary == true)
                {
                    if(lettersAreInWord(guess, randomSetOfLetters))
                    {
                        NSString *spacelessStringOfLetters = [randomSetOfLetters stringByReplacingOccurrencesOfString:@" " withString:@""];    // Creates a string of the current triple with no spaces, e.g. "n g y" becomes "ngy"
                        
                        if([spacelessStringOfLetters caseInsensitiveCompare:guess] != NSOrderedSame)
                        {
                            guessIsCorrect = true;
                        }
                    }
                }
                
                if(guessIsCorrect == true)
                {
                    char userPlayAgain[100];
                    NSLog(@"Correct! \nWould you like to play again? Type: \ny for yes\nn for no\ndiff to change difficulty\nnum to change number of letters: ");
                    scanf("%s", userPlayAgain);
                    NSString *userInputForPlayAgain = [NSString stringWithUTF8String:userPlayAgain];
                    
                    if([userInputForPlayAgain isEqual: @"n"])
                    {
                        goto finish;
                        playAgain = false;
                    }
                    else if([userInputForPlayAgain isEqual: @"diff"])
                    {
                        goto changeDifficulty;
                    }
                    else if ([userInputForPlayAgain isEqual: @"num"])
                    {
                        goto changeNumOfLetters;
                    }
                }
                else
                {
                    NSLog(@"Guess again");
                }
            }
        }
        
    finish:;
        
    }
    return 0;
}

NSArray *createArrayOfAppropriateDifficultyAndLengthSetsOfLetters(Difficulty chosenDifficulty, NSInteger numberOfLettersToPlayWith)
{
    NSString *typeOfSetOfLetters = [[NSString alloc] init];
    
    if (numberOfLettersToPlayWith == 2)
    {
        typeOfSetOfLetters = @"Doubles";
    }
    else if (numberOfLettersToPlayWith == 3)
    {
        typeOfSetOfLetters = @"Triples";
    }
    else
    {
        typeOfSetOfLetters = @"Quads";
    }
    
    NSString *difficulty = [[NSString alloc] init];
    
    switch (chosenDifficulty)
    {
        case remedial:
            difficulty = @"Remedial";
            break;
        case easy:
            difficulty = @"Easy";
            break;
        case medium:
            difficulty = @"Medium";
            break;
        case hard:
            difficulty = @"Hard";
            break;
        case insane:
            difficulty = @"Insane";
            break;
        case impossible:
            difficulty = @"Impossible";
            break;
        default:
            difficulty = @"Easy";
            break;
    }
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *nameOfFile = [NSString stringWithFormat: @"%@%@", difficulty, typeOfSetOfLetters];
    NSString *myFile = [mainBundle pathForResource: nameOfFile
                                            ofType: @"txt"];
    
    NSString *lettersAndOccurrencesString = [NSString stringWithContentsOfFile:myFile
                                                        encoding: NSUTF8StringEncoding
                                                           error:NULL];
    
    NSArray *arrayOfAppropriateDifficultyAndLengthSetsOfLetters = [lettersAndOccurrencesString componentsSeparatedByString:@"\n"];
    return arrayOfAppropriateDifficultyAndLengthSetsOfLetters;
}

NSInteger numberOfLettersInSet(NSString *setOfLetters)
{
    return [letters(setOfLetters) count];
}

NSArray *letters(NSString *setOfLetters)
{
    return [setOfLetters componentsSeparatedByString:@" "];
}

bool lettersAreInWord (NSString *word, NSString *setOfLetters)
{
    if(setOfLetters.length == 1)
    {
        return [word rangeOfString:setOfLetters options:NSCaseInsensitiveSearch].location != NSNotFound;
    }
    
    if([word rangeOfString:[setOfLetters substringToIndex:1] options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        NSString *newWord = [word substringFromIndex:[word rangeOfString:[setOfLetters substringToIndex:1] options:NSCaseInsensitiveSearch].location + 1];
        word = [word substringFromIndex:[word rangeOfString:[setOfLetters substringToIndex:1] options:NSCaseInsensitiveSearch].location];
        return lettersAreInWord(newWord, [setOfLetters substringFromIndex:2]);
    }
    else
    {
        return false;
    }
}