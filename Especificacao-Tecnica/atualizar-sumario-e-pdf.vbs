' Abre o .docx no Word, atualiza o sumario, grava e exporta o PDF.
' Uso: cscript //nologo atualizar-sumario-e-pdf.vbs <arquivo.docx> [<saida.pdf>]
' Fica em VBScript porque as chamadas longas do Word (gravar, exportar PDF) travam a ponte COM
' do Windows PowerShell 5.1 com 100% de CPU; pelo cscript a sequencia inteira leva menos de um minuto.
Option Explicit
Dim docx, pdf, word, doc, t0, paginas
docx = WScript.Arguments(0)
pdf = ""
If WScript.Arguments.Count > 1 Then pdf = WScript.Arguments(1)
t0 = Timer
Sub Log(m): WScript.Echo "  " & Round(Timer - t0) & "s " & m: End Sub
Set word = CreateObject("Word.Application")
word.Visible = False
word.DisplayAlerts = 0
On Error Resume Next
Set doc = word.Documents.Open(docx, False, False)
If Err.Number <> 0 Then
  WScript.Echo "ERRO ao abrir " & docx & ": " & Err.Description
  word.Quit
  WScript.Quit 1
End If
On Error GoTo 0
Log "aberto"
doc.TablesOfContents(1).Update
paginas = doc.ComputeStatistics(2)
Log "sumario atualizado (" & paginas & " paginas)"
doc.Save
Log "docx gravado"
If pdf <> "" Then
  doc.ExportAsFixedFormat pdf, 17
  Log "pdf exportado"
End If
WScript.Echo "PAGINAS=" & paginas & " TABELAS=" & doc.Tables.Count & " FIGURAS=" & doc.InlineShapes.Count & " SECOES=" & doc.Sections.Count
doc.Close 0
word.Quit
