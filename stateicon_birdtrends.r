# Data currently in GoogleDoc here
# https://docs.google.com/spreadsheet/ccc?key=0AmqlRw67ZiBYdHJJbGJwTmZfSTU0UjI2S1I4R1kxTHc&usp=drive_web#gid=0

library(RCurl)

# Set SSL certs globally
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

googledoc = getURL("https://docs.google.com/spreadsheet/pub?key=0AmqlRw67ZiBYdHJJbGJwTmZfSTU0UjI2S1I4R1kxTHc&single=true&gid=0&range=A1%3AJ57&output=csv")

data = read.csv(textConnection(googledoc), header = T)

head(data)
data$trend.pos = 0
data$trend.neg = 0
data$trend.neg[data$X95LL < 0 & data$X95UL < 0] = 1
data$trend.pos[data$X95LL > 0 & data$X95UL > 0] = 1
library(maps)
colors = colorRampPalette(c('red','white','blue'))
data$state = tolower(data$State)
statenames = strsplit(map('state')$names,":")
statenames1 = unlist(lapply(statenames, function(x) x[1]))
data$state = unlist(strsplit(data$state," $"))
data.1per = subset(data, Notes != "state game bird")
data1 = merge(as.data.frame(statenames1), data.1per, by.x='statenames1',by.y='state',all.x=T)
data1$trendcol = 10*data1$BBS.Trend+42
data1.BY = subset(data1, credibility!='R')
data1$trendcolBY = data1$trendcol
data1$trendcolBY[data1$credibility=='R'] = NA
map('state',col = colors(82)[data1$trendcolBY], fill=T)
map('state',col = colors(82)[data1$trendcol], fill=T)
datacred = data1[data1$credibility!='R',]
hist(datacred$BBS.Trend,12)
