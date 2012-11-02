VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'������ĳ��󣬱���VB��������

Private m_Base As clsBaseControl
Private m_Name As String
Private m_Title As String
Private m_Geometry As String
Private m_Resizable As Boolean
Private m_IconFile As String
Private m_IconEmbedding As Boolean
Private m_Protocol As String
Private m_FrmPath As String          '���洰������Ŀ¼
Private m_ScaleMode As Long

'���PYTHON����,
'sCmdFunc: ����������¼������ص�����;
'rel:�Ƿ�ʹ���������,
'oop:�Ƿ�ʹ�����������
'usettk:�Ƿ�ʹ��TTK������չ
Public Function toString(ByRef sCmdFunc As cStrBuilder, rel As Boolean, oop As Boolean, usettk As Boolean) As String
    
    Dim sOut As New cStrBuilder, s As String, sBase64 As String, sa() As String, i As Long
    
    If oop Then
        sOut.Append "        self.master.title(" & U(m_Title) & ")"
        sOut.Append "        self.master.geometry('" & m_Geometry & "')"
        If Not m_Resizable Then sOut.Append "        self.master.resizable(0,0)"
        
        '��������ͼ��
        s = UCase(FileExt(m_IconFile))
        If s = "GIF" And m_IconEmbedding Then
            sBase64 = CreateIconBase64(Space(12)) 'ʹ��BASE64��GIFͼƬǶ��Դ��
            If Len(sBase64) Then
                sOut.Append "        self.icondata = " & String(3, Chr(34)) & vbCrLf & sBase64 & String(3, Chr(34))
                sOut.Append "        self.iconimg = PhotoImage(data=self.icondata)"
                sOut.Append "        self.master.tk.call('wm', 'iconphoto', self.master._w, self.iconimg)"
            End If
        ElseIf s = "ICO" Then
            sOut.Append "        self.master.iconbitmap(default=r'" & m_IconFile & "')"
        ElseIf Len(s) Then
            sOut.Append "        self.iconimg = PhotoImage(file=r'" & m_IconFile & "')"
            sOut.Append "        self.master.tk.call('wm', 'iconphoto', self.master._w, self.iconimg)"
        End If
        
        '������Ϣ���أ�����еĻ�
        If Len(m_Protocol) Then
            sa = Split(m_Protocol, ",")
            For i = 0 To UBound(sa)
                sOut.Append "        self.master.protocol('" & sa(i) & "', self.EV_" & sa(i) & ")"
                If sa(i) = "WM_DELETE_WINDOW" Then
                    s = "        if askyesno(message='Are you sure to quit?'):" & vbCrLf & Space(12) & "self.master.destroy()"
                    sCmdFunc.Append m_Base.CreateFuncDefOOP("EV_" & sa(i), "event=None", s)
                Else
                    sCmdFunc.Append m_Base.CreateFuncDefOOP("EV_" & sa(i), "event=None")
                End If
            Next
        End If
    Else
        sOut.Append "    " & m_Name & " = Tk()"
        sOut.Append "    " & m_Name & ".title(" & U(m_Title) & ")"
        sOut.Append "    " & m_Name & ".geometry('" & m_Geometry & "')"
        If Not m_Resizable Then sOut.Append "    " & m_Name & ".resizable(0,0)"
        
        '��������ͼ��
        s = UCase(FileExt(m_IconFile))
        If s = "GIF" And m_IconEmbedding Then
            sBase64 = CreateIconBase64(Space(8))
            If Len(sBase64) Then
                sOut.Append "    icondata = " & String(3, Chr(34)) & vbCrLf & sBase64 & String(3, Chr(34))
                sOut.Append "    iconimg = PhotoImage(data=icondata)"
                sOut.Append "    " & m_Name & ".tk.call('wm', 'iconphoto', " & m_Name & "._w, iconimg)"
            End If
        ElseIf s = "ICO" Then
            sOut.Append "    " & m_Name & ".iconbitmap(default=r'" & m_IconFile & "')"
        ElseIf Len(s) Then
            sOut.Append "    iconimg = PhotoImage(file=r'" & m_IconFile & "')"
            sOut.Append "    " & m_Name & ".tk.call('wm', 'iconphoto', " & m_Name & "._w, iconimg)"
        End If
        
        '������Ϣ���أ�����еĻ�
        If Len(m_Protocol) Then
            sa = Split(m_Protocol, ",")
            For i = 0 To UBound(sa)
                sOut.Append "    " & m_Name & ".protocol('" & sa(i) & "', EV_" & sa(i) & ")"
                If sa(i) = "WM_DELETE_WINDOW" Then
                    s = "    if askyesno(message='Are you sure to quit?'):" & vbCrLf & "        gComps['" & m_Name & "'].destroy()"
                    sCmdFunc.Append m_Base.CreateFuncDef("EV_" & sa(i), "event=None", s)
                Else
                    sCmdFunc.Append m_Base.CreateFuncDef("EV_" & sa(i), "event=None")
                End If
            Next
        End If
        
        sOut.Append "    gComps['" & m_Name & "'] = " & m_Name & vbCrLf
    End If
    
    toString = sOut.toString(vbCrLf)
    
End Function

Private Function CreateIconBase64(sPrexSpace As String) As String

    Dim sIconFile As String, abContent() As Byte
    
    CreateIconBase64 = ""
    If Len(m_IconFile) <= 0 Then Exit Function
    
    sIconFile = IIf(InStr(1, m_IconFile, "\") Or InStr(1, m_IconFile, "/"), "", m_FrmPath) & m_IconFile
    
    If Dir(sIconFile) = "" Then
        MsgBox L_F("l_msgFileNotExist", "�ļ�{0}�����ڣ�������ѡ���ļ���", sIconFile), vbInformation
        Exit Function
    End If
    
    If ReadFileBinaryContent(sIconFile, abContent) = 0 Then
        MsgBox L_F("l_msgReadFileError", "��ȡ�ļ�{0}������", sIconFile), vbInformation
        Exit Function
    End If
    
    Base64Encode abContent, CreateIconBase64, sPrexSpace
    
End Function


'���������Ҫ���ϵ������������ʼ��������, �����С������Ϊ��λ
Public Sub InitConfig(o As Object, nWidth As Long, nHeight As Long)
    
    Dim s As String
    
    m_Name = o.Properties("Name")
    m_Title = o.Properties("Caption")
    m_Geometry = nWidth & "x" & nHeight
    m_Resizable = IIf(o.Properties("MaxButton"), True, False)
    m_IconEmbedding = True
    m_IconFile = ""
    m_Protocol = ""
    
    On Error Resume Next
    s = o.FileNames(1)
    If Err.Number = 0 And Len(s) Then
        m_FrmPath = PathName(s)
    Else
        m_FrmPath = ""
    End If
    Err.Clear
    On Error GoTo 0
    
End Sub

'��������ֵ�Ŀ���ֵ�б�
'����ֵ��0-û�п�ѡֵ��1-��һ���ϸ����ƵĿ�ѡֵ�б���2-���ṩ�Ŀ�ѡֵ�б��⣬�������ֶ���������ֵ
'�����sa()��ѡֵ�б�����
Public Function GetAttrValueList(sAttr As String, ByRef sa() As String) As Long
    GetAttrValueList = 1
    If sAttr = "resizable" Or sAttr = "iconembedding" Then
        sa = Split("1,0", ",")
    Else
        GetAttrValueList = 0
    End If
End Function

Public Function Tips(sAttr As String) As String
    Tips = sAttr & vbCrLf
    Select Case sAttr:
        Case "title"
            Tips = Tips & L("l_TipFrmTitle", "����ı��⡣")
        Case "geometry"
            Tips = Tips & L("l_TipFrmGeometry", "����Ĵ�С����x�ߣ�����λΪ���ء�")
        Case "resizable"
            Tips = Tips & L("l_TipFrmResizable", "�û��Ƿ���Ըı䴰��Ĵ�С����ѡֵ��1/0��")
        Case "icon"
            Tips = Tips & L("l_TipFrmIcon", "ͼ���ļ�����֧��ico,gif,ppm,pgm��ʽ��ʡ��·�������ڵ�ǰVB����Ŀ¼�²��ҡ�")
        Case "iconembedding"
            Tips = Tips & L("l_TipFrmIconEmbedding", "�Ƿ�ͼ���ļ�ת��Ϊbase64����Ƕ��Դ���룬��֧��GIF��ʽǶ�롣")
        Case "protocol"
            Tips = Tips & L("l_TipFrmProtocol", "����������Ϣ����������Ϊ'WM_DELETE_WINDOW'�������ڹر��¼������Ҫ���ض����Ϣ����ʹ�ö��ŷָ�������'WM_DELETE_WINDOW,WM_SAVE'")
        Case Else:
            Tips = Tips & L("l_TipUnknown", "δ֪����")
    End Select
End Function

'����һ�����ϣ�ÿ����Ŀ��Ԫ��"������|ֵ|�Ƿ�Ĭ��ѡ��"
'�����������������������Բ����б���
Public Function Allitems() As Collection
    Dim re As Collection
    
    Set re = New Collection
    re.Add "geometry|" & m_Geometry & "|1"
    re.Add "title|" & m_Title & "|1"
    re.Add "resizable|" & IIf(m_Resizable, 1, 0) & "|1"
    re.Add "icon||1"
    re.Add "iconembedding|" & IIf(m_IconEmbedding, 1, 0) & "|1"
    re.Add "protocol||1"
    
    Set Allitems = re
    
End Function

Public Sub SetConfig(sAttrs As String)
    Dim sa() As String, i As Long
    
    sa = Split(sAttrs, "|")
    Debug.Assert (UBound(sa) Mod 1 = 0)
    
    For i = 0 To UBound(sa) - 1 Step 2
        Select Case sa(i)
            Case "title"
                m_Title = UnQuote(Trim(sa(i + 1)))
            Case "geometry"
                m_Geometry = UnQuote(Trim(sa(i + 1)))
            Case "resizable"
                m_Resizable = IIf(Trim(sa(i + 1)) = "0", False, True)
            Case "icon"
                m_IconFile = UnQuote(Trim(sa(i + 1)))
            Case "iconembedding"
                m_IconEmbedding = IIf(Trim(sa(i + 1)) = "0", False, True)
            Case "protocol"
                m_Protocol = Trim(Replace(Replace(Replace(sa(i + 1), Chr(34), ""), "'", ""), " ", ""))
        End Select
    Next
    
End Sub

Public Sub SetSingleConfig(sAttr As String)
    SetConfig sAttr
End Sub

Public Property Get Parent() As String
    Parent = ""
End Property

Public Property Get Name() As String
    Name = m_Name
End Property

Public Property Let Name(s As String)
    m_Name = s
End Property

Public Property Get Description() As String
    Description = L("l_DescForm", "����������ö��㴰�ڵ����ԡ�")
End Property

Public Property Let ScaleMode(nV As Long)
    m_ScaleMode = nV
End Property

Private Sub Class_Initialize()
    Set m_Base = New clsBaseControl
End Sub

Private Sub Class_Terminate()
    Set m_Base = Nothing
End Sub

'�������л�����
Public Function Serializer(vSer As clsSerialization)
    'vSer.Serializer m_Base
End Function

Public Function Deserializer(vSer As clsSerialization)
    'vSer.Deserializer m_Base
End Function
