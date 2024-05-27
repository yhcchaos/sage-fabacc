#!/bin/bash

# 指定文件夹的路径
parent_folder="log"

# 遍历所有文件夹
for folder in "$parent_folder"/*; do
    if [ -d "$folder" ]; then
        # 提取文件夹的名称
        folder_name=$(basename "$folder")
        
        # 检查文件夹名称是否以 "down-" 开头
        if [[ "$folder_name" == down-* ]]; then
            # 去掉 "down-" 前缀
            new_folder_name="${folder_name#down-}"
            
            # 重命名文件夹
            mv "$folder" "$parent_folder/$new_folder_name"
            echo "重命名文件夹: $folder_name -> $new_folder_name"
        fi
    fi
done

echo "任务完成！"

