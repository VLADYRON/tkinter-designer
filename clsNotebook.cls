VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsNotebook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'ѡ��࣬�������úͱ�����Ӧ�����Ժ�ֵ�������ɶ�ӦPYTHON��TKinter����

Private m_dicTotal As Dictionary       '����ȫ�������ԣ�����Ĭ��ֵ
Private m_Base As clsBaseControl       '�����ؼ���
Private m_Tabs() As String             'ѡ����⣬�±��1��ʼ�ģ�0ʵ��û��
Private m_nTabs As Long                'ѡ���Ŀ

'���PYTHON����,
'sCmdFunc: ����������¼������ص�����;
'rel:�Ƿ�ʹ���������,
'oop:�Ƿ�ʹ�����������
'usettk:�Ƿ�ʹ��TTK������չ
Public Function toString(ByRef sCmdFunc As cStrBuilder, rel As Boolean, oop As Boolean, usettk As Boolean) As String
    
    Dim i As Long, sOut As New cStrBuilder, s As String
    
    sOut.Append m_Base.toString(sCmdFunc, rel, oop, usettk)
    
    '����ѡ�
    If oop Then
        sOut.Append vbCrLf & Space(8) & L("l_cmtTodoNBFrame", "#TODO�����ڸ���Frame(������ѡ�����)����������Ҫ�Ŀؼ���")
        For i = 1 To m_nTabs  'TAB�±��1��ʼ
            s = "self." & m_Base.Name & "Frame" & i
            sOut.Append Space(8) & s & " = Frame(self." & m_Base.Name & ")"
            sOut.Append Space(8) & s & "Lbl = Label(" & s & ", text='Please add widgets in code.')"
            sOut.Append Space(8) & s & "Lbl.place(relx=0.1,rely=0.5)" & vbCrLf
        Next
        
        For i = 1 To m_nTabs
            s = "self." & m_Base.Name & "Frame" & i
            sOut.Append Space(8) & "self." & m_Base.Name & ".add(" & s & ", text=" & U(m_Tabs(i)) & ")"
        Next
    Else
        sOut.Append vbCrLf & Space(4) & L("l_cmtTodoNBFrame", "#TODO�����ڸ���Frame(������ѡ�����)����������Ҫ�Ŀؼ���")
        For i = 1 To m_nTabs
            s = m_Base.Name & "Frame" & i
            sOut.Append Space(4) & s & " = Frame(" & m_Base.Name & ")"
            sOut.Append Space(4) & s & "Lbl = Label(" & s & ", text='Please add widgets in code.')"
            sOut.Append Space(4) & s & "Lbl.place(relx=0.1,rely=0.5)" & vbCrLf
        Next
        
        For i = 1 To m_nTabs
            s = m_Base.Name & "Frame" & i
            sOut.Append Space(4) & m_Base.Name & ".add(" & s & ", text=" & U(m_Tabs(i)) & ")"
        Next
    End If
    
    toString = sOut.toString(vbCrLf)
    
End Function


'���������Ҫ���ϵ������������ʼ��������
Public Sub InitConfig(o As Object, parentWidth As Long, parentHeight As Long)
    
    Dim i As Long, oiTabs As ITabs
    
    m_Base.Name = o.Properties("Name")
    
    Set oiTabs = o.Properties("Tabs").object
    m_nTabs = oiTabs.Count
    
    ReDim m_Tabs(m_nTabs) As String
    For i = 1 To m_nTabs
        m_Tabs(i) = oiTabs.Item(i).Caption  'TAB�±��1��ʼ
    Next
    
    '��Щ�����е�Ĭ��ֵ
    m_dicTotal("x") = m_Base.toPixelX(o.Properties("Left"))
    m_dicTotal("y") = m_Base.toPixelY(o.Properties("Top"))
    m_dicTotal("width") = m_Base.toPixelX(o.Properties("Width"))
    m_dicTotal("height") = m_Base.toPixelY(o.Properties("Height"))
    m_dicTotal("relx") = Format(o.Properties("Left") / parentWidth, "0.###")
    m_dicTotal("rely") = Format(o.Properties("Top") / parentHeight, "0.###")
    m_dicTotal("relwidth") = Format(o.Properties("Width") / parentWidth, "0.###")
    m_dicTotal("relheight") = Format(o.Properties("Height") / parentHeight, "0.###")
    m_dicTotal("relief") = "FLAT"
    m_dicTotal("takefocus") = IIf(o.Properties("TabStop"), 1, 0)
    m_dicTotal("bindcommand") = ""
    
    '��Щ��Ĭ��ѡ���
    m_Base("x") = m_dicTotal("x")
    m_Base("y") = m_dicTotal("y")
    m_Base("width") = m_dicTotal("width")
    m_Base("height") = m_dicTotal("height")
    m_Base("relx") = m_dicTotal("relx")
    m_Base("rely") = m_dicTotal("rely")
    m_Base("relwidth") = m_dicTotal("relwidth")
    m_Base("relheight") = m_dicTotal("relheight")
    If m_dicTotal("takefocus") = 0 Then m_Base("takefocus") = m_dicTotal("takefocus")
    
End Sub

'��������ֵ�Ŀ���ֵ�б�
'����ֵ��0-û�п�ѡֵ��1-��һ���ϸ����ƵĿ�ѡֵ�б���2-���ṩ�Ŀ�ѡֵ�б��⣬�������ֶ���������ֵ
'�����sa()��ѡֵ�б�����
Public Function GetAttrValueList(sAttr As String, ByRef sa() As String) As Long
    GetAttrValueList = m_Base.GetAttrValueList(sAttr, sa)
End Function

Public Function Tips(sAttr As String) As String
    Tips = m_Base.Tips(sAttr)
End Function

'���û�ѡ������ø��µ������У�����Ϊʹ��"|"�ָ�ĺܶ������/ֵ��
Public Sub SetConfig(sAttrs As String)
    m_Base.SetConfig sAttrs
End Sub

'�޸Ļ����ӵ������������/ֵ��"|"�ָ�
Public Sub SetSingleConfig(sAttr As String)
    m_Base.SetSingleConfig sAttr
End Sub

'����һ�����ϣ�ÿ����Ŀ��Ԫ��"������|ֵ|�Ƿ�Ĭ��ѡ��"
'�����������������������Բ����б���
Public Function Allitems() As Collection
    Dim re As Collection, k As Variant, ks As Collection
    
    Set re = New Collection
    
    '��׼����
    Set ks = m_dicTotal.Keys
    For Each k In ks
        If Len(m_Base(k)) Then
            re.Add k & "|" & m_Base(k) & "|1"
        Else
            re.Add k & "|" & m_dicTotal(k) & "|0"
        End If
    Next
    
    '�û����ӵ��Զ������������еĻ���
    Set ks = m_Base.Keys
    For Each k In ks
        If Not m_dicTotal.Exists(k) Then
            re.Add k & "|" & m_Base(k) & "|1"
        End If
    Next
    
    Set Allitems = re
    
End Function

Private Sub Class_Initialize()
    
    Set m_dicTotal = New Dictionary
    Set m_Base = New clsBaseControl
    m_Base.ctlType = "Notebook"
    m_Base.StyleName = "TNotebook"
    ReDim m_Tabs(0) As String
End Sub

Private Sub Class_Terminate()
    Set m_dicTotal = Nothing
    Set m_Base = Nothing
    Erase m_Tabs
End Sub

Public Property Let Parent(s As String)
    m_Base.Parent = s
End Property

Public Property Get Parent() As String
    Parent = m_Base.Parent
End Property

Public Property Get Name() As String
    Name = m_Base.Name
End Property

'�������л�����
Public Function Serializer(vSer As clsSerialization)
    vSer.Serializer m_Base
End Function

Public Function Deserializer(vSer As clsSerialization)
    vSer.Deserializer m_Base
End Function

Public Property Get Description() As String
    Description = L("l_DescNotebook", "ѡ����󣬶�Ӧ��Tkinter.ttk��Notebook�ؼ���")
End Property

Public Property Let ScaleMode(nV As Long)
    m_Base.ScaleMode = nV
End Property

