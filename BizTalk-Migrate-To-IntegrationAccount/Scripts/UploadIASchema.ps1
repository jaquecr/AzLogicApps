##################################################
#Upload Schemas#
##################################################

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
$Path = "C:\Schemas"
$PathFileNames = "C:\FileSchemas.txt"

#Ler e exportar para o .txt nome + extensão dos arquivos
$Schemas = Get-ChildItem -Path $Path -Name | Out-String | Out-File $PathFileNames

#Para cada arquivo da lista, tratamento e upload para o Integration Account
foreach ($lines in Get-Content $PathFileNames)
{
    $Schema_name = $lines
    $Schema = $lines.Replace(".xsd","")
    $SchContent = Get-content $Path\$lines | Out-String
    
    try
    {
        New-AzureRmIntegrationAccountSchema -ResourceGroupName $ResourceGroup -Name $IntegrationAccount -SchemaName $Schema -SchemaFilePath $Path\$Schema_name -ErrorAction Stop
        Write-Warning "Arquivo importado com sucesso"
    }
    catch
    {
        Write-Warning $ErrorMessage
        Break
    }
    finally
    {
        $Time = Get-Date
        Write-Warning "Log gravado"
        "$Time" + ":" + "$ErrorMessage" | Out-File "C:\Logs\Logs.log" -append
    }
}

