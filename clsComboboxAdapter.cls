VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsComboboxAdapter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'��Ͽ���������
'��ΪTK��û����Ͽ�����VB����Ͽ�ӳ�䵽Tk��OptionMenu
'���������TTK����ӳ�䵽TTK��Combobox
'VB������һ������Ͽ���OptionMenu��Combobox������
'����ʹ����һ���м����Ϊ��������ѡ������һ��

Private m_usettk As Boolean
Private m_OptionMenu As clsOptionMenu
Private m_Combobox As clsCombobox

Public Property Let TTK(usettk As Boolean)
    m_usettk = usettk
End Property


'���PYTHON����,
'sCmdFunc: ����������¼������ص�����;
'rel:�Ƿ�ʹ���������,
'oop:�Ƿ�ʹ�����������
'usettk:�Ƿ�ʹ��TTK������չ
Public Function toString(ByRef sCmdFunc As cStrBuilder, rel As Boolean, oop As Boolean, usettk As Boolean) As String
    If m_usettk Then
        toString = m_Combobox.toString(sCmdFunc, rel, oop, usettk)
    Else
        toString = m_OptionMenu.toString(sCmdFunc, rel, oop, usettk)
    End If
End Function

'���������Ҫ���ϵ������������ʼ��������
Public Sub InitConfig(o As Object, parentWidth As Long, parentHeight As Long)
    m_Combobox.InitConfig o, parentWidth, parentHeight
    m_OptionMenu.InitConfig o, parentWidth, parentHeight
End Sub

'��������ֵ�Ŀ���ֵ�б�
'����ֵ��0-û�п�ѡֵ��1-��һ���ϸ����ƵĿ�ѡֵ�б���2-���ṩ�Ŀ�ѡֵ�б��⣬�������ֶ���������ֵ
'�����sa()��ѡֵ�б�����
Public Function GetAttrValueList(sAttr As String, ByRef sa() As String) As Long
    If m_usettk Then
        GetAttrValueList = m_Combobox.GetAttrValueList(sAttr, sa)
    Else
        GetAttrValueList = m_OptionMenu.GetAttrValueList(sAttr, sa)
    End If
End Function


Public Function Tips(sAttr As String) As String
    If m_usettk Then
        Tips = m_Combobox.Tips(sAttr)
    Else
        Tips = m_OptionMenu.Tips(sAttr)
    End If
End Function

Private Sub Class_Initialize()
    m_usettk = True
    Set m_OptionMenu = New clsOptionMenu
    Set m_Combobox = New clsCombobox
End Sub

'����һ�����ϣ�ÿ����Ŀ��Ԫ��"������|ֵ|�Ƿ�Ĭ��ѡ��"
'�����������������������Բ����б���
Public Function Allitems() As Collection
    If m_usettk Then
        Set Allitems = m_Combobox.Allitems()
    Else
        Set Allitems = m_OptionMenu.Allitems()
    End If
End Function

'���û�ѡ������ø��µ������У�����Ϊʹ��"|"�ָ�ĺܶ������/ֵ��
Public Sub SetConfig(sAttrs As String)
    If m_usettk Then
        m_Combobox.SetConfig (sAttrs)
    Else
        m_OptionMenu.SetConfig (sAttrs)
    End If
End Sub

'�޸Ļ����ӵ������������/ֵ��"|"�ָ�
Public Sub SetSingleConfig(sAttr As String)
    If m_usettk Then
        m_Combobox.SetSingleConfig (sAttr)
    Else
        m_OptionMenu.SetSingleConfig (sAttr)
    End If
End Sub

Public Property Let Parent(s As String)
    m_Combobox.Parent = s
    m_OptionMenu.Parent = s
End Property

Public Property Get Parent() As String
    If m_usettk Then
        Parent = m_Combobox.Parent
    Else
        Parent = m_OptionMenu.Parent
    End If
End Property

Public Property Get Name() As String
    If m_usettk Then
        Name = m_Combobox.Name
    Else
        Name = m_OptionMenu.Name
    End If
End Property

'�������л�����
Public Function Serializer(vSer As clsSerialization)
    If m_usettk Then
        m_Combobox.Serializer vSer
    Else
        m_OptionMenu.Serializer vSer
    End If
End Function

Public Function Deserializer(vSer As clsSerialization)
    If m_usettk Then
        m_Combobox.Deserializer vSer
    Else
        m_OptionMenu.Deserializer vSer
    End If
End Function

Public Property Get Description() As String
    If m_usettk Then
        Description = m_Combobox.Description
    Else
        Description = m_OptionMenu.Description
    End If
End Property


Public Property Let ScaleMode(nV As Long)
    m_Combobox.ScaleMode = nV
    m_OptionMenu.ScaleMode = nV
End Property


