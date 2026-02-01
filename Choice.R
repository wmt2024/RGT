sink("choice2_6.txt")#设定文本名，将以下内容写入此文本
rm(list=ls()) # 清空工作历史的所有变量
setwd("C:/Users/ ")  #设定访问目录
raw_data<-read.csv("group2_6.csv",header= T) #设定需要读取的文件

##引入数据处理包
library(lme4) # 混合模型
library(ggplot2) #画图
library(languageR) # “分析语言数据”的数据集和函数
library(lmerTest) # 混合线性回归
library(MuMIn) # 多模型推理
library(memisc) # 读取SPSS格式文件
library(car) # 构造辅助变量，计算测试统计，选择截止点和选择位置
library(afex)  # Analysis of Factorial Experiments

# raw_data$group[raw_data$group == 1] <- "A"
raw_data$group[raw_data$group == 2] <- "B"
# raw_data$group[raw_data$group == 3] <- "C"
raw_data$group[raw_data$group == 6] <- "F1"


# A<-raw_data[raw_data$group == "A",]
B<-raw_data[raw_data$group == "B",]
#C<-raw_data[raw_data$group == "C",]
F1<-raw_data[raw_data$group == "F1",]




# fitting Generalized Linear Mixed-Effects Models 拟合广义线性混合效应模型
# 普通线性回归的因变量必须服从正态分布，而实际问题中经常会遇到分类问题或计数问题的建模，
# GLM采用连接函数（Link Function），将因变量的分布进行了扩展，使得因变量只要服从指数分布族即可
#（如正态分布，二项分布，泊松分布，多项分布等）

#  e/v/r/ group&e / group &r 为固定效应，ID为随机效应
model1<-glmer(choice~e+v+r+group:e+group:v+group:r+(1|SubjectID),family=binomial(),data=raw_data)
summary(model1) # 读取获取描述性统计量，可以提供最小值、最大值、四分位数和数值型变量的均值，以及因子向量和逻辑型向量的频数统计等
confint(model1)  # 提供参数的置信区间

####读取A组，没有交互作用的情况
model1HR <- glmer(choice ~ e + v + r + (1|SubjectID), family = binomial(), data = B)
summary(model1HR)
confint(model1HR)

#model1HS<- glmer(choice ~ e + v + r + (1|SubjectID), family = binomial(), data = B)
#summary(model1HS)
#confint(model1HS)

# 读取B组，没有交互作用的情况
 model1LR <- glmer(choice ~ e + v + r + (1|SubjectID), family = binomial(), data = F1)
 summary(model1LR)
confint(model1LR)

# model1LS<- glmer(choice ~ e + v + r + (1|SubjectID), family = binomial(), data = D)
# summary(model1LS)
# confint(model1LS)

###evr?以各组的z分数为固定效应，探索他们的交互作用 以及和choice之间的关系
model2 <- glmer(choice ~ e_z + v_z + r_z + group:e_z + group:v_z + group:r_z +  (1|SubjectID), family = binomial(), data = raw_data)
summary(model2)
confint(model2)
# confint.merMod(model2,method = "Wald")


model2LR <- glmer(choice ~ e_z + v_z + r_z + (1|SubjectID), family = binomial(), data = B)
summary(model2LR)
confint(model2LR)

model2LS <- glmer(choice ~ e_z + v_z + r_z + (1|SubjectID), family = binomial(), data = F1)
summary(model2LS)
confint(model2LS)

# model2HR <- glmer(choice ~ e_z + v_z + r_z + (1|SubjectID), family = binomial(), data = C)
# summary(model2HR)
# confint(model2HR)

# model2HS <- glmer(choice ~ e_z + v_z + r_z + (1|SubjectID), family = binomial(), data = D)
# summary(model2HS)
# confint(model2HS)

#####加入失望值
model3<-glmer(choice~e+d+r+group:e+group:d+group:r+(1|SubjectID),family=binomial(),data=raw_data)
summary(model3)
confint(model3)
# confint.merMod(model3,method = "Wald")

# 无交互作用
model3HR <- glmer(choice ~ e + d + r + (1|SubjectID), family = binomial(), data = B)
summary(model3HR)
confint(model3HR)

model3HS<- glmer(choice ~ e + d + r + (1|SubjectID), family = binomial(), data = F1)
summary(model3HS)
confint(model3HS)

# model3LR <- glmer(choice ~ e + d + r + (1|SubjectID), family = binomial(), data = C)
# summary(model3LR)
# confint(model3LR)

# model3LS<- glmer(choice ~ e + d + r + (1|SubjectID), family = binomial(), data = D)
# summary(model3LS)
# confint(model3LS)

### z分数为固定因子
model4 <- glmer(choice ~ e_z + d_z + r_z + group:e_z + group:d_z + group:r_z +  (1|SubjectID), family = binomial(), data = raw_data)
summary(model4)
confint(model4)
# confint.merMod(model4,method = "Wald")

model4LR <- glmer(choice ~ e_z + d_z + r_z + (1|SubjectID), family = binomial(), data = B)
summary(model4LR)
confint(model4LR)

model4LS <- glmer(choice ~ e_z + d_z + r_z + (1|SubjectID), family = binomial(), data = F1)
summary(model4LS)
confint(model4LS)

# model4HR <- glmer(choice ~ e_z + d_z + r_z + (1|SubjectID), family = binomial(), data = C)
# summary(model4HR)
# confint(model4HR)

# model4HS <- glmer(choice ~ e_z + d_z + r_z + (1|SubjectID), family = binomial(), data = D)
# summary(model4HS)
# confint(model4HS)




##画图P( wheel1)
scatter<-ggplot(raw_data,aes(r,choice,colour=group))
scatter+geom_smooth(method="glm",method.args = list(family ="binomial"),aes(fill=group),alpha=0.3)+labs(x="r",y="P(wheel1)")+scale_x_continuous(breaks=c(-280,0,280))+scale_y_continuous(breaks=c(0,0.2,0.4,0.6,0.8,1))+theme_bw() +
  theme(axis.text.x = element_text(size = 20), axis.title.x = element_text(size = 22),
        axis.text.y = element_text(size = 20), axis.title.y = element_text(size = 22))
ggsave("r.tiff",  width = 7, height = 5, dpi = 150)
##e & P( wheel1)
scatter<-ggplot(raw_data,aes(e,choice,colour=group))
scatter+geom_smooth(method="glm",method.args = list(family ="binomial"),aes(fill=group),alpha=0.3)+labs(x="e",y="P(wheel1)")+scale_x_continuous(breaks=c(-140,0,245))+scale_y_continuous(breaks=c(0,0.2,0.4,0.6,0.8,1))+theme_bw() +
  theme(axis.text.x = element_text(size = 20), axis.title.x = element_text(size = 22),
        axis.text.y = element_text(size = 20), axis.title.y = element_text(size = 22))
ggsave("e.tiff",  width = 7, height = 5, dpi = 150)
##v & P( wheel1)
scatter<-ggplot(raw_data,aes(v,choice,colour=group))
scatter+geom_smooth(method="glm",method.args = list(family ="binomial"),aes(fill=group),alpha=0.3)+labs(x="v",y="P(wheel1)")+scale_x_continuous(breaks=c(-29400,0,40425))+scale_y_continuous(breaks=c(0,0.2,0.4,0.6,0.8,1))+theme_bw() +
  theme(axis.text.x = element_text(size = 20), axis.title.x = element_text(size = 22),
        axis.text.y = element_text(size = 20), axis.title.y = element_text(size = 22))
ggsave("v.tiff",  width = 7, height = 5, dpi = 150)

###P( wheel1) & d
scatter<-ggplot(raw_data,aes(d,choice,colour=group))
scatter+geom_smooth(method="glm",method.args = list(family ="binomial"),aes(fill=group),alpha=0.3)+labs(x="d",y="P(wheel1)")+scale_x_continuous(breaks=c(-280,0,280))+scale_y_continuous(breaks=c(0,0.2,0.4,0.6,0.8,1))+theme_bw() +
  theme(axis.text.x = element_text(size = 20), axis.title.x = element_text(size = 22),
        axis.text.y = element_text(size = 20), axis.title.y = element_text(size = 22))
ggsave("d.tiff",  width = 7, height = 5, dpi = 150)


sink()
