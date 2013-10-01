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
bool guessContainsValidSetOfLetters(NSString *, NSString *);
bool isCharInString(NSString *, NSString *);

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
        
        NSString *triplesString = [NSString stringWithContentsOfFile:myFile
                                                            encoding: NSUTF8StringEncoding
                                                               error:NULL];    // Creates a string containing all triples from file
        
        NSArray *triplesWithOccurrences = [triplesString componentsSeparatedByString:@"\n"];    // Creates an array containing all triples from file
        
        NSMutableArray *fixedTriplesWithOccurrences = [[NSMutableArray alloc] init];
        NSMutableArray *triples = [[NSMutableArray alloc] init];
        NSMutableDictionary *tripleOccurrences = [[NSMutableDictionary alloc] init];
        
        for(NSString *triple in triplesWithOccurrences)
        {
            NSString *plainTriple = [triple substringToIndex:5];
            NSString *numOfOccurrences = [triple substringWithRange:NSMakeRange(6, ([triple length] - 6))];
            NSString *plainTripleWithSpace = [plainTriple stringByAppendingString:@" "];
            NSString *reconstructedTripleWithOccurrences = [plainTripleWithSpace stringByAppendingString: [triple substringWithRange:NSMakeRange(5, [triple length] - 5)]];
            
            [fixedTriplesWithOccurrences addObject:reconstructedTripleWithOccurrences];
            
            [triples addObject:plainTriple];
            
            [tripleOccurrences setValue: numOfOccurrences forKey: plainTriple];
        }
        
    change:;
        
        NSLog(@"Please choose your difficulty by typing the approrpiate number:\nremedial = 1 \neasy = 2 \nmedium = 3 \nhard = 4 \ninsane = 5 \nimpossible = 6 \nYour difficulty:");
        
        Difficulty chosenDifficulty;
        scanf("%d", &chosenDifficulty);
        
        NSMutableArray *chosenDifficultyTriples = [[NSMutableArray alloc] init];
        
        chosenDifficultyTriples = difficultyArrayCreator(chosenDifficulty, tripleOccurrences);
        
        bool playAgain = true;
        
        while(playAgain)
        {
            
            u_int32_t rand = arc4random_uniform((u_int32_t) [chosenDifficultyTriples count]);
            NSString *randomTriple = [chosenDifficultyTriples objectAtIndex:rand];
            
            NSLog(@"Here are your 3 letters to try and make a word (with the letters being used in the given order): %@", randomTriple);
            
            bool guessIsCorrect = false;
            
            while(!guessIsCorrect)
            {
                
                char string[100];
                NSLog(@"Enter your attempt (or type n for a new triple, or tellme for an answer):\n");
                scanf("%s", string);
                
                NSString *guess = [NSString stringWithUTF8String:string];
                
                if([guess isEqual: @"n"])
                    break;
                
                if([guess isEqual: @"tellme"])
                {
                    NSMutableArray *possibleAnswers = [[NSMutableArray alloc] init];
                    
                    for(NSString *word in words)
                    {
                        if(guessContainsValidSetOfLetters(word, randomTriple))
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
                        //NSLog(@"Word is in dictionary");
                    }
                }
                if(guessIsInDictionary == true)
                {
                    if(guessContainsValidSetOfLetters(guess, randomTriple))
                    {
                        NSString *tripleStringFromLetters = [randomTriple stringByReplacingOccurrencesOfString:@" " withString:@""];    // Creates a string of the current triple with no spaces, e.g. "n g y" becomes "ngy"
                        
                        if([tripleStringFromLetters caseInsensitiveCompare:guess] != NSOrderedSame)     // Checking to see if guess is just the triple given; if it is, reject
                        {
                            guessIsCorrect = true;
                        }
                    }
                }
                
                if(guessIsCorrect == true)
                {
                    char userPlayAgain[100];
                    NSLog(@"Correct! \nWould you like to play again? Type y for yes, n for no, or change to change difficulty: ");
                    scanf("%s", userPlayAgain);
                    NSString *userInputForPlayAgain = [NSString stringWithUTF8String:userPlayAgain];
                    
                    if([userInputForPlayAgain isEqual: @"n"])
                    {
                        goto finish;
                        playAgain = false;
                    }
                    
                    if([userInputForPlayAgain isEqual: @"change"])
                    {
                        goto change;
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


NSMutableArray *difficultyArrayCreator(Difficulty chosenDifficulty, NSDictionary *tripleOccurrences)
{
    NSMutableArray *triples = [[NSMutableArray alloc] init];
    
    int upperLimit = 0;
    int lowerLimit = 0;
    
    switch (chosenDifficulty)
    {
        case remedial:
            upperLimit = 100000;
            lowerLimit = 10000;
            break;
        case easy:
            upperLimit = 10000;
            lowerLimit = 5000;
            break;
        case medium:
            upperLimit = 5000;
            lowerLimit = 1000;
            break;
        case hard:
            upperLimit = 1000;
            lowerLimit = 250;
            break;
        case insane:
            upperLimit = 250;
            lowerLimit = 10;
            break;
        case impossible:
            upperLimit = 10;
            lowerLimit = 0;
            break;
        default:
            upperLimit = 100000;
            lowerLimit = 0;
            break;
    }
    
    for(NSString *key in tripleOccurrences)
    {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * numOfOccs = [f numberFromString:tripleOccurrences[key]];
        
        NSNumber *lowLimit = [NSNumber numberWithInteger:lowerLimit];
        NSNumber *uppLimit = [NSNumber numberWithInteger:upperLimit];
        
        if(numOfOccs > lowLimit && numOfOccs < uppLimit)
        {
            [triples addObject:key];
        }
    }
    
    return triples;
}


bool isCharInString(NSString *charToCheck, NSString *stringToCheckForChar)
{
    return [stringToCheckForChar rangeOfString:charToCheck options:NSCaseInsensitiveSearch].location != NSNotFound;
}


bool guessContainsValidSetOfLetters(NSString *guess, NSString *setOfLetters)
{
    bool validGuess = false;
    
    NSInteger numOfLettersInSet = setOfLetters.length - (setOfLetters.length / 2);
    NSInteger numOfCurrentLetter = 1;
    NSString *stringToCheckForChar = guess;
    
    while(!validGuess && numOfCurrentLetter <= numOfLettersInSet)
    {
        NSRange letterToCheck = {2 * numOfCurrentLetter - 2, 1};
        NSString *charToCheck = [setOfLetters substringWithRange:letterToCheck];
        NSInteger letterLocationInWord = [guess rangeOfString:[setOfLetters substringWithRange:letterToCheck] options:NSCaseInsensitiveSearch].location;
        
        if(isCharInString(charToCheck, stringToCheckForChar))
        {
            if((letterLocationInWord == [guess length] - 1) && numOfCurrentLetter < numOfLettersInSet)
            {
                return validGuess;
            }
            
            NSRange rangeToCheckNext = {letterLocationInWord + 1, [guess length] - (letterLocationInWord+ 1)};
            stringToCheckForChar = [guess substringWithRange:rangeToCheckNext];
            
            if(numOfCurrentLetter == numOfLettersInSet)
            {
                validGuess = true;
            }
        }
        else
        {
            return validGuess;
        }
        numOfCurrentLetter++;
    }
    return validGuess;
}