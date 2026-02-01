sink("Rating_group2_6.txt")## 定下写入信息的txt文本名字，并记录以下信息
rm(list=ls()) # 清空历史记录
setwd("C:/Users/ ") # 不能有空格和中文
raw_data <- read.csv("group2_6.csv",header=T)##读取需要处理的数据


## 倒入需要使用的packages
library(lme4) 
library(ggplot2) 
library(languageR) 
library(lmerTest)
library(MuMIn)
library(memisc)
library(car)
library(afex)

##读取需要处理的数据组
raw_data$group[raw_data$group == 2] <- "B"
raw_data$group[raw_data$group == 6] <- "F1"
# raw_data$group[raw_data$group == 3] <- "C"
# raw_data$group[raw_data$group == 4] <- "D"

B<-raw_data[raw_data$group == "B",]
F1<-raw_data[raw_data$group == "F1",]
# C<-raw_data[raw_data$group == "C",]
# D<-raw_data[raw_data$group == "D",]



### 第一次评分
# Fitting Linear Mixed-Effects Models 拟合线性混合效应模型
model1<-lmer(RatingBefore~k*group+(1|SubjectID),data = raw_data)
summary(model1)
confint(model1)


####第二次评分
model2<-lmer(RatingAfter~k*group+(1|SubjectID),data = raw_data)
summary(model2)
confint(model2)


#### 第一次评分
model3<-lmer(RatingBefore~chance_counterfactual*group+(1|SubjectID),data=raw_data)
summary(model3)
confint(model3)


#### 第二次评分
model4<-lmer(RatingAfter~agent_counterfactual*group+(1|SubjectID),data=raw_data)
summary(model4)
confint(model4)



## 画图
scatter<-ggplot(raw_data,aes(k,RatingBefore,colour=group))
scatter + geom_smooth(method="lm",aes(fill=group),alpha=0.5)+labs(x="Obtained outcome",y="RatingBefore")+scale_x_continuous(breaks=c(-210,0,210))+ylim(1,9)+theme_bw() +      
  theme(axis.text.x = element_text(size = 20), axis.title.x = element_text(size = 22),
        axis.text.y = element_text(size = 20), axis.title.y = element_text(size = 22))
ggsave("partial_obtained.tiff", width = 7, height = 5, dpi = 150)

##RatingAfeter & obtain outcome 
scatter<-ggplot(raw_data,aes(k,RatingAfter,colour=group))
scatter+geom_smooth(method="lm",aes(fill=group),alpha=0.5)+labs(x="obtained outcome",y="RatingAfter")+scale_x_continuous(breaks=c(-210,0,210))+ylim(1,9)+theme_bw() +      
  theme(axis.text.x = element_text(size = 20), axis.title.x = element_text(size = 22),
        axis.text.y = element_text(size = 20), axis.title.y = element_text(size = 22))
ggsave("complete_obtained.tiff", width = 7, height = 5, dpi = 150)

##RatingBefore & chance_counterfactual
scatter<-ggplot(raw_data,aes(chance_counterfactual,RatingBefore,colour=group))
scatter+geom_smooth(method="lm",aes(fill=group),alpha=0.5)+labs(x="chance_counterfactual",y="RatingBefore")+scale_x_continuous(breaks=c(-420,0,420))+ylim(1,9)+theme_bw() +      
  theme(axis.text.x = element_text(size = 20), axis.title.x = element_text(size = 22),
        axis.text.y = element_text(size = 20), axis.title.y = element_text(size = 22))
ggsave("partial_chance.tiff", width = 7, height = 5, dpi = 150)

##Ratingafter & agent_counterfactual
scatter<-ggplot(raw_data,aes(agent_counterfactual,RatingAfter,colour=group))
scatter+geom_smooth(method="lm",aes(fill=group),alpha=0.5)+labs(x="agent_counterfactual",y="RatingAfter")+scale_x_continuous(breaks=c(-420,0,420))+ylim(1,9)+theme_bw() +      
  theme(axis.text.x = element_text(size = 20), axis.title.x = element_text(size = 22),
        axis.text.y = element_text(size = 20), axis.title.y = element_text(size = 22))
ggsave("complete_agent.tiff", width = 7, height = 5, dpi = 150)




##cohen??s f2
MuMIn::r.squaredGLMM(model1)
model1b <- lmer(RatingBefore ~ k + group + (1|SubjectID), data = raw_data)
summary(model1b)
MuMIn::r.squaredGLMM(model1b)

MuMIn::r.squaredGLMM(model2)
model2b <- lmer(RatingAfter ~ k + group + (1|SubjectID), data = raw_data)
summary(model2b)
MuMIn::r.squaredGLMM(model2b)

MuMIn::r.squaredGLMM(model3)
model3b <- lmer(RatingBefore ~ chance_counterfactual + group + (1|SubjectID), data = raw_data)
summary(model3b)
MuMIn::r.squaredGLMM(model3b)

MuMIn::r.squaredGLMM(model4)
model4b <- lmer(RatingAfter ~ agent_counterfactual + group + (1|SubjectID), data = raw_data)
summary(model4b)
MuMIn::r.squaredGLMM(model4b)



sink()