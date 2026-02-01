
##读取表格数据
rm(list=ls()) # 清空工作历史的所有变量
setwd("F:/RGT_EXP/data_analysis_RGT/RGT_R") # 设定访问目录
raw_data<-read.csv("tDCS_R1.csv", header= T)## 读取cvs数据表，包括表头


##对代理反事实 & 机会反事实
raw_data$agent_counterfactual <- raw_data$k - raw_data$l
raw_data$chance_counterfactual <- raw_data$k - raw_data$j

### 计算z分数
raw_data$e_z <- (raw_data$e-mean(raw_data$e))/sd(raw_data$e)
raw_data$r_z <- (raw_data$r-mean(raw_data$r))/sd(raw_data$r)
raw_data$v_z <- (raw_data$v-mean(raw_data$v))/sd(raw_data$v)
raw_data$d_z <- (raw_data$d-mean(raw_data$d))/sd(raw_data$d)

####计算绝对值
raw_data$e_abs <- abs(raw_data$e)
raw_data$r_abs <- abs(raw_data$r)
raw_data$v_abs <- abs(raw_data$v)
raw_data$d_abs <- abs(raw_data$d)

##写入表格
write.csv(raw_data,file="tDCS_R2.csv", row.names = FALSE) # 修改生成文件名