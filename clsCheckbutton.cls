VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsCheckbutton"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

'��ѡ��ť�࣬�������úͱ�����Ӧ�����Ժ�ֵ�������ɶ�ӦPYTHON��TKinter����

Private m_dicTotal As Dictionary                                                '����ȫ�������ԣ�����Ĭ��ֵ
Private m_Base As clsBaseControl                                                '�����ؼ���

'���PYTHON����,
'sCmdFunc: ����������¼������ص�����;
'rel:�Ƿ�ʹ���������,
'oop:�Ƿ�ʹ�����������
'usettk:�Ƿ�ʹ��TTK������չ
Public Function toString(ByRef sCmdFunc As cStrBuilder, rel As Boolean, oop As Boolean, usettk As Boolean) As String
    toString = m_Base.toString(sCmdFunc, rel, oop, usettk)
End Function

'���������Ҫ���ϵ������������ʼ��������
Public Sub InitConfig(o As Object, parentWidth As Long, parentHeight As Long)
    
    m_Base.Name = o.Properties("Name")
    m_Base.Value = IIf(o.Properties("Value"), 1, 0)
    
    m_dicTotal("x") = m_Base.toPixelX(o.Properties("Left"))
    m_dicTotal("y") = m_Base.toPixelY(o.Properties("Top"))
    m_dicTotal("width") = m_Base.toPixelX(o.Properties("Width"))
    m_dicTotal("height") = m_Base.toPixelY(o.Properties("Height"))
    m_dicTotal("relx") = Format(o.Properties("Left") / parentWidth, "0.###")
    m_dicTotal("rely") = Format(o.Properties("Top") / parentHeight, "0.###")
    m_dicTotal("relwidth") = Format(o.Properties("Width") / parentWidth, "0.###")
    m_dicTotal("relheight") = Format(o.Properties("Height") / parentHeight, "0.###")
    m_dicTotal("text") = Replace(o.Properties("Caption"), "&", "")
    m_dicTotal("variable") = o.Properties("Name") & "Var"
    m_dicTotal("fg") = ColorToRGBStr(o.Properties("ForeColor"))
    m_dicTotal("bg") = ColorToRGBStr(o.Properties("BackColor"))
    m_dicTotal("bd") = "1"
    m_dicTotal("anchor") = "'w'"
    m_dicTotal("relief") = "FLAT"
    m_dicTotal("state") = "'normal'"
    m_dicTotal("font") = "size=" & Round(o.Properties("Font")("Size")) & ",weight=" & IIf(o.Properties("Font")("Bold"), "'bold'", "'normal'") & ",slant=" & IIf(o.Properties("Font")("Italic"), "'italic'", "'roman'")
    m_dicTotal("takefocus") = IIf(o.Properties("TabStop"), 1, 0)
    m_dicTotal("underline") = IIf(InStr(1, o.Properties("Caption"), "&"), InStr(1, o.Properties("Caption"), "&") - 1, "-1")
    m_dicTotal("command") = o.Properties("Name") & "_Cmd"
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
    m_Base("text") = m_dicTotal("text")
    m_Base("variable") = m_dicTotal("variable")
    If m_dicTotal("fg") <> "" Then m_Base("fg") = m_dicTotal("fg")
    If m_dicTotal("bg") <> "" Then m_Base("bg") = m_dicTotal("bg")
    If m_dicTotal("state") <> "'normal'" Then m_Base("state") = m_dicTotal("state")
    If m_dicTotal("font") <> "size=9,weight='normal',slant='roman'" Then m_Base("font") = m_dicTotal("font")
    If m_dicTotal("takefocus") = 0 Then m_Base("takefocus") = m_dicTotal("takefocus")
    If m_dicTotal("underline") <> "-1" Then m_Base("underline") = m_dicTotal("underline")
    
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

Private Sub Class_Initialize()
    Set m_dicTotal = New Dictionary
    Set m_Base = New clsBaseControl
    m_Base.ctlType = "Checkbutton"
    m_Base.StyleName = "TCheckbutton"
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
    Description = L("l_DescCheckbutton", "��ѡ����󣬶�Ӧ��Tkinter��Checkbutton�ؼ���")
End Property

Public Property Let ScaleMode(nV As Long)
    m_Base.ScaleMode = nV
End Property

