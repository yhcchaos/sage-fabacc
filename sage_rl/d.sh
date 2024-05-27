
parent_folder="log"

# 遍历所有子文件夹
for folder in "$parent_folder"/*; do
    if [ -d "$folder" ]; then
        # 提取子文件夹的名称
        folder_name=$(basename "$folder")
        # 检查是否存在对应的文件 "$folder_name.01"
	echo $folder/down-$folder_name.01
        if [ -d $folder/down-$folder_name.01 ]; then
            echo "找到文件: $folder/down-$folder_name.01"
            
            # 移动文件到子文件夹的父文件夹中
            mv $folder/down-$folder_name.01 "$parent_folder/"
            echo "移动文件: $folder/$folder_name.01 -> $parent_folder/$folder_name.01"
        fi
    fi
done

echo "任务完成！"
