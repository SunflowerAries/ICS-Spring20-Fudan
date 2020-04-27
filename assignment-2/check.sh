unzip -oq $1
stuId=$(grep -o "^[0-9]*" <<< $1)
if [ ! -d $stuId ]; then
	echo 解压缩文件中需要包一层 $stuId/ 文件夹
else
	cd $stuId
	if [ ! -d Pipeline ]; then
		echo 项目名为 Pipeline
	else
		cd Pipeline
		if [ ! -f makefile ]; then
			echo 添加 makefile
		elif [ ! -d benchtest ]; then
			echo 添加 benchtest
		fi
	fi
fi
