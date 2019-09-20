
Public Sub ApplyCondFormatToRange()
'Finds the last non-blank cell in a single row or column
    
    Dim lRow As Long
    Dim lCol As Long
    Dim Current As Worksheet
        
        'Find the last non-blank cell in row 2
        lCol = Cells(2, Columns.Count).End(xlToLeft).Column
        
        'Find the last non-blank cell in column A(1)
        lRow = Cells(Rows.Count, 1).End(xlUp).Row
        
        
        'MsgBox "Last Row: " & lRow & vbNewLine & _
        '        "Last Column: " & lCol
                
        Dim rg As Range
        Dim cond1 As FormatCondition, cond2 As FormatCondition, cond3 As FormatCondition
        
        ' Assert range with data of worksheet (starting from B3)
        Dim RangeInWorkSheet As Range: Set RangeInWorkSheet = Application.Range(Cells(1, 2), Cells(lCol - 1, lRow))
        
        'clear any existing conditional formatting
        RangeInWorkSheet.FormatConditions.Delete
          
        For Each col In RangeInWorkSheet.Columns
            colNum = col.Column
            'Debug.Print col.Column
            Set rg = Range(Cells(3, colNum), Cells(lRow, colNum))
            'rg.FormatConditions.AddDatabar
            
            Set Db = rg.FormatConditions.AddDatabar
                Db.ShowValue = True
                Db.BarColor.TintAndShade = 0
                Db.BarFillType = xlDataBarFillSolid
            
        Next col

End Sub



Sub ApplyCondFormatToRangeLoop()

   ' Declare Current as a worksheet object variable.
   Dim CurrentWS As Worksheet

   ' Loop through all of the worksheets in the active workbook.
   For Each CurrentWS In Worksheets
      CurrentWS.Activate
      
      ' Insert your code here.
      Call ApplyCondFormatToRange
      
      ' This line displays the worksheet name in a message box.
      Debug.Print CurrentWS.Name
      
   Next
   
   Worksheets(1).Activate

End Sub

    Sub ApplyCondFormatToFilesInFolder()
    'Excel VBA code to loop through files in a folder with Excel VBA

    Dim MyFolder, MyFile, ActiveFile As String

    'Opens a file dialog box for user to select a folder

    With Application.FileDialog(msoFileDialogFolderPicker)
       .AllowMultiSelect = False
       .Show
       MyFolder = .SelectedItems(1)
       Err.Clear
    End With

    'stops screen updating, calculations, events, and statsu bar updates to help code run faster
    'you'll be opening and closing many files so this will prevent your screen from displaying that

    Application.ScreenUpdating = False
    Application.DisplayStatusBar = False
    Application.EnableEvents = False
    Application.Calculation = xlCalculationManual

    'This section will loop through and open each file in the folder you selected
    'and then close that file before opening the next file

    MyFile = Dir(MyFolder & "\")
    ActiveFile = ThisWorkbook.Name

    Do While MyFile <> ""
        DoEvents
        On Error GoTo 0

        If StrComp(MyFile, ActiveFile) = 0 Then
          GoTo ContinueWhile
        End If

        Workbooks.Open Filename:=MyFolder & "\" & MyFile, UpdateLinks:=False
        Debug.Print MyFile
        ''''''''''''ENTER YOUR CODE HERE TO DO SOMETHING'''''''''
        
ContinueWhile:
        MsgBox MyFile
        Call ApplyCondFormatToRangeLoop
        ''''''''''''ENTER YOUR CODE HERE TO DO SOMETHING'''''''''
0
        Workbooks(MyFile).Close SaveChanges:=True
        MyFile = Dir
    Loop

    'turns settings back on that you turned off before looping folders

    Application.ScreenUpdating = True
    Application.DisplayStatusBar = True
    Application.EnableEvents = True
    Application.Calculation = xlCalculationAutomatic

    End Sub


