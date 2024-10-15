#!/bin/bash

steamcmd_dir="$HOME/steamcmd"  # steamcmd保存位置
install_dir="$HOME/dontstarvetogether_dedicated_server" # 饥荒服务器保存位置
dontstarve_dir="$HOME/.klei/DoNotStarveTogether" # 存档保存位置

function fail()
{
	echo Error: "$@" >&2
	exit 1
}

function check_for_file()
{
	if [ ! -e "$1" ]; then
		fail "Missing file: $1"
	fi
}

script_dir=`pwd`

cd "$steamcmd_dir" || fail "Missing $steamcmd_dir directory!"

check_for_file "steamcmd.sh"

clear
# 通过 read 命令提示用户输入
read -p "是否进行更新,请输入 y 或者 n：" input

# 为了避免大小写的问题，将其全部转换成小写处理
input=$(echo "$input" | tr "[A-Z]" "[a-z]")

# 判断用户输入的信息，并给出对应的提示
if [ "$input" = "y" ]; then
    ./steamcmd.sh +force_install_dir "$install_dir" +login anonymous +app_update 343050 validate +quit
fi

clear

#---------------------------存档操作-------------------------------------
while [ 1 ]
do
        clear
        echo "饥荒联机版服务器"
        echo ""
        j=0
        for i in `ls $dontstarve_dir`
        do
                array[$j]="${i}"
                j=`expr $j + 1`
                echo "${j}   ${i}"
        done

        echo ""
        echo "n          新建存档"
        echo "d <number> 删除存档"
	echo "m          模组操作"
        echo ""

        # 通过 read 命令提示用户输入
        read -p "选择存档：" index


        if [[ $index = "n" ]];then
                echo "https://accounts.klei.com/account/info"
                echo "登陆后选择上面菜单的游戏，再点击《饥荒联机版》的游戏服务器"
                echo "添加，配置并下载"
                echo "进入下载文件所在目录命令行"
                echo "输入  scp -r ./[存档目录] root@[你的服务器ip]:/root/.klei/DoNotStarveTogether"
                echo "按下任意键继续"
                read
                clear
                continue

        elif [[ $index =~ ^d.* ]];then
                # 删除存档
                index=`expr ${index#* } - 1`
                name=${array[$index]}
                read -p "确认删除存档${name}？y/n:" input
		
		# 为了避免大小写的问题，将其全部转换成小写处理
                input=$(echo "$input" | tr "[A-Z]" "[a-z]")

                # 判断用户输入的信息，并给出对应的提示
                if [ "$input" = "y" ]; then
                        rm -rf "$dontstarve_dir/$name"
                        echo "删除成功"
                fi

	elif [[ $index == "m" ]];then
		cd $script_dir
		./settingMod.sh "$install_dir/mods"
		continue
        else
                index=`expr $index - 1`
                cluster_name=${array[$index]}
		break
        fi
        sleep 1
        clear
done

#--------------------------结束存档操作----------------------------------
check_for_file "$dontstarve_dir/$cluster_name/cluster.ini"
check_for_file "$dontstarve_dir/$cluster_name/cluster_token.txt"
check_for_file "$dontstarve_dir/$cluster_name/Master/server.ini"
check_for_file "$dontstarve_dir/$cluster_name/Caves/server.ini"

check_for_file "$install_dir/bin64"

cd "$install_dir/bin" || fail
# 如果报错libcurl-gnutls.so.4缺失
# ln -s /usr/lib/libcurl.so.4 $HOME/dontstarvetogether_dedicated_server/bin/lib32/libcurl-gnutls.so.4
run_shared=(./dontstarve_dedicated_server_nullrenderer)
run_shared+=(-console)
run_shared+=(-cluster "$cluster_name")
run_shared+=(-monitor_parent_process $$)

"${run_shared[@]}" -shard Caves  | sed 's/^/Caves:  /' &
"${run_shared[@]}" -shard Master | sed 's/^/Master: /'
