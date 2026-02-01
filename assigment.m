%% 主目标： 获取被试各个试次的key/group/e/v/r/d/k,j/l值 
%文件导入和导出
input_filename = 'F:\RGT_EXP\data_analysis_RGT\RGT_matlab\tDCS_matlab_pre11'; %导入文件路径 + 文件名
output_filename = 'F:\RGT_EXP\data_analysis_RGT\RGT_matlab\tDCS_matlab_pre22'; %导出文件路径+ 文件名

%读取文件的各个sheet的数据
[num, txt, raw] = xlsread(input_filename);  %将表格中的数字和文本分开保存的同时，并把它们保存到raw里面，形成一个单一变量
[num2, txt2, raw2] = xlsread(input_filename, 2); %raw2 是元胞数组形式，可以存储各种形式的数据
[num3, txt3, raw3] = xlsread(input_filename, 3);

%%数据处理与计算
%读取sheet2列表的列名所在的位置数
Ox1_num = str2column(raw2, 'Ox1'); %返回Ox1列名所在的位置数
Ox2_num = str2column(raw2, "Ox2"); 
x1_num = str2column(raw2, "x1"); 
y1_num = str2column(raw2, "y1");
Outcome1_num = str2column(raw2, "Outcome1");
x2_num = str2column(raw2, "x2");
y2_num = str2column(raw2, "y2");
Outcome2_num = str2column(raw2, "Outcome2");
e_num_2 = str2column(raw2, "e"); 
v_num_2 = str2column(raw2, "v");
r_num_2 = str2column(raw2, "r");
d_num_2 = str2column(raw2, "d");
Trial_num_2 = str2column(raw2, "NTrial");

%读取sheet1列表中的列名所在的位置数
e_num = str2column(raw, "e");
v_num = str2column(raw, "v");
r_num = str2column(raw, "r");
d_num = str2column(raw, "d");
Trial_num = str2column(raw, "NTrial"); %NTrial
Choice_num = str2column(raw, "Choices");
Changes_num = str2column(raw, "Changes");
k_num = str2column(raw, "k");
j_num = str2column(raw, "j");
l_num = str2column(raw, "l");
key_num = str2column(raw,"key");
ID_num = str2column(raw,"SubjectID");
group_num = str2column(raw,"group");

%读取sheet3中的列名所在的位置数
ID_num_3 = str2column(raw3,"SubjectID");
group_num_3 = str2column(raw3,"group");

% 读取sheet1-sheet3的各表的总行数和总列数值
[rows3, columns3] = size(raw3);
[rows2, columns2] = size(raw2); 
[rows, columns] = size(raw); %是否需要和子函数合并？或者直接省略

C = '1'; %  最终选择为左边
D = '0';  % 最终选择为右边

%将sheet2中的e,v,r,d信息读取到sheet1
for i = 2:rows2 % sheet2的行数
    for j = 2:rows 
        if raw2{i, Trial_num_2} == raw{j, Trial_num} % 如果sheet2中的某行trail列 = sheet1中的某行trail列
            raw{j, e_num} = raw2{i, e_num_2}; % 那么sheet1中的j行e值和sheet2中的i行e值相等
            raw{j, v_num} = raw2{i, v_num_2}; 
            raw{j, r_num} = raw2{i, r_num_2};
            raw{j, d_num} = raw2{i, d_num_2};

%将sheet3中的ID & group信息赋值到sheet1
         for k = 2:rows3
             if raw3{k, ID_num_3} == raw{j, ID_num} 
                 raw{j,group_num} = raw3{k,group_num_3}; 

             end
             
 % 给sheet1里面的被试的k, j, i 赋值  
         if raw{j, Changes_num} == 'NaN' 
             if raw{j, Choice_num} == 'f' %sheet1里面j行 choice_num = f时 （选左）
                 raw{j, k_num} = raw2{i, Outcome1_num}; %sheet1的K值 = sheet2的outcome1值
                    raw{j, j_num} = raw2{i, Ox1_num}; %sheet1的j值 = sheet2的Ox1值
                    raw{j, l_num} = raw2{i, Outcome2_num};
                    raw{j,key_num} = C;   %C = 1 
             elseif raw{j, Choice_num} == "j"
                 raw{j, k_num} = raw2{i, Outcome2_num};
                 raw{j, j_num} = raw2{i, Ox2_num};
                 raw{j, l_num} = raw2{i, Outcome1_num};
                 raw{j,key_num} = D;  % D = 0
             end
         else
             if raw{j, Changes_num} == 'j' % sheet1里面j行changes_num = j 时（选右）
                 if raw{j, Choice_num} == 'f'
                     raw{j, k_num} = raw2{i, Outcome1_num};
                        raw{j, j_num} = raw2{i, Ox1_num};
                        raw{j, l_num} = raw2{i, Outcome2_num};
                        raw{j,key_num} = C;  
                    elseif raw{j, Choice_num} == "j"
                        raw{j, k_num} = raw2{i, Outcome2_num};
                        raw{j, j_num} = raw2{i, Ox2_num};
                        raw{j, l_num} = raw2{i, Outcome1_num};
                        raw{j,key_num} = D; 
                    end
                elseif raw{j, Changes_num} == "f"
                     if raw{j, Choice_num} == "f"
                        raw{j, k_num} = raw2{i, Outcome2_num};
                        raw{j, j_num} = raw2{i, Ox2_num};
                        raw{j, l_num} = raw2{i, Outcome1_num};
                        raw{j,key_num} = D; 
                     elseif raw{j, Choice_num} == "j"
                        raw{j, k_num} = raw2{i, Outcome1_num};
                        raw{j, j_num} = raw2{i, Ox1_num};
                        raw{j, l_num} = raw2{i, Outcome2_num};
                        raw{j,key_num} = C;
                     end
             end
         end
         end
        end
    end
end

%% 导出数据
xlswrite(output_filename, raw, 1); %把sheet1 = raw的数据写入output_filename的sheet1
xlswrite(output_filename, raw2, 2);
xlswrite(output_filename, raw3, 3);



           
             



















