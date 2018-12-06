VERSION 5.00
Begin VB.Form frmEncodeAFile 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Encode File to Base64"
   ClientHeight    =   9645
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   13230
   BeginProperty Font 
      Name            =   "Courier New"
      Size            =   9
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmEncodeAFile.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   9645
   ScaleWidth      =   13230
   StartUpPosition =   1  '����������
   Begin VB.TextBox txtCharsPerLine 
      Height          =   375
      Left            =   2280
      TabIndex        =   8
      Text            =   "80"
      Top             =   720
      Width           =   975
   End
   Begin TkinterDesigner.xpcmdbutton cmdCancelEncode 
      Height          =   495
      Left            =   10320
      TabIndex        =   6
      Top             =   9000
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   873
      Caption         =   "Exit(&Q)"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Courier New"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin TkinterDesigner.xpcmdbutton cmdSaveBase64Result 
      Height          =   495
      Left            =   5640
      TabIndex        =   5
      Top             =   9000
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   873
      Caption         =   "Save(&S)"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Courier New"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin TkinterDesigner.xpcmdbutton cmdBase64It 
      Height          =   495
      Left            =   960
      TabIndex        =   4
      Top             =   9000
      Width           =   1935
      _ExtentX        =   3413
      _ExtentY        =   873
      Caption         =   "Encode(&E)"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Courier New"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.TextBox txtBase64Result 
      Height          =   7455
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   3
      Top             =   1200
      Width           =   12975
   End
   Begin TkinterDesigner.xpcmdbutton cmdChooseSourceToEncode 
      Height          =   375
      Left            =   12480
      TabIndex        =   2
      Top             =   240
      Width           =   615
      _ExtentX        =   1085
      _ExtentY        =   661
      Caption         =   "..."
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Courier New"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.TextBox txtSourceToEncode 
      Height          =   375
      Left            =   2280
      TabIndex        =   1
      Top             =   240
      Width           =   10095
   End
   Begin VB.Label lblCharsPerLine 
      Alignment       =   1  'Right Justify
      Caption         =   "Chars Per Line"
      Height          =   375
      Left            =   0
      TabIndex        =   7
      Top             =   720
      Width           =   2175
   End
   Begin VB.Label lblSourceToEncode 
      Alignment       =   1  'Right Justify
      Caption         =   "Source File"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   240
      Width           =   2055
   End
End
Attribute VB_Name = "frmEncodeAFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'ʵ�ʱ���һ���ļ�
Private Sub cmdBase64It_Click()
    Dim sFileName As String, sResult As String, abContent() As Byte, charsPerLine As Integer
    Dim sF As String
    
    sFileName = Trim$(txtSourceToEncode.Text)
    If Len(sFileName) <= 0 Then
        MsgBox L("l_msgFileFieldNull", "File can't be null."), vbInformation
        Exit Sub
    End If
    
    On Error GoTo DirErr
    
    charsPerLine = CInt(txtCharsPerLine.Text)
    
    If Dir(sFileName) = "" Then
        MsgBox L_F("l_msgFileNotExist", "File '{0}' not exist!", sFileName), vbInformation
        Exit Sub
    ElseIf FileLen(sFileName) > 500000 Then
        MsgBox L("l_msgFileTooBig", "File is too big, app will take too much time to convert, can't continue now!"), vbInformation
        Exit Sub
    End If
    
    '�ö����Ʒ�ʽ��ȡ����
    If ReadFileBinaryContent(sFileName, abContent) = 0 Then
        MsgBox L_F("l_msgReadFileError", "Error in Reading File {0}.", sFileName), vbInformation
        Exit Sub
    End If
    
    Base64Encode abContent, sResult, "", charsPerLine
    
    If Len(sResult) >= 65530 Then
        MsgBox L("l_msgEncodeResultTooLong", "Size of encoded string is too big to load into TextBox, please choose a file to save it."), vbInformation
        txtBase64Result.Text = ""
        
        sF = FileDialog(Me, True, L("l_fdSave", "Save file to:"), "All Files (*.*)|*.*")
        If Len(sF) > 0 Then
            SaveStringToFile sF, sResult
        End If
    Else
        txtBase64Result.Text = sResult
    End If
    
    Exit Sub
DirErr:
    MsgBox L_F("l_msgFileNotExist", "File '{0}' not exist!", sFileName), vbInformation
    
End Sub

Private Sub cmdCancelEncode_Click()
    Unload Me
End Sub

'���ļ������ѡ��һ���ļ����б���
Private Sub cmdChooseSourceToEncode_Click()
    Dim sF As String
    sF = FileDialog(Me, False, L("l_fdOpen", "Please Choose file:"), "All Files (*.*)|*.*", txtSourceToEncode.Text)
    If Len(sF) Then
        txtSourceToEncode.Text = sF
    End If
End Sub

'���ı�������ݱ��浽�����ı��ļ�
Private Sub cmdSaveBase64Result_Click()
    Dim sF As String, s As String, nm As Long, nf As Long
    
    s = txtBase64Result.Text
    If Len(s) > 2 Then
        sF = FileDialog(Me, True, L("l_fdSave", "Save file to:"), "Python Files (*.py)|*.py|Text Files (*.txt)|*.txt|All Files (*.*)|*.*")
        If Len(sF) Then
            If Len(FileExt(sF)) = 0 Then sF = sF & ".py"  '����ļ���û����չ�����Զ�����.py��չ��
            SaveStringToFile sF, s
        End If
    End If
End Sub

Private Sub Form_Load()
    Dim ctl As Control
    
    '������֧��
    Me.Caption = L(Me.Name, Me.Caption)
    For Each ctl In Me.Controls
        If TypeName(ctl) = "xpcmdbutton" Or TypeName(ctl) = "Label" Then
            ctl.Caption = L(ctl.Name, ctl.Caption)
        End If
    Next
    
End Sub

Private Sub SaveStringToFile(ByRef sFileName As String, ByRef s As String)
    Dim fileNum As Integer
    On Error GoTo errHandler
    fileNum = FreeFile()
    Open sFileName For Output As fileNum
    Print #fileNum, s
    Close fileNum
    Exit Sub
errHandler:
    MsgBox L_F("l_msgWriteFileError", "Error in Writing File {0}.", sFileName), vbInformation
End Sub

'����Ctrl+A��ݼ�
Private Sub txtBase64Result_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = vbKeyA And Shift = vbCtrlMask Then
        txtBase64Result.SelStart = 0
        txtBase64Result.SelLength = Len(txtBase64Result.Text) + 1
    End If
End Sub