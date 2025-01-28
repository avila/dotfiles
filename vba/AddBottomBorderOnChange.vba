Sub AddBottomBorderOnChangeLv1()
    Dim ws As Worksheet
    Dim lastRow As Long
    Dim pidColumn As Long
    Dim i As Long

    ' Use the active sheet
    Set ws = ActiveSheet

    ' Find the column named "pid" in the first row
    pidColumn = 0
    For i = 1 To ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column
        If LCase(ws.Cells(1, i).Value) = "pid" Then
            pidColumn = i
            Exit For
        End If
    Next i

    ' If "pid" column not found, use the current selected column
    If pidColumn = 0 Then
        MsgBox "Column 'pid' not found! Using the current selected column.", vbExclamation
        pidColumn = Selection.Column
    End If

    ' Find the last row in the selected column
    lastRow = ws.Cells(ws.Rows.Count, pidColumn).End(xlUp).Row

    ' Loop through rows
    For i = 2 To lastRow ' Assuming headers are in the first row
        ' Compare the current value with the next
        If ws.Cells(i, pidColumn).Value <> ws.Cells(i + 1, pidColumn).Value Then
            ' Add a bottom border to the current row
            With ws.Rows(i).Borders(xlEdgeBottom)
                .LineStyle = xlDot ' xlContinuous
                .Weight = xlThin
                .Color = RGB(66, 66, 66) ' Black color
            End With
        End If
    Next i
End Sub


Sub AddBottomBorderOnChangeLv2()
    Dim ws As Worksheet
    Dim lastRow As Long
    Dim pidColumn As Long
    Dim i As Long

    ' Use the active sheet
    Set ws = ActiveSheet

    ' Find the column named "pid" in the first row
    pidColumn = 0
    For i = 1 To ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column
        If LCase(ws.Cells(1, i).Value) = "hid" Then
            pidColumn = i
            Exit For
        End If
    Next i
    For i = 1 To ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column
        If LCase(ws.Cells(1, i).Value) = "cid" Then
            pidColumn = i
            Exit For
        End If
    Next i

    ' If "pid" column not found, use the current selected column
    If pidColumn = 0 Then
        MsgBox "Column 'pid' not found! Using the current selected column.", vbExclamation
        pidColumn = Selection.Column
    End If

    ' Find the last row in the selected column
    lastRow = ws.Cells(ws.Rows.Count, pidColumn).End(xlUp).Row

    ' Loop through rows
    For i = 2 To lastRow ' Assuming headers are in the first row
        ' Compare the current value with the next
        If ws.Cells(i, pidColumn).Value <> ws.Cells(i + 1, pidColumn).Value Then
            ' Add a bottom border to the current row
            With ws.Rows(i).Borders(xlEdgeBottom)
                .LineStyle = xlContinuous ' xlDot
                .Weight = xlThin
                .Color = RGB(33, 33, 33) ' Black color
            End With
        End If
    Next i
End Sub



Sub AddBottomBorderOnChangeSOEP()
 Call AddBottomBorderOnChangeLv1
 Call AddBottomBorderOnChangeLv2
 
End Sub



