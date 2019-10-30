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
    'Application.Calculation = xlCalculationManual

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
        
ContinueWhile:
        Call ApplyCondFormatToRangeLoop

0
        Workbooks(MyFile).Close SaveChanges:=True
        MyFile = Dir
    Loop

    'turns settings back on that you turned off before looping folders

    Application.ScreenUpdating = True
    Application.DisplayStatusBar = True
    Application.EnableEvents = True
    'Application.Calculation = xlCalculationManual

    End Sub

Public Sub ApplyCondFormatToRange()
'Finds the last non-blank cell in a single row or column
    
    Dim lRow, lCol As Integer
    Dim Current As Worksheet
    Dim ColNr As Integer
    
        
        'Find the last non-blank cell in column A(1) (checking from col A)
        ' how? from cell A1 -> two times ctrl+down. then get row number
        lRow = Cells(1, 1).End(xlDown).End(xlDown).Row
        
        'Find the last non-blank cell in row 2 (checking from 6th rown)
        ' from last row once ctrl+right to get last col
        lCol = Cells(lRow, 1).End(xlToRight).Column
        
        'Find the last non-blank cell in column A(1) [- 1 cuz total row] (checking from col A)
        'lRow = Cells(Rows.Count, 1).End(xlUp).Row - 1
        
        celltxt = Cells(lRow, 1).Text
        If InStr(1, celltxt, "Total") Then
            MsgBox "Found 'total' row. Subtract one from Last Col" & vbNewLine & _
                    "Last Row: " & lRow & vbNewLine & _
                    "Last Column: " & lCol & "-1"
            lCol = lCol - 1
        Else
            MsgBox "No 'Total' Found" & vbNewLine & _
                    "Last Row: " & lRow & vbNewLine & _
                    "Last Column: " & lCol
        End If
        
        'Range("A2").CurrentRegion.ClearFormats

        For ColNr = 2 To lCol
            Set rg = Range(Cells(3, ColNr), Cells(lRow, ColNr))
            Set Db = rg.FormatConditions.AddDatabar
                Db.ShowValue = True
                Db.BarColor.TintAndShade = 0
                Db.BarFillType = xlDataBarFillSolid

            Debug.Print ColNr
        Next ColNr
End Sub



