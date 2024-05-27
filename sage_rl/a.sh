#!/bin/bash

# 指定文件夹的路径
folder_path="log"
# 遍历文件夹中所有以1.svg结尾的文件
for file in "$folder_path"/down*; do
    echo $file
    if [ -f "$file" ]; then
        # 提取前缀名，去掉-1.svg后缀
        prefix=$(basename "$file" | sed 's/-1\.svg$//')
        mkdir -p "$folder_path/$prefix" 
        # 移动文件到相应的文件夹
	mv "$folder_path/${prefix}-"* "$folder_path/$prefix/"
    fi
done

echo "任务完成！"
