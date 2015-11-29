install.packages("SnowballC")
install.packages("RWeka")
install.packages("e1071")
install.packages("tm")
install.packages("plyr")


library(SnowballC)
library(RWeka)
library(e1071)
library(tm)
library(plyr)

r_positive_text <- sapply(r_xfactor, function(x) x$getText())
r_positiveDF <- twListToDF(r_xfactor)

r_positive_text <- sapply(r_Apprentice, function(x) x$getText())
r_positiveDF <- twListToDF(r_Apprentice)

r_positive_text <- sapply(r_techch2015_text, function(x) x$getText())
r_positiveDF <- twListToDF(r_techch2015)
r_positiveDF$hash <- ""

for (i in 1:1500) {

is.positive[i] <- grepl("fantastic|stupendous|fab|magnificent|good|great|best|incredible|superb|bril|excellent|remarkable|fun|happy|smiley|adorableaccepted|acclaimedaccomplish|accomplishmentachievement|admireadventure|affirmativeaffluent|agreeableamazing|angelicappealing|approve|
aptitude|attractive|awesome|beaming|beautiful|beneficial|bliss|bountiful|bounty|brave|bravo|brilliant|bubbly|celebrated|certain|champ|champion|charming|
cheery|classic|composed|cool|courageous|creative|cute|dazzling|delight|delightful|distinguished|divine|earnest|ecstatic|effective|effervescent|
efficient|effortless|electrifying|elegant|enchanting|encouraging|energetic|energized|engaging|enthusiastic|essential|esteemed|ethical|excellent|
exciting|exquisite|fabulous|familiar|fantastic|favorable|fetching|fortunate|fresh|friendly|fun|funny|generous|genius|genuine|glamorous|good|gorgeous|
graceful|great|handsome|happy|harmonious|honest|ideal|impressive|independent|innovate|innovative|intellectual|intelligent|inventive|jovial|joy|jubilant|
kind|knowing|knowledgeable|laugh|legendary|learned|lively|lovely|lucid|lucky|marvelous|masterful|meaningful|merit|meritorious|miraculous|motivating|
natural|nice|novel|nurturing|optimistic|paradise|perfect|phenomenal|pleasurable|pleasant|poised|popular|positive|powerful|prepared|pretty|principled|
productive|progress|protected|proud|quality|reassuring|refined|refreshing|rejoice|reliable|remarkable|resounding|respected|restored|reward|rewarding|
robust|satisfactory|secure|skilled|skillful|sparkling|special|spirited|stirring|stupendous|stunning|success|successful|super|superb|terrific|thrilling|
thriving|tranquil|transforming|transformative|trusting|truthful|unreal|unwavering|upbeat|upright|upstanding|valued|vibrant|victorious|victory|vigorous|
virtuous|vital|vivacious|wealthy|willing|wonderful|wondrous|worthy|wow|yes|yummy|zeal|zealous",r_positiveDF$text[i])

is.negative[i] <- grepl("pain|sad|hurt|angry|tired|fail,sadface|abysmal|adverse|alarming|angry|annoy|anxious|apathy|appalling|atrocious|awful|bad|banal|barbed|belligerent|bemoan|beneath|boring|broken|callous|
clumsy|coarse|cold-hearted|collapse|confused|contradictory|contrary|corrosive|corrupt|crazy|creepy|criminal|cruel|cry|cutting|dead|decaying|damage|
damaging|dastardly|deplorable|depressed|deprived|deformed|deny|despicable|detrimental|dirty|disease|disgusting|disheveled|dishonest|dishonorable|dismal|
distress|don't|dreadful|dreary|enraged|eroding|evil|fail|faulty|fear|feeble|fight|filthy|foul|frighten|frightfulgawky|ghastly|grave|greed|grim|grimace|
gross|grotesque|gruesome|guilty|haggard|hard|hard-hearted|harmful|hate|hideous|homely|horrendous|horrible|hostile|hurt|hurtful|ignore|ignorant|immature|
imperfect|impossible|inane|inelegant|infernal|injure|injurious|insane|insidious|insipid|jealous|lousy|lumpy|malicious|mean|menacing|messy|misshapen|
missing|misunderstood|moan|moldy|monstrous|naive|nasty|naughty|negate|negative|nondescript|nonsense|noxious|objectionable|odious|offensive|oppressive|
pain|perturb|pessimistic|petty|plain|poisonous|poor|prejudice|questionable|quirky|quit|reject|renege|repellant|reptilian|repulsive|repugnant|revenge|
revolting|rocky|rotten|rude|ruthless|sad|savage|scare|scary|severe|shoddy|shocking|sick|sickening|sinister|slimy|smelly|sobbing|sorry|spiteful|stinky|
stressful|stupidsubstandard|suspect|suspicious|tense|terrible|terrifying|threatening|ugly|undermine|unfair|unfavorable|unhappy|unhealthy|unjust|unlucky|
unpleasant|upset|unsatisfactory|unsightly|untoward|unwanted|unwelcome|unwholesome|unwieldy|unwise|upset|vice|vicious|vile|villainous|vindictive|wary|
weary|wicked|woeful|worthless|wound|yell|yucky|zero",r_positiveDF$text[i])

#r_positiveDF$hash <- is.positive[i]

if (is.positive[i]==TRUE && is.negative[i]==FALSE) {
  r_positiveDF$hash[i] <- 1
}
if (is.positive[i]==FALSE && is.negative[i]==TRUE) {
  r_positiveDF$hash[i] <- -1
}

if (is.positive[i]==FALSE && is.negative[i]==FALSE) {
  r_positiveDF$hash[i] <- 0
}
print(paste(paste(is.positive[i],is.negative[i],sep=" "), r_positiveDF$hash[i],sep= " "))
}


keeps<- c("hash","text")
r_positiveDF<- r_positiveDF[,keeps]


r_techch2015_text <- gsub("[[:punct:]]", " ", r_positive)
#r_techch2015_text<-iconv(r_techch2015_text, "latin1", "UTF-8",sub='')
r_techch2015_text<-iconv(r_positive_text, "latin1", "ASCII",sub="")

list.vector.words<-list()
allwords<- NULL
for (i in 1:dim(r_positiveDF)[1]) {
  each.vector<- strsplit(r_positiveDF$text[i], split=" ")
  allwords<- c(allwords, each.vector)
  list.vector.words[[i]]<-each.vector
}



data.tm<-Corpus(VectorSource(list.vector.words))
data.tm<-tm_map(data.tm, content_transformer(tolower))
data.tm<-tm_map(data.tm, content_transformer(removePunctuation))
data.tm<-tm_map(data.tm, content_transformer(stripWhitespace))
data.tm<-tm_map(data.tm, content_transformer(stemDocument))
data.tm<-tm_map(data.tm, content_transformer(function(x) removeWords(x,stopwords())))
                
BigramTokeniser<- function(x) NGramTokenizer(x, Weka_control(min=2, max=2))

datamat<- DocumentTermMatrix(data.tm, control = list(tokenise=BigramTokeniser))

dat<-as.matrix(datamat)
#rownames(dat) <-names
word.usage<-colSums(dat)

dat[dat>1] <- 1
threshold<-9
tokeep<-which(word.usage>threshold)
dat.out<- dat[,tokeep]

num.zero<-rowSums(dat.out==0)
table(num.zero)
num_cols <- dim(dat.out[2])
cutoff<-2
to.keep <- which(num.zero<(num_cols - cutoff))
dat.drop <-dat.out[to.keep,]
#outcome <- outcome[to.keep]

myDat <- cbind(r_positiveDF$hash,dat.out)
myDat<-as.data.frame(myDat)
colnames(myDat)[1]<-"Sentiment"
myDat[,1] <- factor(myDat[,1])

#NBmod <- naiveBayes(myDat[1:900,-1], myDat[1:900,1])
NBmod <- naiveBayes(myDat[1:50,-1], myDat[1:50,1])

NBpredictions<-predict(NBmod, myDat[901:1500,-1])
NBpredictions<-predict(NBmod, myDat[1:500,-1])
NBpredictions<-predict(NBmod, myDat[51:76,-1])


count(r_positiveDF, "hash")
pos1 <- subset(r_positiveDF, hash == 1)
neg1 <- subset(r_positiveDF, hash == -1)
neu1 <-  head(subset(r_positiveDF, hash == 0), n=200)
r_positiveDF <- rbind(pos1,neg1, neu1)

table(NBpredictions, myDat[,1])
table(NBpredictions, myDat[51:76,1])
table(NBpredictions, myDat[901:1500,1])
table(NBpredictions, myDat[1:500,1])
