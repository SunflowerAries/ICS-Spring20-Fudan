import zipfile, sys, re, os

pattern = re.compile(r'(^[0-9]*)')

def check(zfile):
    zFile = zipfile.ZipFile(zfile, "r")
    stuId = pattern.match(zfile).group(0)
    print(stuId)
    cwd = os.getcwd()
    for zfile in zFile.namelist():
        zFile.extract(zfile, cwd)
    zFile.close()

    if os.path.isdir(stuId):
        cwd = os.path.join(cwd, stuId)
        cwd = os.path.join(cwd, "Pipeline")
        if os.path.isdir(cwd):
            makefile = os.path.join(cwd, "makefile")
            benchtest = os.path.join(cwd, "benchtest")
            if os.path.isfile(makefile) == False:
                print("添加 makefile")
            elif os.path.isdir(benchtest) == False:
                print("添加 benchtest/")
            else:
                print("应该没啥问题了")
        else:
            print("项目名为 Pipeline")
    else:
        print("解压缩文件中需要包一层 %s/ 文件夹" %(stuId))

if __name__ == '__main__':
    for zfile in os.listdir(os.getcwd()):
        if zfile.find('.zip') != -1:
            check(zfile)
    