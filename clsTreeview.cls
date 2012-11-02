VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsTreeview"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'������ʾ�ؼ��࣬�������úͱ�����Ӧ�����Ժ�ֵ�������ɶ�ӦPYTHON��TKinter����(��TTK֧��)

Private m_dicTotal As Dictionary                                                '����ȫ�������ԣ�����Ĭ��ֵ
Private m_Base As clsBaseControl                                                '�����ؼ���

'���PYTHON����,
'sCmdFunc: ����������¼������ص�����;
'rel:�Ƿ�ʹ���������,
'oop:�Ƿ�ʹ�����������
'usettk:�Ƿ�ʹ��TTK������չ
Public Function toString(ByRef sCmdFunc As cStrBuilder, rel As Boolean, oop As Boolean, usettk As Boolean) As String
    
    toString = m_Base.toString(sCmdFunc, rel, oop, usettk)
    
    '���Ӽ���ʾ�����룬����������Ҳ���Ժܿ�����ʹ��
    If oop Then
        toString = toString & vbCrLf & Space(8) & "self." & m_Base.Name & ".insert('', 'end', 'TOP', text='Sample', open=True)  " & L("l_cmtTreeviewSample", "#��������Ϊʾ�����룬��ɾ��д�Լ�����Ŀ����") & vbCrLf
        toString = toString & Space(8) & "self." & m_Base.Name & ".insert('', 'end', 'TOP2', text='TOP2')" & vbCrLf
        toString = toString & Space(8) & "self." & m_Base.Name & ".insert('TOP', 'end', 'TOP.1', text='Sample.1')" & vbCrLf
        toString = toString & Space(8) & "self." & m_Base.Name & ".insert('TOP', 'end', 'TOP.2', text='Sample.2')"
    Else
        toString = toString & vbCrLf & Space(4) & m_Base.Name & ".insert('', 'end', 'TOP', text='Sample', open=True)  " & L("l_cmtTreeviewSample", "#��������Ϊʾ�����룬��ɾ��д�Լ�����Ŀ����") & vbCrLf
        toString = toString & Space(4) & m_Base.Name & ".insert('', 'end', 'TOP2', text='TOP2')" & vbCrLf
        toString = toString & Space(4) & m_Base.Name & ".insert('TOP', 'end', 'TOP.1', text='Sample.1')" & vbCrLf
        toString = toString & Space(4) & m_Base.Name & ".insert('TOP', 'end', 'TOP.2', text='Sample.2')"
    End If
    
End Function

'���������Ҫ���ϵ������������ʼ��������
Public Sub InitConfig(o As Object, parentWidth As Long, parentHeight As Long)
    
    m_Base.Name = o.Properties("Name")
    
    m_dicTotal("x") = m_Base.toPixelX(o.Properties("Left"))
    m_dicTotal("y") = m_Base.toPixelY(o.Properties("Top"))
    m_dicTotal("width") = m_Base.toPixelX(o.Properties("Width"))
    m_dicTotal("height") = m_Base.toPixelY(o.Properties("Height"))
    m_dicTotal("relx") = Format(o.Properties("Left") / parentWidth, "0.###")
    m_dicTotal("rely") = Format(o.Properties("Top") / parentHeight, "0.###")
    m_dicTotal("relwidth") = Format(o.Properties("Width") / parentWidth, "0.###")
    m_dicTotal("relheight") = Format(o.Properties("Height") / parentHeight, "0.###")
    m_dicTotal("columns") = m_Base.Name & "Cols"
    m_dicTotal("displaycolumns") = "'#all'"
    m_dicTotal("displayrows") = ""
    m_dicTotal("padding") = ""
    m_dicTotal("selectmode") = "'extended'"
    m_dicTotal("show") = "'tree'"
    m_dicTotal("takefocus") = IIf(o.Properties("TabStop"), 1, 0)
    
    '��Щ��Ĭ��ѡ���
    m_Base("x") = m_dicTotal("x")
    m_Base("y") = m_dicTotal("y")
    m_Base("width") = m_dicTotal("width")
    m_Base("height") = m_dicTotal("height")
    m_Base("relx") = m_dicTotal("relx")
    m_Base("rely") = m_dicTotal("rely")
    m_Base("relwidth") = m_dicTotal("relwidth")
    m_Base("relheight") = m_dicTotal("relheight")
    m_Base("show") = m_dicTotal("show")
    
End Sub

'��������ֵ�Ŀ���ֵ�б�
'����ֵ��0-û�п�ѡֵ��1-��һ���ϸ����ƵĿ�ѡֵ�б���2-���ṩ�Ŀ�ѡֵ�б��⣬�������ֶ���������ֵ
'�����sa()��ѡֵ�б�����
Public Function GetAttrValueList(sAttr As String, ByRef sa() As String) As Long
    GetAttrValueList = 1
    If sAttr = "selectmode" Then
        sa = Split("'extended','browse','none'", ",")
    ElseIf sAttr = "show" Then
        sa = Split("'tree headings','tree'", ",")
    Else
        GetAttrValueList = m_Base.GetAttrValueList(sAttr, sa)
    End If
End Function

Public Function Tips(sAttr As String) As String
    Tips = sAttr & vbCrLf
    Select Case sAttr:
    Case "columns":
        Tips = Tips & L("l_TipColumns", "һ���б���������ָ���ؼ��������б��⡣�����ô˲�����û�б��⣬����ֻ��ʾһ�С�")
    Case "displaycolumns":
        Tips = Tips & L("l_TipDisplayColumns", "һ���б���������ָ����ʾ�����������˳�򣬻������Ϊ'#all'��ʾ����'columns'���������õ������С�")
    Case "displayrows":
        Tips = Tips & L("l_TipDisplayRows", "ָ��Ҫ��ʾ������")
    Case "selectmode":
        Tips = Tips & L("l_TipSelectModeTV", "��Ŀѡ��ģʽ����Ҫ��������������ѡֵ��'extended'(Ĭ��)��ѡ�����Ŀ, 'browse'ֻ��ѡ��һ����Ŀ or 'none' ����ʾ")
    Case "show":
        Tips = Tips & L("l_TipShowTV", "�ؼ���ʾ���á���Ҫ������������Ĭ��Ϊ'tree headings'����ʾ��һ����ʾ������ʾ�����С�����Ϊ'tree'����ʾ�����С�")
    Case Else:
        Tips = m_Base.Tips(sAttr)
    End Select
End Function

Private Sub Class_Initialize()
    
    Set m_dicTotal = New Dictionary
    Set m_Base = New clsBaseControl
    m_Base.ctlType = "Treeview"
    m_Base.StyleName = "Treeview"
    
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

'���û�ѡ������ø��µ������У�����Ϊʹ��"|"�ָ�ĺܶ������/ֵ��
Public Sub SetConfig(sAttrs As String)
    m_Base.SetConfig sAttrs
End Sub

'�޸Ļ����ӵ������������/ֵ��"|"�ָ�
Public Sub SetSingleConfig(sAttr As String)
    m_Base.SetSingleConfig sAttr
End Sub

Private Sub Class_Terminate()
    Set m_dicTotal = Nothing
    Set m_Base = Nothing
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
    Description = L("l_DescTreeview", "���οؼ����󣬶�Ӧ��Tkinter.ttk��չ���Treeview�ؼ�����Ҫ����TTK��չ��")
End Property

Public Property Let ScaleMode(nV As Long)
    m_Base.ScaleMode = nV
End Property



