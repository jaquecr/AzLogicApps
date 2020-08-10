###############################################
#Maps#
###############################################

#Login Azure, se a sessão não estiver salva ou não iniciada
#Connect-AzureRmAccount

#param(
#$ResourceGroup, #Nome do Resource Group onde está localizado o Integration Account
#$IntegrationAccount, #Nome do Integration Account
#$Path, #Diretório/Pasta onde estão localizados os arquivos do tipo schema
#$PathFileNames #Diretório/Pasta onde está localizado o arquivo de texto com lista dos arquivos
#)

$ResourceGroup = "rg-name"
$IntegrationAccount = "ia-name"
$Path = "C:\Maps"
$PathFileNames = "C:\FileNames.txt"

#Ler e exportar para o .txt nome + extensão dos arquivos
$Maps = Get-ChildItem -Path $Path -Name | Out-String | Out-File $PathFileNames

#Para cada arquivo da lista, tratamento e upload para o Integration Account
foreach ($line in Get-Content $PathFileNames)
{
    $Map = $line.Replace(".xslt","")
    $MapContent = Get-content $Path\$line | Out-String

    try
    {
       
        New-AzureRmIntegrationAccountMap -ResourceGroupName $ResourceGroup -Name "IntegrationAccount" -MapName $Map -MapDefinition $MapContent -ErrorAction Stop
        Write-Warning "Arquivo importado com sucesso"
    }
    catch
    {
        
        Write-Warning $Error[0]
        Break
    }
    finally
    {
        $Time = Get-Date
        Write-Warning "Log gravado"
        "$Time$Error[0]" | Out-File "C:\Logs\Logs.log" -append
    }
}





 




