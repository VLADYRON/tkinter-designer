Attribute VB_Name = "MultiLanguage"
'������֧��ģ��
'�����ļ��� Language.lng
' �ļ���ʽ��
'    [��������]
'    �ؼ���=�ַ���
'    �����ַ���=�ַ���    '��������ڲ��ַ��������������Ϣ�ȣ����ַ�����ʹ��\n��ʾ�س�
'
'ChangeLanguage(������)   : �л��ؼ���ʾ���ԣ��������Ҳ��һ���Ի����Ӧ���ֵ������ַ������ڴ�
'L(����,Ĭ���ַ���)       : ��ȡָ���ַ���
'GetAllLanguageName()     : Language.lng���������ֵ����ƣ��ַ�������

Option Explicit
Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Private Const LanguageFile = "Language.lng"
Private m_Lng As New Dictionary                                                 '��Ӧ���ֵ�{����,�ַ���}�ֵ�
Public Const DEF_LNG = "��������(&C)"

'���ݵ�ǰ�������û�ȡһ���ַ���
Public Function L(sKey As String, ByVal sDefault As String) As String
    sDefault = Replace(sDefault, "\n", vbCrLf)
    L = GetString("", sKey, sDefault)
End Function

'���ݵ�ǰ�������û�ȡһ���ַ���
'֧������python��{0}{1}��ʽ���ַ�������{0}��ʼ��ţ���֧��{}��ʽ(û����������)
Public Function L_F(sKey As String, ByVal sDefault As String, ParamArray v() As Variant) As String
    
    Dim s As String, i As Long
    
    s = L(sKey, sDefault)
    
    For i = 0 To UBound(v)
        s = Replace(s, "{" & i & "}", CStr(v(i)))
    Next
    
    L_F = s
    
End Function

Public Function GetAllLanguageName() As String()
    On Error Resume Next
    Dim s As String, ns As Long
    s = vbNullString
    If LngFileExist() Then
        s = Space(1000)
        ns = GetPrivateProfileString(vbNullString, vbNullString, vbNullString, s, 1000, LngFile())
        GetAllLanguageName = Split(Trim(Replace(Left(s, ns), Chr(0) & Chr(0), "")), Chr(0))
    Else
        GetAllLanguageName = Split(DEF_LNG)                                     'Ĭ�������ģ���ʹû�������ļ�
    End If
    s = ""
End Function

Public Function ChangeLanguage(Language As String) As Boolean
    Dim i As Long, Ctrl As Control, s As String, ns As Long, sa() As String
    
    '�Ȼ����Ӧ���ֵ������ַ���
    s = Space(10000)
    ns = GetPrivateProfileString(Language, vbNullString, vbNullString, s, 10000, LngFile())
    sa = Split(Trim(Replace(Left(s, ns), Chr(0) & Chr(0), "")), Chr(0))
    m_Lng.RemoveAll
    For i = 0 To UBound(sa)
        s = Space(256)
        ns = GetPrivateProfileString(Language, sa(i), "", s, 256, LngFile())
        s = Trim(Replace(Replace(Left(s, ns), Chr(0), ""), "\n", vbCrLf))
        If Len(s) Then m_Lng.Add sa(i), s
    Next
    
    '�л����пؼ�������
    For i = 0 To Forms.Count - 1
        For Each Ctrl In Forms(i).Controls
            ChangeControlLanguage Ctrl, Language
        Next
    Next i
    
    ChangeLanguage = ns > 0
    
End Function

Public Sub ChangeControlLanguage(ctl As Control, Language As String)
    Select Case TypeName(ctl)
    Case "Label", "CommandButton", "CheckBox", "OptionButton", "Frame", "Menu", "RKShadeButton"
        ctl.Caption = GetString(Language, ctl.Name, ctl.Caption)
    End Select
End Sub

Private Function LngFile() As String
    LngFile = App.path & IIf(Right(App.path, 1) = "\", "", "\") & LanguageFile
End Function

Private Function LngFileExist() As Boolean
    LngFileExist = IIf(Dir(LngFile()) = LanguageFile, True, False)
End Function

Private Function GetString(Language As String, Key As String, sDefault As String) As String
    If m_Lng.Exists(Key) Then
        GetString = m_Lng.Item(Key)
    Else
        GetString = sDefault
    End If
End Function
