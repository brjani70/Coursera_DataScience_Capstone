setwd("C:/Users/brjani70/Desktop/Coursera R/final/finalcode")

# Shiny Server setup
library(shiny); library(stringr); library(tm)

# Bigram, trigram and quadgram frequencies
bg <- readRDS("bigram.RData"); tg <- readRDS("trigram.RData"); qd <- readRDS("quadgram.RData")

names(bg)[names(bg) == 'word1'] <- 'w1'; names(bg)[names(bg) == 'word2'] <- 'w2';
names(tg)[names(tg) == 'word1'] <- 'w1'; names(tg)[names(tg) == 'word2'] <- 'w2'; names(tg)[names(tg) == 'word3'] <- 'w3';
names(qd)[names(qd) == 'word1'] <- 'w1'; names(qd)[names(qd) == 'word2'] <- 'w2'; names(qd)[names(qd) == 'word3'] <- 'w3'
names(qd)[names(qd) == 'word4'] <- 'w4';
message <- ""

# Word prediction function
predictWord <- function(the_word) {
  word_add <- stripWhitespace(removeNumbers(removePunctuation(tolower(the_word),preserve_intra_word_dashes = TRUE)))
  the_word <- strsplit(word_add, " ")[[1]]
  n <- length(the_word)

  
  #Bigram due diligence
  if (n == 1) {the_word <- as.character(tail(the_word,1)); functionBigram(the_word)}
  
  #Trigram due diligence
  else if (n == 2) {the_word <- as.character(tail(the_word,2)); functionTrigram(the_word)}
  
  #Quadgram due diligence
  else if (n >= 3) {the_word <- as.character(tail(the_word,3)); functionQuadgram(the_word)}
}


########################################################################
functionBigram <- function(the_word) {
  # testing print(the_word)
  if (identical(character(0),as.character(head(bg[bg$w1 == the_word[1], 2], 1)))) {
    # testing print(bg$w1)
    message<<-"Given the algorithm finds no match to what was typed, it will display the most commonly used pronouns as the next suggestion." 
    as.character(head("it",1))
  }
  else {
    message <<- "This prediction was brought to you by: Bigrams (most common 2-word phrases) "
    as.character(head(bg[bg$w1 == the_word[1],2], 1))
    # testing print of bg$w1, the_word[1]
  }
}


########################################################################
functionTrigram <- function(the_word) {
  if (identical(character(0),as.character(head(tg[tg$w1 == the_word[1]
                                                  & tg$w2 == the_word[2], 3], 1)))) {
    as.character(predictWord(the_word[2]))
  }
  else {
    message<<- "This prediction was brought to you by: Trigrams (most common 3-word phrases) "
    as.character(head(tg[tg$w1 == the_word[1]
                         & tg$w2 == the_word[2], 3], 1))
  }
}


########################################################################
functionQuadgram <- function(the_word) {
  if (identical(character(0),as.character(head(qd[qd$w1 == the_word[1]
                                                  & qd$w2 == the_word[2]
                                                  & qd$w3 == the_word[3], 4], 1)))) {
    as.character(predictWord(paste(the_word[2],the_word[3],sep=" ")))
  }
  else {
    message <<- "This prediction was brought to you by: Quadgrams (most common 4-word phrases) "
    as.character(head(qd[qd$w1 == the_word[1] 
                         & qd$w2 == the_word[2]
                         & qd$w3 == the_word[3], 4], 1))
  }       
}


########################################################################

## Calling the function previously made: predictWord
shinyServer(function(input, output) {
  output$prediction <- renderPrint({
    result <- predictWord(input$inputText)
    output$sentence2 <- renderText({message})
    result
  });
  output$sentence1 <- renderText({
    input$inputText});
}
)