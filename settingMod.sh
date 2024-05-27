function deleteMod(){
	sed -i '/'"ServerModSetup(\"$1\")"'/d' dedicated_server_mods_setup.lua
	sed -i '/'"ServerModCollectionSetup(\"$1\")"'/d' dedicated_server_mods_setup.lua
	sed -i '/'"ForceEnableMod(\"workshop-$1\")"'/d' modsettings.lua
}

cd $1
while [ 1 ]
do
	clear

	echo "饥荒联机版服务器模组配置"
	
	echo ""
	echo "n <id>  添加模组"
	echo "d <id>  删除模组"
	echo "r       退出"
	echo ""

	# 通过 read 命令提示用户输入
	read -p "选择操作：" index
	if [[ $index =~ ^d.* ]];then
		# 删除存档
		index=`expr ${index#* }`
        	read -p "确认删除存档${index}？y/n:" input

       		# 为了避免大小写的问题，将其全部转换成小写处理
        	input=$(echo "$input" | tr "[A-Z]" "[a-z]")

        	# 判断用户输入的信息，并给出对应的提示
        	if [ "$input" = "y" ]; then
        		deleteMod $index
			echo "删除$index 成功 "
        	fi
	elif [[ $index =~ ^n.* ]];then
		index=`expr ${index#* }`

		deleteMod $index

		echo "ServerModSetup(\"$index\")" >> dedicated_server_mods_setup.lua
		echo "ServerModCollectionSetup(\"$index\")" >> dedicated_server_mods_setup.lua
        	echo "ForceEnableMod(\"workshop-$index\")" >> modsettings.lua
	
		echo "$index添加成功"
	elif [[ $index = "r" ]];then
		cd
		break
	fi
	sleep 0.5
done
