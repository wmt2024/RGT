%% 主目标：计算各个值
input_filename = 'F:\RGT_EXP\data_analysis_RGT\RGT_R\4_274\tDCS_matlab_274V2'; %填写文件导入路径+文件名
output_filename = 'F:\RGT_EXP\data_analysis_RGT\RGT_matlab\tDCS_matlab_274V3'; %文件导出路径 + 新文件名

% 对输入文件的不同sheets的数据进行处理
[num, txt, raw] = xlsread(input_filename);
[num2, txt2, raw2] = xlsread(input_filename, 2);
% [num3, txt3, raw3] = xlsread(input_filename, 3);


%读取sheet1列表名的位置，用上自定义函数str2column()
ID_num = str2column(raw,"SubjectID");
k_num = str2column(raw, "k");
j_num = str2column(raw, "j");
l_num = str2column(raw, "l");
Trial_num = str2column(raw, "NTrial");
key_num = str2column(raw,"key");
RatingAfter_num =str2column(raw,"RatingAfter");
RatingBefore_num = str2column(raw,"RatingBefore");


%读取sheet1-2的行数和列数
[rows, columns] = size(raw);
[rows2,columns2] = size(raw2);


%读取sheet2的列名的位置
ID_num_2 = str2column(raw2,"SubjectID");
PGR_num = str2column(raw2,"PGR");
PLR_num = str2column(raw2,"PLR");
CGR_num = str2column(raw2,"CGR");
CLR_num = str2column(raw2,"CLR");

for k = 2:rows2  % 被试人数值
    PGR = [];
    for j = 2:rows
        if raw{j, ID_num} == raw2{k, ID_num_2} %匹配sheet1和sheet3的ID numbers
            if raw{j,k_num} > 0 
              PGR = [PGR, raw{j, RatingBefore_num}]; % 存储的是第一次情绪评分，绝对收益
            end
        end
    end
       N = mean (PGR);  
       raw2{k,PGR_num}= N; % 给sheet3的PPL赋值
end

for k = 2:rows2  % 被试人数值
    PLR = [];
    for j = 2:rows
        if raw{j, ID_num} == raw2{k, ID_num_2} %匹配sheet1和sheet3的ID numbers
            if raw{j,k_num} < 0 
              PLR = [PLR, raw{j, RatingBefore_num}]; % 存储的是第一次情绪评分，绝对损失
            end
        end
    end
       M = mean (PLR);  
       raw2{k,PLR_num}= M; % 给sheet3的PPL赋值
end

for k = 2:rows2  % 被试人数值
    CGR = [];
    for j = 2:rows
        if raw{j, ID_num} == raw2{k, ID_num_2} %匹配sheet1和sheet3的ID numbers
            if raw{j,k_num} > 0 
              CGR = [CGR, raw{j, RatingAfter_num}]; % 存储的是第一次情绪评分，绝对损失
            end
        end
    end
       H = mean (CGR);  
       raw2{k,CGR_num}= H; % 给sheet3的PPL赋值
end

for k = 2:rows2  % 被试人数值
    CLR = [];
    for j = 2:rows
        if raw{j, ID_num} == raw2{k, ID_num_2} %匹配sheet1和sheet3的ID numbers
            if raw{j,k_num} < 0 
              CLR = [CLR, raw{j, RatingAfter_num}]; % 存储的是第一次情绪评分，绝对损失
            end
        end
    end
       G = mean (CLR);  
       raw2{k,CLR_num}= G; % 给sheet3的PPL赋值
end


%% 导出数据
xlswrite(output_filename, raw, 1);
xlswrite(output_filename, raw2, 2);


