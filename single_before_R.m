%% 主目标：计算各个值
input_filename = 'F:\RGT_EXP\data_analysis_RGT\RGT_R\4_274\tDCS_matlab_274'; %填写文件导入路径+文件名
output_filename = 'F:\RGT_EXP\data_analysis_RGT\RGT_matlab\tDCS_matlab_274V1'; %文件导出路径 + 新文件名

% 对输入文件的不同sheets的数据进行处理
[num, txt, raw] = xlsread(input_filename);
[num2, txt2, raw2] = xlsread(input_filename, 2);
[num3, txt3, raw3] = xlsread(input_filename, 3);

%读取sheet1列表名的位置，用上自定义函数str2column()
ID_num = str2column(raw,"SubjectID");
k_num = str2column(raw, "k");
j_num = str2column(raw, "j");
l_num = str2column(raw, "l");
Trial_num = str2column(raw, "NTrial");
key_num = str2column(raw,"key");
condition2_num = str2column(raw,"condition2");
condition3_num = str2column(raw,"condition3");
condition4_num = str2column(raw,"condition4");
condition5_num = str2column(raw,"condition5");
RatingAfter_num =str2column(raw,"RatingAfter");
RatingBefore_num = str2column(raw,"RatingBefore");

%读取sheet2中的列名的位置
Trial_num_2 = str2column(raw2,"NTrial");

%读取sheet3的列名的位置
ID_num_3 = str2column(raw3,"SubjectID");
PPL_num = str2column(raw3,"PPL");
PPG_num = str2column(raw3,"PPG");
PCG_num = str2column(raw3,"PCG");
PCL_num = str2column(raw3,"PCL");

%读取sheet1-3的行数和列数
[rows, columns] = size(raw);
[rows2,columns2] = size(raw2);
[rows3,columns3] = size(raw3);

%为condition赋值做准备,condition 代表了不同的收益和损失情况
B="1";
C="2";
A="0";
D="3";
E="4";
F="5";
G="6";
H="7";
I="8";
J="9";
K="10";
L="11";
M="12";
Z="13";

%对sheet1中condition2-5栏进行赋值，要搞懂k,j,i的关系
% 部分反馈 & 完全反馈
for i = 2:rows2  % 
    for j = 2:rows
        if raw{j, k_num} > raw{j, j_num} % 当k和j值对比的时候
            raw{j, condition4_num} = B; % B = 1 
        elseif raw{j, k_num} < raw{j, j_num}
            raw{j, condition4_num} = C; % C = 0
        elseif raw{j, k_num} == raw{j, i_num}  % 当k值和i值对比的时候
            raw{j,condition4} = A; % A = 0
        end
        if raw{j,k_num} > raw{j, l_num} % k和i值对比
            raw{j, condition2_num} = D; % D = 3
        elseif raw{j,k_num} < raw{j, l_num}
            raw{j, condition2_num} = E; % E = 4
        elseif raw{j,k_num} == raw{j, l_num}
            raw{j, condition2_num} = A;
        end
            if strcmp(raw{j,condition4_num},B)
                raw{j,condition3_num} = B;
            elseif strcmp(raw{j,condition4_num}, C)
                raw{j,condition3_num} = C;
            end
            if strcmp(raw{j,condition2_num},D)
                raw{j,condition5_num} = D;
            elseif strcmp(raw{j,condition2_num}, E)
                raw{j,condition5_num} = E;
            end
             if  strcmp(raw{j,condition2_num}, A)
                   raw{j,condition5_num} = Z;
             end
    end
end

%
for k = 2:rows3  % 被试人数值
    PPL = [];
    for j = 2:rows
        if raw{j, ID_num} == raw3{k, ID_num_3} %匹配sheet1和sheet3的ID numbers
            if raw{j,condition3_num} == "2" 
              PPL = [PPL, raw{j, RatingBefore_num}]; % 存储的是第二次情绪评分
            end
        end
    end
       N = mean (PPL);  
       raw3{k,PPL_num}= N; % 给sheet3的PPL赋值
end

for k = 2:rows3
    PPG = [];
    for j = 2:rows
        if raw{j, ID_num} == raw3{k, ID_num_3}
            if raw{j,condition3_num} == "1"
                PPG = [PPG, raw{j, RatingBefore_num}]; %存储的是第一次情绪评分
            end
        end
    end
    O = mean(PPG);
    raw3{k, PPG_num} = O;
end

for k = 2:rows3
    PCL = [];
    for j = 2:rows
        if raw{j, ID_num} == raw3{k, ID_num_3}
            if raw{j, condition5_num} == '4'
                PCL = [PCL, raw{j, RatingAfter_num}]; % 存储的是第二次情绪评分
            end
        end
    end
    Q = mean(PCL);
    raw3{k, PCL_num} = Q; 
end

for k = 2: rows3
    PCG = [];
    for j = 2:rows
        if raw{j, ID_num} == raw3{k, ID_num_3}
            if strcmp(raw{j, condition5_num}, '3')
                PCG = [PCG, raw{j, RatingAfter_num}];
            end
        end
    end
    W = mean(PCG);
    raw3{k, PCG_num} = W;
end

%% 导出数据
xlswrite(output_filename, raw, 1);
xlswrite(output_filename, raw2, 2);
xlswrite(output_filename, raw3, 3);









           




