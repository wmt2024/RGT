  %% 定义函数str2column(raw,string): 读取raw数据表里面string参数所在列的列值
function Num = str2column(raw, string) 
[~, columns] = size(raw); % ~表示忽略横向参数，columns表示读取竖向参数
for i = 1:columns 
%     if raw{1, i} == string % 旧写法走不通
    if strcmp(raw{1, i},string)
        Num = i; 
        return 
    end
end
error("不存在"+ string);
end 


