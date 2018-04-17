import os
import sys
import re
import codecs
import shutil
import fnmatch
import ftplib
from ftplib import FTP
import time
import configparser


global fileRcFullName
global fileProjFullName
global fileNewVer
global pathExe
global pathProj
#定义全局变量
fileRcFullName = ""
#工程名全路径
fileProjFullName = ""
#新文件版本号
fileNewVer="1.2.0.1"
#生成的文件路径
pathExe=""
#资源文件全路径
pathAbsProj='highrail\\software\\'
projName=r'proj_highRail'
absPathBase=r'workspace'
productName=r'highrail'
defProductDir=r'HighRail'

autoStartFile='autoStart'
#批处理文件名称
nameComplieBat = "vsCompile.bat"

def copytrees(src, dst, symlinks=False):
    names = os.listdir(src)
    if not os.path.isdir(dst):
        os.makedirs(dst)
          
    errors = []
    for name in names:
        srcname = os.path.join(src, name)
        dstname = os.path.join(dst, name)
        try:
            if symlinks and os.path.islink(srcname):
                linkto = os.readlink(srcname)
                os.symlink(linkto, dstname)
            elif os.path.isdir(srcname):
                copytree(srcname, dstname, symlinks)
            else:
                if os.path.isdir(dstname):
                    os.rmdir(dstname)
                elif os.path.isfile(dstname):
                    os.remove(dstname)
                shutil.copy2(srcname, dstname)
            # XXX What about devices, sockets etc.?
        except (IOError, os.error) as why:
            errors.append((srcname, dstname, str(why)))
        # catch the Error from the recursive copytree so that we can
        # continue with other files
        except OSError as err:
            errors.extend(err.args[0])
    try:
        shutil.copystat(src, dst)
    except WindowsError:
        # can't copy file access times on Windows
        pass
    except OSError as why:
        errors.extend((src, dst, str(why)))
    if errors:
        raise Error(errors)

#定义函数，实现自动增加文件版本号功能,判断是不是单号，单号加1，提交，双号跳过，直接编译
def funRepFileVer(filename):
    global fileNewVer
    global pathProj
    #打开文本，告诉解码器是unicode编码
    file_object = codecs.open(filename, 'r', 'utf-16')  
    try:  
        all_the_text = file_object.readlines( )  
    finally:  
        file_object.close( )  
    try:
    #创建一个unicode编码的文件
        unicode_file = codecs.open('unicode_out.txt', 'w', 'utf-16')  
        for each_text in all_the_text:
                match1 = re.match(u'\s*FILEVERSION\s*(\d*),(\d*),(\d*),(\d*)',each_text)
                if match1:
                    verno=int(match1.group(4))+1
                    tt1='%s,%s,%s,%s'%(match1.group(1),match1.group(2),match1.group(3),match1.group(4))
                    tt2='%s,%s,%s,%d'%(match1.group(1),match1.group(2),match1.group(3),verno)
                    strRep=each_text.replace(tt1,tt2)
                    unicode_file.write(strRep)
                    print(r'版本号修改为:%s'%tt2)
                    fileNewVer = tt2
                else:
                    unicode_file.write(each_text)
    finally:  
        unicode_file.close()
    #替换掉原来文件
    shutil.move('unicode_out.txt',filename)

#不修改版本号，只读取

def funReadFileVer(filename):
    global fileNewVer
    global pathProj
    ret = 0
    #打开文本，告诉解码器是unicode编码
    file_object = codecs.open(filename, 'r', 'utf-16')  
    try:  
        all_the_text = file_object.readlines( )  
    finally:  
        file_object.close( )  
    #创建一个unicode编码的文件
    for each_text in all_the_text:
            match1 = re.match(u'\s*FILEVERSION\s*(\d*),(\d*),(\d*),(\d*)',each_text)
            if match1:
                tt1='%s,%s,%s,%s'%(match1.group(1),match1.group(2),match1.group(3),match1.group(4))
                fileNewVer = tt1
                break
    return ret
#从当前目录查找绝对路径
def funInitPara():
    global fileRcFullName
    global fileProjFullName
    global pathExe
    global pathProj
    homedir = os.getcwd()
    print(homedir)
    print(os.path)
    strPattern = r'^.*%s'%absPathBase
  
    strmatch = re.match(strPattern, homedir)
    if strmatch:
        #print(strmatch.group(0))
        fileProjFullName = strmatch.group(0) + "\\" + pathAbsProj + projName + "\\" + projName + ".sln"
        fileRcFullName = strmatch.group(0) + "\\" + pathAbsProj + projName + "\\" + projName + "\\" + projName + ".rc"
        pathProj = strmatch.group(0) + "\\" + pathAbsProj + projName + "\\" + projName + "\\"
        #print(fileProjFullName)
        pathExe = strmatch.group(0) + "\\" + pathAbsProj + projName + "\\" + "execute"
        #拷贝动态库
        if not os.path.exists(pathExe):
            os.mkdir(pathExe)
        copytrees(strmatch.group(0) + "\\" + pathAbsProj + projName + "\\thirdpart\\data\\", pathExe + "\\")
        copytrees(strmatch.group(0) + "\\" + pathAbsProj + projName + "\\thirdpart\\dll", pathExe + "\\")
        shutil.copy(pathExe + "\\initpara.xj", pathExe + "\\initpara.xml")
    #如果buld.log 和 setup.exe存在，则删除
    if os.path.exists('build.log'):
        os.remove('build.log')
    if os.path.exists('Setup.exe'):
        os.remove('Setup.exe')
#编译工程
def compileProj(projName):
    cmdname = r'%s %s'%(nameComplieBat,projName)
    ret = os.system(cmdname)
    if ret==0:
        print("编译成功")
    else:
        print("编译失败")
    return ret
#生成NSIS工程
def funReplace(m):
        strRet = str(m.group());
        mgroup = m.groupdict();
        strRet = strRet.replace(mgroup['productExeName'],projName)
        strRet = strRet.replace(mgroup['productName'],productName)
        strRet = strRet.replace(mgroup['productDir'],defProductDir)
        strRet = strRet.replace(mgroup['productVer'],fileNewVer)
        strRet = strRet.replace(mgroup['productSrcDir'],pathExe)
        #print(strRet)
        return strRet
def nsisBuild():
    arrFiles = []
    nameNsis = r'pachBatch.nsi'
    runFinish = r'autoRun.bat'
    fileSrc = open("templ.nsib",'r')
    fileobj = str(fileSrc.read())
    fileSrc.close();
    #替换掉里面的版本号等
    p1 = re.compile(r'PRODUCT_EXE_NAME\s?"(?P<productExeName>(\w+))"[\d\D]*PRODUCT_NAME\s?"(?P<productName>(\w+))"[\d\D]*PRODUCT_DIR\s?"(?P<productDir>(\w+))"[\d\D]*PRODUCT_VERSION\s?"(?P<productVer>([\w\.]+))"[\d\D]*PRODUCT_SRC_DIR\s?"(?P<productSrcDir>(.+))"')
    fileobj1 = p1.sub(funReplace, fileobj)
    file = open(nameNsis,'w')
    try:
        file.write(fileobj1)
    finally:
        file.close()
    ret = os.system(r'cmd /c "C:\Program Files (x86)\NSIS\makensis.exe" /V4 %s'%nameNsis)
    return ret


_XFER_FILE = 'FILE'  
_XFER_DIR = 'DIR'  
class Xfer(object):  
    ''''' 
    @note: upload local file or dirs recursively to ftp server 
    '''  
    def __init__(self):  
        self.ftp = None  
      
    def __del__(self):  
        pass  
      
    def setFtpParams(self, ip, uname = 'anonymous', pwd = '', cwd = './', port = 21, timeout = 60):          
        self.ip = ip  
        self.uname = uname  
        self.pwd = pwd  
        self.port = port  
        self.timeout = timeout
        self.cwd = cwd
    def initEnv(self):  
        if self.ftp is None:  
            self.ftp = FTP()  
            print('### connect ftp server: %s ...'%self.ip)  
            self.ftp.connect(self.ip, self.port, self.timeout)  
            self.ftp.login(self.uname, self.pwd)   
            print(self.ftp.getwelcome())
            #切换到所要的目录
            try:
                print(self.cwd)
                self.ftp.cwd(self.cwd)
            except ftplib.error_perm:
               #拆分路径字符
                listPath = self.cwd.split('/')
                basePath = r'.'
                for name in listPath:
                    basePath = basePath + '/' + name  
                    self.ftp.mkd(basePath)
                self.ftp.cwd(self.cwd)
            finally:
                print('切换目录成功')
    def clearEnv(self):  
        if self.ftp:  
            self.ftp.close()  
            print('### disconnect ftp server: %s!'%self.ip)   
            self.ftp = None  
      
    def uploadDir(self, localdir='./', remotedir='./'):  
        if not os.path.isdir(localdir):    
            return
        print(remotedir)
        self.ftp.cwd(remotedir)   
        for file in os.listdir(localdir):  
            src = os.path.join(localdir, file)  
            if os.path.isfile(src):  
                self.uploadFile(src, file)  
            elif os.path.isdir(src):  
                try:    
                    self.ftp.mkd(file)    
                except:    
                    sys.stderr.write('the dir is exists %s'%file)  
                self.uploadDir(src, file)  
        self.ftp.cwd('..')  
      
    def uploadFile(self, localpath, remotepath='./'):  
        if not os.path.isfile(localpath):    
            return  
        print('+++ upload %s to %s:%s'%(localpath, self.ip, remotepath) ) 
        self.ftp.storbinary('STOR ' + remotepath, open(localpath, 'rb'))  
      
    def __filetype(self, src):  
        if os.path.isfile(src):  
            index = src.rfind('\\')  
            if index == -1:  
                index = src.rfind('/')                  
            return _XFER_FILE, src[index+1:]  
        elif os.path.isdir(src):  
            return _XFER_DIR, ''          
      
    def upload(self, src):  
        filetype, filename = self.__filetype(src)  
          
        self.initEnv()  
        if filetype == _XFER_DIR:  
            self.srcDir = src              
            self.uploadDir(self.srcDir)  
        elif filetype == _XFER_FILE:  
            self.uploadFile(src, filename)  
        self.clearEnv()   


#FTP上传到服务器
def ftpUpFiles():
    xfer = Xfer()  
    xfer.setFtpParams('ip', 'name', 'password', 'path')  
    xfer.upload('upload')
    shutil.rmtree('upload')
def copyFileToUp():
    if not os.path.exists('upload'):
        os.mkdir('upload')
    #得到当前时间
    ISOTIMEFORMAT='%Y%m%d-%H%M%S'
    strTime =  time.strftime(ISOTIMEFORMAT, time.localtime())
    pathDir = r'upload\%s'%strTime
    if not os.path.exists(pathDir):
        os.mkdir(pathDir)
    if os.path.exists('build.log'):
        shutil.move('build.log', pathDir)
    if os.path.exists('Setup.exe'):
        shutil.move('Setup.exe', pathDir)

if __name__ == '__main__':
    
    funInitPara()
    '''
    config = configparser.ConfigParser()
    config.readfp(open("softver.ini"))
    verno = int(config.get("host","verno"))
    vernos = verno + 1
    config.set("host","verno",r'%d'%vernos)
    config.write(open("softver.ini","w"))
    print(verno)
    if (verno%2):
        #修改版本号
        funRepFileVer(fileRcFullName)
        #修改完版本号后git上传
        strGitCmd = 'gitCmd.bat %s %s'%(pathProj,fileNewVer)
        print(strGitCmd)
        #os.system(strGitCmd)
        
    else:
    '''
    
    funReadFileVer(fileRcFullName)
    print(fileNewVer)
    ret = compileProj(fileProjFullName)
    if ret==0:
        nsisBuild()
        copyFileToUp()
        ftpUpFiles()
    else:
        sys.exit(-1)
    