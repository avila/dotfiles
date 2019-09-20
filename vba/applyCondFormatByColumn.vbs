
Sub ApplyCondFormatToRange()
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

Sub WorksheetLoop2()

   ' Declare Current as a worksheet object variable.
   Dim CurrentWS As Worksheet

   ' Loop through all of the worksheets in the active workbook.
   For Each CurrentWS In Worksheets
      CurrentWS.Activate
      
      ' Insert your code here.
      Call ApplyCondFormatToRange
      
      ' This line displays the worksheet name in a message box.
      Debug.Print Current.Name
      
   Next

End Sub
