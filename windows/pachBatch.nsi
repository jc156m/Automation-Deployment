;7Z�򿪿հ�
!system '>blank set/p=MSCF<nul'
!packhdr temp.dat 'cmd /c Copy /b temp.dat /b +blank&&del blank'

Var MSG
Var Dialog
Var BGImage  ;������ͼ
Var ImageHandle
Var THImage   ;̾��
Var BCSJ

Var WarningForm

Var btn_in
Var btn_ins

Var lbl_zhuye
Var lbl_biaoti

Var Txt_Browser
Var btn_Browser

Var Checkbox_Reboot
Var Checkbox_RebootLabel
Var Checkbox_Reboot_State

Var Checkbox_SaveXml
Var Checkbox_Label_SaveXml
Var Checkbox_SaveXml_State ;�Ƿ񱣴������ļ�


;---------------------------ȫ�ֱ���ű�Ԥ����ĳ���-----------------------------------------------------'
!AddPluginDir .\Plugins
!AddIncludeDir .\Include
!define PRODUCT_EXE_NAME "proj_highRail_2"
!define PRODUCT_NAME "����3C����"
!define PRODUCT_DIR "HighRail3c"
!define PRODUCT_VERSION "1,1,0,1"
!define PRODUCT_SRC_DIR "D:\Jenkins\workspace\highrail3c\software\proj_highRail_2\execute"
!define PRODUCT_PUBLISHER "hafl.com, Inc."
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_EXE_NAME}.exe" ;�������޸�
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_RUN_KEY "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"


ShowInstDetails nevershow
ShowUninstDetails nevershow

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "Setup.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_DIR}"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"

;��װͼ���·������
!define MUI_ICON "Icon\BaiduYun.ico"
;ж��ͼ���·������
!define MUI_UNICON "Icon\BaiduYun.ico"

;ʹ�õ�UI
!define MUI_UI "UI\mod.exe"

SetCompressor lzma
SetCompress force
XPStyle on

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI2.nsh"
!include "WinCore.nsh"
!include "nsWindows.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"

!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit

;�Զ���ҳ��
Page custom Page.1
Page custom Page.2 Page.2leave

!define MUI_PAGE_CUSTOMFUNCTION_SHOW InstFilesPageShow
!insertmacro MUI_PAGE_INSTFILES

Page custom Page.3
Page custom Page.4

;��װж�ع���ҳ��
UninstPage custom un.Page.5 un.Page.5leave
UninstPage instfiles un.InstFiles.PRO un.InstFiles.Show
UninstPage custom un.Page.6 
UninstPage custom un.Page.7


; ��װ�����������������
!insertmacro MUI_LANGUAGE "SimpChinese"

;-----------------------------------��ʼ��������------------------------------

Function .onInit
	InitPluginsDir
	
	;���������ֹ�ظ�����
	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "Temp") i .r1 ?e'
	Pop $R0
	StrCmp $R0 0 +3
    MessageBox MB_OK|MB_ICONEXCLAMATION "�Ѿ���һ����װ������������!" /SD IDYES IDYES 0
    Abort
	call CloseProgram
	StrCpy $Checkbox_Reboot_State 1
	StrCpy $Checkbox_SaveXml_State 1
	File `/oname=$PLUGINSDIR\bg.bmp` `images\bdyun.bmp`
	File `/oname=$PLUGINSDIR\mgbg.bmp` `images\Message.bmp`
    File `/ONAME=$PLUGINSDIR\BeiJing.bmp` `images\BeiJing.bmp`
    File `/oname=$PLUGINSDIR\btn_clos.bmp` `images\clos.bmp`
    File `/oname=$PLUGINSDIR\btn_mini.bmp` `images\mini.bmp`
    File `/oname=$PLUGINSDIR\btn_in.bmp` `images\in.bmp`
    File `/oname=$PLUGINSDIR\btn_btn.bmp` `images\btn.bmp`
    File `/oname=$PLUGINSDIR\TanHao.bmp` `images\TanHao.bmp`
	;������Ƥ��
	File `/oname=$PLUGINSDIR\Progress.bmp` `images\Progress.bmp`
  	File `/oname=$PLUGINSDIR\ProgressBar.bmp` `images\ProgressBar.bmp`
	
	SkinBtn::Init "$PLUGINSDIR\btn_btn.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_in.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_mini.bmp"
	SkinBtn::Init "$PLUGINSDIR\btn_clos.bmp"
FunctionEnd

Function onGUIInit
	;�����߿�
    System::Call `user32::SetWindowLong(i$HWNDPARENT,i ${GWL_STYLE},0x9480084C) i.R0`
	;����һЩ���пؼ�
    GetDlgItem $0 $HWNDPARENT 1034
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1035
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1036
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1037
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1038
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1039
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1256
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1028
    ShowWindow $0 ${SW_HIDE}
	${NSW_SetWindowSize} $HWNDPARENT 498 373 ;�ı��������С
    System::Call User32::GetDesktopWindow()i.R0
	;Բ��
    System::Alloc 16
  	System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  	System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  	IntOp $R3 $R3 - $R1
  	IntOp $R4 $R4 - $R2
  	System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i4,i4)i.r0
  	System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  	System::Free $R0
		Call UninstallSoft
FunctionEnd

;�����ޱ߿��ƶ�
Function onGUICallback
  ${If} $MSG = ${WM_LBUTTONDOWN}
    SendMessage $HWNDPARENT ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd

;�����Ի����ƶ�
Function onWarningGUICallback
  ${If} $MSG = ${WM_LBUTTONDOWN}
    SendMessage $WarningForm ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd

;����Ƿ��г���������
Function CloseProgram
	KillProcDLL::KillProc "${PRODUCT_EXE_NAME}.exe"
	KillProcDLL::KillProc "mediaServer.exe"
	KillProcDLL::KillProc "rtspserver.exe"
	KillProcDLL::KillProc "mkvfile.exe"
	KillProcDLL::KillProc "alarmsleep.exe"
	KillProcDLL::KillProc "SoftDog.exe"
;  ${nsProcess::FindProcess} ${APPEXENAME} $R0  
;  ${If} $R0 == "0"  
        # it's running  
;        MessageBox MB_OK "��ĳ����޷��Զ��رգ����ȹر�${APPNAME}������������װж�س���!"  
;        Quit  
;  ${EndIf}
FunctionEnd

Function Page.1

    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1990
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1991
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1992
    ShowWindow $0 ${SW_HIDE}
    
    nsDialogs::Create 1044
    Pop $0
    ${If} $0 == error
        Abort
    ${EndIf}
    SetCtlColors $0 ""  transparent ;�������͸��

    ${NSW_SetWindowSize} $0 498 373 ;�ı�Page��С

		;XXX��װ��
    ${NSD_CreateLabel} 1u 130u 493U 18u "��ӭʹ��${PRODUCT_NAME} ${PRODUCT_VERSION}��װ��"
    Pop $lbl_zhuye
    SetCtlColors $lbl_zhuye "" transparent ;�������͸��
    CreateFont $1 "����" "11" "800"
    SendMessage $lbl_zhuye ${WM_SETFONT} $1 0
    ${NSD_AddStyle} $lbl_zhuye ${ES_CENTER}

		;��������
    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} ${PRODUCT_VERSION}��װ"
    Pop $lbl_biaoti
    ;SetCtlColors $lbl_biaoti "" 0xFFFFFF ;��ɫ
    SetCtlColors $lbl_biaoti "666666"  transparent ;�������͸��

    ;�Զ��尲װ��ť
    ${NSD_CreateButton} 120u 185u 136 32 "�Զ��尲װ"
    Pop $btn_ins
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_in.bmp $btn_ins
    SetCtlColors $btn_ins "808080"  transparent ;�������͸��
    GetFunctionAddress $3 onClickins
    SkinBtn::onClick $btn_ins $3

    ;���ٰ�װ��ť
    ${NSD_CreateButton} 120u 153u 136 32 "���ٰ�װ(�Ƽ�)"
    Pop $btn_in
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_in.bmp $btn_in
    SetCtlColors $btn_in "808080"  transparent ;�������͸��
    GetFunctionAddress $3 onClickin
    SkinBtn::onClick $btn_in $3


		;��������
    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} ${PRODUCT_VERSION}��װ"
    Pop $lbl_biaoti
    ;SetCtlColors $lbl_biaoti "" 0xFFFFFF ;��ɫ
    SetCtlColors $lbl_biaoti "666666"  transparent ;�������͸��
    
    ;��С����ť
    ${NSD_CreateButton} 434 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $0
    GetFunctionAddress $3 onClickmini
    SkinBtn::onClick $0 $3

    ;�رհ�ť
    ${NSD_CreateButton} 465 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $0
    GetFunctionAddress $3 MessgesboxPage
    SkinBtn::onClick $0 $3

    ;��������ͼ
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\bg.bmp $ImageHandle

    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $BGImage $0 ;�����ޱ߿����ƶ�
    nsDialogs::Show
    ${NSD_FreeImage} $ImageHandle
FunctionEnd
;------------------
Function Page.2
	GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1990
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1991
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1992
    ShowWindow $0 ${SW_HIDE}
	
	nsDialogs::Create 1044
    Pop $0
    ${If} $0 == error
        Abort
    ${EndIf}
    SetCtlColors $0 ""  transparent ;�������͸��

    ${NSW_SetWindowSize} $0 498 373 ;�ı�Page��С

    ;��װ��ť
    ${NSD_CreateButton} 416U 339U 72U 24U "��װ"
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_BTN.bmp $0
    GetFunctionAddress $3 onClickinst
    SkinBtn::onClick $0 $3

		;��������
    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} ��װ"
    Pop $lbl_biaoti
    ;SetCtlColors $lbl_biaoti "" 0xFFFFFF ;��ɫ
    SetCtlColors $lbl_biaoti "666666"  transparent ;�������͸��


		;·��ѡ��
;    ${NSD_CreateLabel} 36 110u 130 13u "ѡ�������"
;    Pop $0
;    SetCtlColors $0 ""  transparent ;�������͸��
;    CreateFont $1 "����" "11" "800"
;    SendMessage $0 ${WM_SETFONT} $1 0

		;·��ѡ��
    ${NSD_CreateLabel} 36 90 130u 12u "��װĿ¼��"
    Pop $0
    SetCtlColors $0 ""  transparent ;�������͸��
   ; CreateFont $1 "����" "11" "800"
   ; SendMessage $3 ${WM_SETFONT} $1 0
   
   ;��С����ť
    ${NSD_CreateButton} 434 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $0
    GetFunctionAddress $3 onClickmini
    SkinBtn::onClick $0 $3

    ;�رհ�ť
    ${NSD_CreateButton} 465 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $0
    GetFunctionAddress $3 MessgesboxPage
    SkinBtn::onClick $0 $3
    
		;������װĿ¼�����ı���
  	${NSD_CreateText} 36 120 350 24 $INSTDIR
		Pop $Txt_Browser
    CreateFont $1 "tahoma" "10" "500"
    SendMessage $Txt_Browser ${WM_SETFONT} $1 1
		;ShowWindow $Txt_Browser ${SW_HIDE}


    ;��������·���ļ��а�ť
    ${NSD_CreateButton} 395U 120U 72U 16u  "���"
		Pop $btn_Browser
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $btn_Browser
		GetFunctionAddress $3 onButtonClickSelectPath
    SkinBtn::onClick $btn_Browser $3
		;ShowWindow $btn_Browser ${SW_HIDE}
    
    ;��������ͼ
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\beijing.bmp $ImageHandle

    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $BGImage $0 ;�����ޱ߿����ƶ�
    nsDialogs::Show
    ${NSD_FreeImage} $ImageHandle
	
FunctionEnd
;------------------
Function Page.2leave

FunctionEnd
;-------------------
Function  InstFilesPageShow
	FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $1 $R2 1027
    ShowWindow $1 ${SW_HIDE}


	File '/oname=$PLUGINSDIR\Slides.dat' 'nsisSlideShow\Slides.dat'
	File '/oname=$PLUGINSDIR\Play1.png' 'nsisSlideShow\Play1.png'
	File '/oname=$PLUGINSDIR\Play2.png' 'nsisSlideShow\Play2.png'
	File '/oname=$PLUGINSDIR\Play3.png' 'nsisSlideShow\Play3.png'
	
	;�Զ������������ɫ��ʽ
		;ȡ��������windows ��ʽ�����񣬸�Ϊ�����Ѷ������ɫ
;		GetDlgItem $2 $R2 1004
;		System::Call UxTheme::SetWindowTheme(i,w,w)i(r2, n, n)
		;SendMessage $2 ${PBM_SETBARCOLOR} 0 0x339a00 ;���ý�����ǰ��ɫ
		;SendMessage $2 ${PBM_SETBKCOLOR} 0 0xa4a4a4  ;���ý���������ɫ
		
	GetDlgItem $R0 $R2 1004  ;���ý�����λ��
    System::Call "user32::MoveWindow(i R0, i 30, i 100, i 440, i 12) i r2"


    StrCpy $R0 $R2 ;�ı�ҳ���С,��Ȼ��ͼ����ȫҳ
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 498, i 373) i r2"
    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $R0 $0 ;�����ޱ߿����ƶ�
    
    GetDlgItem $R1 $R2 1006  ;��ȡ1006�ؼ�������ɫ���ı�λ��
    SetCtlColors $R1 ""  F6F6F6 ;�������F6F6F6,ע����ɫ������Ϊ͸���������ص�
    System::Call "user32::MoveWindow(i R1, i 30, i 82, i 440, i 12) i r2"

    GetDlgItem $R3 $R2 1990  ;��ȡ1006�ؼ�������ɫ���ı�λ��
    System::Call "user32::MoveWindow(i R3, i 434, i 1, i 31, i 18) i r2"
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $R3
		GetFunctionAddress $3 onClickmini
    SkinBtn::onClick $R3 $3
    ;SetCtlColors $R1 ""  F6F6F6 ;�������F6F6F6,ע����ɫ������Ϊ͸���������ص�

    GetDlgItem $R4 $R2 1991  ;��ȡ1006�ؼ�������ɫ���ı�λ��
    System::Call "user32::MoveWindow(i R4, i 465, i 1, i 31, i 18) i r2" ;�ı�λ��465, 1, 31, 18
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $R4
		GetFunctionAddress $3 onClickclos
    SkinBtn::onClick $R4 $3
    EnableWindow $R4 0  ;��ֹ0Ϊ��ֹ
    
    GetDlgItem $R5 $R2 1992  ;��ȡ1006�ؼ�������ɫ���ı�λ��
    System::Call "user32::MoveWindow(i R5, i 416, i 339, i 72, i 24) i r2"
    ${NSD_SetText} $R5 "��װ"
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $R5
		;GetFunctionAddress $3 onClickins
    SkinBtn::onClick $R5 $3
    EnableWindow $R5 0

    GetDlgItem $R7 $R2 1993  ;��ȡ1993�ؼ�������ɫ���ı�λ��
    SetCtlColors $R7 "666666"  transparent ;
    System::Call "user32::MoveWindow(i R7, i 38, i 12, i 150, i 12) i r2"
    ${NSD_SetText} $R7 "${PRODUCT_NAME} ${PRODUCT_VERSION}��װ" ;����ĳ���ؼ��� text �ı�


    GetDlgItem $R8 $R2 1016  ;��ȡ1006�ؼ�������ɫ���ı�λ��
    SetCtlColors $R8 ""  F6F6F6 ;�������F6F6F6,ע����ɫ������Ϊ͸���������ص�
    System::Call "user32::MoveWindow(i R8, i 30, i 120, i 440, i 180) i r2"
    
    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $R0 $R2 1995
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 498, i 373) i r2"
    ${NSD_SetImage} $R0 $PLUGINSDIR\beijing.bmp $ImageHandle

		;�����Ǹ���������ͼ
    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $5 $R2 1004
	SkinProgress::Set $5 "$PLUGINSDIR\Progress.bmp" "$PLUGINSDIR\ProgressBar.bmp"
FunctionEnd

;-----------------------
Function Page.3
	GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}


    nsDialogs::Create 1044
    Pop $0
    ${If} $0 == error
        Abort
    ${EndIf}
    SetCtlColors $0 ""  transparent ;�������͸��

    ${NSW_SetWindowSize} $0 498 373 ;�ı�Page��С


    ${NSD_CreateLabel} 10% 25% 250u 15u '"${PRODUCT_NAME} ${PRODUCT_VERSION}"��װ��ɣ�'
    Pop $2
    SetCtlColors $2 ""  transparent ;�������͸��
    CreateFont $1 "����" "11" "700"
    SendMessage $2 ${WM_SETFONT} $1 0

    ${NSD_CreateLabel} 10% 31% 250u 12u "${PRODUCT_NAME} ${PRODUCT_VERSION}�Ѱ�װ�����ĵ����У��뵥������ɡ���"
    Pop $2
    SetCtlColors $2 666666  transparent ;�������͸��

		;��������
    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} ${PRODUCT_VERSION}��װ"
    Pop $lbl_biaoti
    ;SetCtlColors $lbl_biaoti "" 0xFFFFFF ;��ɫ
    SetCtlColors $lbl_biaoti "666666"  transparent ;�������͸��

	#------------------------------------------
#��ѡ��1
#------------------------------------------    
    ${NSD_CreateCheckbox} 56 130u 12u 12u ""
    Pop $Checkbox_Reboot
    SetCtlColors $Checkbox_Reboot "" "f7f7f7"
	${NSD_SetState} $Checkbox_Reboot $Checkbox_Reboot_State

	${NSD_CreateLabel} 56u 131u 100u 12u "��ɺ����������"
	Pop $Checkbox_RebootLabel
    SetCtlColors $Checkbox_RebootLabel ""  transparent ;ǰ��ɫ,�������͸��
    ${NSD_OnClick} $Checkbox_RebootLabel onCheckbox_Reboot
#------------------------------------------

    ;��ɰ�ť
    ${NSD_CreateButton} 416 339 72 24 "���"
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_BTN.bmp $0
    GetFunctionAddress $3 onClickend
    SkinBtn::onClick $0 $3

    ;��С����ť
    ${NSD_CreateButton} 434 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $0
    GetFunctionAddress $3 onClickmini
    SkinBtn::onClick $0 $3

    ;�رհ�ť
    ${NSD_CreateButton} 465 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $0
    GetFunctionAddress $3 MessgesboxPage
    SkinBtn::onClick $0 $3
    EnableWindow $0 0

    ;��������ͼ
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\beijing.bmp $ImageHandle


    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $BGImage $0 ;�����ޱ߿����ƶ�
    nsDialogs::Show
	
    ${NSD_FreeImage} $ImageHandle
FunctionEnd

Function Page.3leave
	MessageBox MB_OK "mama1"
FunctionEnd

;------------------------
Function Page.4

FunctionEnd

Function MessgesboxPage
	IsWindow $WarningForm Create_End
	!define Style ${WS_VISIBLE}|${WS_OVERLAPPEDWINDOW}
	${NSW_CreateWindowEx} $WarningForm $hwndparent ${ExStyle} ${Style} "" 1018

	;${NSW_SetWindowSize} $WarningForm 382 202
	System::Call "user32::MoveWindow(i $WarningForm, i 0, i 0, i 382, i 202) i r2"
	EnableWindow $hwndparent 0
  ;SetCtlColors $hwndparent ""  transparent ;�������͸��
	System::Call `user32::SetWindowLong(i$WarningForm,i${GWL_STYLE},0x9480084C)i.R0`

	${NSW_CreateButton} 225 169 72 24 'ȷ��'
	Pop $1
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $1
  GetFunctionAddress $3 onClickclos
  SkinBtn::onClick $1 $3 

	${NSW_CreateButton} 303 169 72 24 'ȡ��'
	Pop $1
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $1
  GetFunctionAddress $3 OnClickQuitCancel
  SkinBtn::onClick $1 $3

  ;�رհ�ť
  ${NSW_CreateButton} 350 1 31 18 ""
	Pop $1
  SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $1
  GetFunctionAddress $3 OnClickQuitCancel
  SkinBtn::onClick $1 $3

 	;�˳���ʾ
  ${NSW_CreateLabel} 17% 95 170u 9u "ȷ��Ҫ�˳�${PRODUCT_NAME}��װ��"
  Pop $R3
  ;SetCtlColors $R2 "" 0xFFFFFF ;��ɫ
  SetCtlColors $R3 "636363"  transparent ;�������͸��

 	;���Ͻ�����
  ${NSW_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME}"
  Pop $R2
  ;SetCtlColors $R2 "" 0xFFFFFF ;��ɫ
  SetCtlColors $R2 "666666"  transparent ;�������͸��

	;̾��
	${NSW_CreateBitmap} 10% 93 16u 16u ""
  Pop $THImage
  ${NSW_SetImage} $THImage $PLUGINSDIR\TanHao.bmp $ImageHandle

	;����ͼ
	${NSW_CreateBitmap} 0 0 380u 202u ""
  Pop $BGImage
  ${NSW_SetImage} $BGImage $PLUGINSDIR\mgbg.bmp $ImageHandle

	GetFunctionAddress $0 onWarningGUICallback
	WndProc::onCallback $BGImage $0 ;�����ޱ߿����ƶ�
;	WndProc::onCallback $THImage $0
;	WndProc::onCallback $R2 $0
;	WndProc::onCallback $R3 $0

  ${NSW_CenterWindow} $WarningForm $hwndparent
	${NSW_Show}
	Create_End:
  ShowWindow $WarningForm ${SW_SHOW}
FunctionEnd

/* Section test
    ;�������ʾ��
    killer::IsProcessRunning "QQ.exe"
    Pop $R0
    MessageBox MB_OK "�Ƿ������У�$R0"
    
    killer::KillProcess "QQ.exe"
SectionEnd */

Section MainStep
	SetDetailsPrint textonly
	DetailPrint "���ڰ�װ${PRODUCT_NAME}..."
	SetDetailsPrint None ;����ʾ��Ϣ
	nsisSlideshow::Show /NOUNLOAD /auto=$PLUGINSDIR\Slides.dat
	SetOutPath $INSTDIR
	SetOverwrite try
	File /r "${PRODUCT_SRC_DIR}\*.*"
	
	CreateDirectory '$SMPROGRAMS\${PRODUCT_NAME}'
	CreateShortCut '$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_EXE_NAME}.lnk' '$INSTDIR\SoftDog.exe'
	CreateShortCut '$DESKTOP\${PRODUCT_NAME}.lnk' '$INSTDIR\SoftDog.exe'
	nsisSlideshow::Stop
	SetAutoClose true
SectionEnd

Section -AdditionalIcons
  CreateShortCut '$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk' "$INSTDIR\uninst.exe"
SectionEnd

#----------------------------------------------
#�����������ж�س�����Ϣ ,����ľ����÷����鿴����  D.2 ���ж����Ϣ�����/ɾ���������  �����ڰ����������ؼ��ʣ��磺DisplayName
#----------------------------------------------
Section -Post
	WriteUninstaller "$INSTDIR\uninst.exe" ;���������ж�س���
	WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" '$INSTDIR\${PRODUCT_EXE_NAME}.exe' ;��Щ�������޸ĳ��Լ��ĳ���
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" '$INSTDIR\${PRODUCT_EXE_NAME}.exe' ;��Щ�������޸ĳ��Լ��ĳ���
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"

	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_RUN_KEY}" "${PRODUCT_EXE_NAME}" '$INSTDIR\SoftDog.exe'
	;����ָ���������
	IfFileExists $TEMP\initpara.xml 0 +2
		CopyFiles $TEMP\initpara.xml $INSTDIR
		Delete $TEMP\initpara.xml
SectionEnd

;����ҳ����ת������
Function RelGotoPage
	IntCmp $R9 0 0 Move Move
    StrCmp $R9 "X" 0 Move
      StrCpy $R9 "120"
	Move:
		SendMessage $HWNDPARENT "0x408" "$R9" ""
FunctionEnd

Function onClickins
	StrCpy $R9 1 ;Goto the next page
	Call RelGotoPage
	Abort
FunctionEnd

Function onClickin
	StrCpy $R9 2 ;Goto the next page
	Call RelGotoPage
	Abort
FunctionEnd

Function onClickinst
	${NSD_GetText} $Txt_Browser  $R0  ;������õİ�װ·��

  ;�ж�Ŀ¼�Ƿ���ȷ
	ClearErrors
	CreateDirectory "$R0"
	IfErrors 0 +3
	MessageBox MB_ICONINFORMATION|MB_OK "'$R0' ��װĿ¼�����ڣ����������á�"
	Return

	StrCpy $INSTDIR  $R0  ;���氲װ·��

	;������һҳ�� $R9��NavigationGotoPage ������Ҫ����ת��������
	StrCpy $R9 1
	call RelGotoPage
FunctionEnd

#------------------------------------------
#��С������
#------------------------------------------
Function onClickmini
System::Call user32::CloseWindow(i$HWNDPARENT) ;��С��
FunctionEnd

#------------------------------------------
#�رմ���
#------------------------------------------
Function onClickclos
SendMessage $hwndparent ${WM_CLOSE} 0 0  ;�ر�
FunctionEnd

Function OnClickQuitCancel
  ${NSW_DestroyWindow} $WarningForm
  EnableWindow $hwndparent 1
  BringToFront
FunctionEnd

#--------------------------------------------------------
# ·��ѡ��ť�¼�����Windowsϵͳ�Դ���Ŀ¼ѡ��Ի���
#--------------------------------------------------------
Function onButtonClickSelectPath
	${NSD_GetText} $Txt_Browser  $0
   nsDialogs::SelectFolderDialog  "��ѡ�� ${PRODUCT_NAME} ��װĿ¼��"  "$0"
   Pop $0
   ${IfNot} $0 == error
			${NSD_SetText} $Txt_Browser  $0
	${EndIf}
FunctionEnd


#-------------------------------------------------
# ��һ��Lable�����ͬ��CheckBox״̬������
#-------------------------------------------------
Function onCheckbox_Reboot

	${NSD_GetState} $Checkbox_Reboot $0

	${If} $0 == ${BST_CHECKED}
			 ${NSD_SetState} $Checkbox_Reboot ${BST_UNCHECKED}
	${Else}
			 ${NSD_SetState} $Checkbox_Reboot ${BST_CHECKED}
	${EndIf}

FunctionEnd

;���ҳ����ɰ�ť
Function onClickend
	SendMessage $hwndparent ${WM_CLOSE} 0 0
	${NSD_GetState} $Checkbox_Reboot $Checkbox_Reboot_State
	
	${If} $Checkbox_Reboot_State == 1
		;MessageBox MB_ICONINFORMATION|MB_OK "��Ҫ׼�������ˣ��Ͻ���ʰ�һ�" 
		Reboot
	${Else}
		;MessageBox MB_OK "mama"
	${EndIf}
FunctionEnd

#----------------------------------------------
#ִ��ж������
#----------------------------------------------
Function UninstallSoft
	ReadRegStr $R0 HKLM \
  "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
  "UninstallString"
  ${GetParent} "$R0" $R1
  StrCmp $R0 "" done
  IfFileExists $R0 uninst
	Goto done
;����ж�س���
uninst:
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_TOPMOST "ϵͳ�Ѵ���${PRODUCT_NAME}���Ƿ�ж�أ�" IDYES +2
  Goto done
  ExecWait "$R0 /S _?=$R1" ;����$R0Ϊ��ȡ����ж�س������ƣ� /S�Ǿ�Ĭж�ز���ʹ��NSIS���ɵ�ж�س������Ҫ���� _? ���ܵȴ�ж�ء�$R1�����λ��
  IfFileExists "$R1" dir ;��� $R1���λ�� �����ļ�����ת�� DIR: ɾ������������ļ�
  Goto done
dir: ;����ļ��д���
	;Delete "$R1\*.*" ;��ɾ�����������ļ�,�����ʹ��

done:
FunctionEnd

;--------------------------�������ִ����Ϻ��Ƿ�����
Section -SecReboot
	
SectionEnd

/******************************
 *  �����ǰ�װ�����ж�ز���  *
 ******************************/

Section Uninstall
	SetDetailsPrint textonly
	DetailPrint "����ж��${PRODUCT_NAME}..."
	;����Ƿ񱣴�����
	${If} $Checkbox_SaveXml_State == 1
		CopyFiles $INSTDIR\initpara.xml $TEMP
	${EndIf}
	;Delete "$INSTDIR\uninst.exe"
  
  SetShellVarContext all
  Delete '$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk'
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"

  RMDir '$SMPROGRAMS\${PRODUCT_NAME}'
  
  SetShellVarContext current
  Delete '$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk'
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"

  RMDir '$SMPROGRAMS\${PRODUCT_NAME}'
  
  
  RMDir /r  "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  DeleteRegValue ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_RUN_KEY}" "${PRODUCT_EXE_NAME}"
  SetAutoClose true
SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#

Function un.Page.5
	GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}

    nsDialogs::Create 1044
    Pop $0
    ${If} $0 == error
        Abort
    ${EndIf}
    SetCtlColors $0 ""  transparent ;�������͸��

    ${NSW_SetWindowSize} $0 498 373 ;�ı䴰���С


    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} ж��"
    Pop $2
    SetCtlColors $2 666666  transparent ;�������͸��

    ${NSD_CreateLabel} 10% 25% 250u 15u '"��ӭʹ��${PRODUCT_NAME}"ж���򵼣�'
    Pop $2
    SetCtlColors $2 ""  transparent ;�������͸��
    CreateFont $1 "����" "11" "700"
    SendMessage $2 ${WM_SETFONT} $1 0

    ${NSD_CreateLabel} 10% 31% 280u 25u "����򵼽�ָ����Ӽ�����Ƴ�${PRODUCT_NAME}��������ж�ء���ť��ʼж�ء�"
    Pop $2
    SetCtlColors $2 "666666"  transparent ;�������͸��

    ;����ȡ����ť
    ${NSD_CreateButton} 416 339 72 24 "ȡ��"
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $0
    GetFunctionAddress $3 un.onClickclos
    SkinBtn::onClick $0 $3

    ${NSD_CreateButton} 338 339 72 24 "ж��"
    Pop $R0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $R0
    GetFunctionAddress $3 un.onClickins
    SkinBtn::onClick $R0 $3

    ;��С����ť
    ${NSD_CreateButton} 434 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $0
    GetFunctionAddress $3 un.onClickmini
    SkinBtn::onClick $0 $3

    ;�رհ�ť
    ${NSD_CreateButton} 465 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $0
    GetFunctionAddress $3 un.onClickclos
    SkinBtn::onClick $0 $3

		#��ѡ�� �Ƿ񱣴������ļ�
#------------------------------------------    
    ${NSD_CreateCheckbox} 56 130u 12u 12u ""
    Pop $Checkbox_SaveXml
    SetCtlColors $Checkbox_SaveXml "" "f7f7f7"
	${NSD_SetState} $Checkbox_SaveXml $Checkbox_SaveXml_State

	${NSD_CreateLabel} 56u 131u 100u 12u "���������ļ�"
	Pop $Checkbox_Label_SaveXml
    SetCtlColors $Checkbox_Label_SaveXml ""  transparent ;ǰ��ɫ,�������͸��
    ${NSD_OnClick} $Checkbox_Label_SaveXml un.onCheckbox_saveXml
#------------------------------------------
	
    ;��������ͼ
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\beijing.bmp $ImageHandle


    GetFunctionAddress $0 un.onGUICallback
    WndProc::onCallback $BGImage $0 ;�����ޱ߿����ƶ�
    nsDialogs::Show

    ${NSD_FreeImage} $ImageHandle
FunctionEnd

Function un.Page.5leave
	${NSD_GetState} $Checkbox_SaveXml $Checkbox_SaveXml_State
FunctionEnd

Function un.InstFiles.PRO

FunctionEnd

Function un.InstFiles.Show
	FindWindow $BCSJ "#32770" "" $HWNDPARENT
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $1 $BCSJ 1027
    ShowWindow $1 ${SW_HIDE}

    GetDlgItem $R0 $BCSJ 1004  ;���ý�����λ��
    System::Call "user32::MoveWindow(i R0, i 30, i 100, i 440, i 12) i r2"


    StrCpy $R0 $BCSJ ;�ı�ҳ���С,��Ȼ��ͼ����ȫҳ
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 498, i 373) i r2"
    GetFunctionAddress $0 un.onGUICallback
    WndProc::onCallback $R0 $0 ;�����ޱ߿����ƶ�

    GetDlgItem $R1 $BCSJ 1006  ;��ȡ1006�ؼ�������ɫ���ı�λ��
    SetCtlColors $R1 ""  F6F6F6 ;�������F6F6F6,ע����ɫ������Ϊ͸���������ص�
    System::Call "user32::MoveWindow(i R1, i 30, i 82, i 440, i 12) i r2"

    GetDlgItem $R3 $BCSJ 1990  ;��ȡ1006�ؼ�������ɫ���ı�λ��
    System::Call "user32::MoveWindow(i R3, i 434, i 1, i 31, i 18) i r2"
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $R3
		GetFunctionAddress $3 un.onClickmini
    SkinBtn::onClick $R3 $3
    ;SetCtlColors $R1 ""  F6F6F6 ;�������F6F6F6,ע����ɫ������Ϊ͸���������ص�

    GetDlgItem $R4 $BCSJ 1991  ;��ȡ1006�ؼ�������ɫ���ı�λ��
    System::Call "user32::MoveWindow(i R4, i 465, i 1, i 31, i 18) i r2" ;�ı�λ��465, 1, 31, 18
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $R4
		GetFunctionAddress $3 un.onClickclos
    SkinBtn::onClick $R4 $3
    EnableWindow $R4 0  ;��ֹ0Ϊ��ֹ

    GetDlgItem $R5 $BCSJ 1992  ;��ȡ1006�ؼ�������ɫ���ı�λ��
    System::Call "user32::MoveWindow(i R5, i 416, i 339, i 72, i 24) i r2"
    ${NSD_SetText} $R5 "��װ"
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $R5
		;GetFunctionAddress $3 un.onClickins
    SkinBtn::onClick $R5 $3
    EnableWindow $R5 0

    GetDlgItem $R7 $BCSJ 1993  ;��ȡ1993�ؼ�������ɫ���ı�λ��
    SetCtlColors $R7 "666666"  transparent ;
    System::Call "user32::MoveWindow(i R7, i 38, i 12, i 150, i 12) i r2"
    ${NSD_SetText} $R7 "${PRODUCT_NAME} ��װ" ;����ĳ���ؼ��� text �ı�


    GetDlgItem $R8 $BCSJ 1016  ;��ȡ1006�ؼ�������ɫ���ı�λ��
    SetCtlColors $R8 ""  F6F6F6 ;�������F6F6F6,ע����ɫ������Ϊ͸���������ص�
    System::Call "user32::MoveWindow(i R8, i 30, i 120, i 440, i 180) i r2"

    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $R0 $R2 1995
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 498, i 373) i r2"
    ${NSD_SetImage} $R0 $PLUGINSDIR\beijing.bmp $ImageHandle

		;�����Ǹ���������ͼ
    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $5 $R2 1004
	  SkinProgress::Set $5 "$PLUGINSDIR\Progress.bmp" "$PLUGINSDIR\ProgressBar.bmp"
FunctionEnd

Function un.Page.6
	GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
    
    nsDialogs::Create 1044
    Pop $0
    ${If} $0 == error
        Abort
    ${EndIf}
    SetCtlColors $0 ""  transparent ;�������͸��

    ${NSW_SetWindowSize} $0 498 373 ;�ı䴰���С

    ${NSD_CreateLabel} 25u 8u 150u 9u "${PRODUCT_NAME} ж��"
    Pop $2
    SetCtlColors $2 666666  transparent ;�������͸��

    ${NSD_CreateLabel} 10% 25% 250u 15u '"${PRODUCT_NAME}"ж����ɣ�'
    Pop $2
    SetCtlColors $2 ""  transparent ;�������͸��
    CreateFont $1 "����" "11" "700"
    SendMessage $2 ${WM_SETFONT} $1 0

    ${NSD_CreateLabel} 10% 31% 250u 12u "${PRODUCT_NAME}�Ѵ����ĵ����гɹ��Ƴ����뵥������ɡ���"
    Pop $2
    SetCtlColors $2 666666  transparent ;�������͸��
	
    ;��ɰ�ť
    ${NSD_CreateButton} 416 339 72 24 "���"
    Pop $2
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_btn.bmp $2
    GetFunctionAddress $3 un.onClickend
    SkinBtn::onClick $2 $3

    ;��С����ť
    ${NSD_CreateButton} 434 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_mini.bmp $0
    GetFunctionAddress $3 un.onClickmini
    SkinBtn::onClick $0 $3

    ;�رհ�ť
    ${NSD_CreateButton} 465 1 31 18 ""
    Pop $0
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_clos.bmp $0
    GetFunctionAddress $3 un.onClickclos
    SkinBtn::onClick $0 $3
    EnableWindow $0 0

    ;��������ͼ
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\beijing.bmp $ImageHandle
    GetFunctionAddress $0 un.onGUICallback
    WndProc::onCallback $BGImage $0 ;�����ޱ߿����ƶ�
    nsDialogs::Show
FunctionEnd

Function un.Page.7

FunctionEnd

Function un.onInit
	InitPluginsDir
	StrCpy $Checkbox_SaveXml_State 1
    File `/ONAME=$PLUGINSDIR\BeiJing.bmp` `images\BeiJing.bmp`
    File `/oname=$PLUGINSDIR\btn_clos.bmp` `images\clos.bmp`
    File `/oname=$PLUGINSDIR\btn_mini.bmp` `images\mini.bmp`
    File `/oname=$PLUGINSDIR\btn_in.bmp` `images\in.bmp`
    File `/oname=$PLUGINSDIR\btn_btn.bmp` `images\btn.bmp`

		;������Ƥ��
	  File `/oname=$PLUGINSDIR\Progress.bmp` `images\Progress.bmp`
  	File `/oname=$PLUGINSDIR\ProgressBar.bmp` `images\ProgressBar.bmp`

    SkinBtn::Init "$PLUGINSDIR\btn_btn.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_in.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_mini.bmp"
		SkinBtn::Init "$PLUGINSDIR\btn_clos.bmp"
FunctionEnd

Function un.onGUIInit
	;�����߿�
    System::Call `user32::SetWindowLong(i$HWNDPARENT,i${GWL_STYLE},0x9480084C)i.R0`
    ;����һЩ���пؼ�
    GetDlgItem $0 $HWNDPARENT 1034
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1035
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1036
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1037
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1038
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1039
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1256
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1028
    ShowWindow $0 ${SW_HIDE}

    ${NSW_SetWindowSize} $HWNDPARENT 498 373 ;�ı��������С
    System::Call User32::GetDesktopWindow()i.R0
    ;Բ��
    System::Alloc 16
  	System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  	System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  	IntOp $R3 $R3 - $R1
  	IntOp $R4 $R4 - $R2
  	System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i4,i4)i.r0
  	System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  	System::Free $R0
FunctionEnd

;�����ޱ߿��ƶ�
Function un.onGUICallback
  ${If} $MSG = ${WM_LBUTTONDOWN}
    SendMessage $HWNDPARENT ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd

#------------------------------------------
#��С������
#------------------------------------------
Function un.onClickmini
System::Call user32::CloseWindow(i$HWNDPARENT) ;��С��
FunctionEnd

#------------------------------------------
#�رմ���
#------------------------------------------
Function un.onClickclos
SendMessage $hwndparent ${WM_CLOSE} 0 0  ;�ر�
FunctionEnd

#------------------------------------------
#ж�����ҳʹ�ö������η�����������ĳ����ҳ
#------------------------------------------
Function un.onClickend
SendMessage $hwndparent ${WM_CLOSE} 0 0
FunctionEnd

;����ҳ����ת������
Function un.RelGotoPage
  IntCmp $R9 0 0 Move Move
    StrCmp $R9 "X" 0 Move
      StrCpy $R9 "120"
  Move:
  SendMessage $HWNDPARENT "0x408" "$R9" ""
FunctionEnd

Function un.onClickins
  StrCpy $R9 1 ;Goto the next page
  Call un.RelGotoPage
  Abort
FunctionEnd

Function un.onCheckbox_saveXml
	${NSD_GetState} $Checkbox_SaveXml $0

	${If} $0 == ${BST_CHECKED}
			 ${NSD_SetState} $Checkbox_SaveXml ${BST_UNCHECKED}
	${Else}
			 ${NSD_SetState} $Checkbox_SaveXml ${BST_CHECKED}
	${EndIf}
FunctionEnd
