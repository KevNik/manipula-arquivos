Write-Output "
`n O SCRIPT LÊ TODOS OS ARQUIVOS DA PASTA ATUAL DE ORIGEM E VERIFICA SE EXISTE UM PASTA COM O MESMO NOME NO PASTA DESTINO,
`n CASO EXISTA ELE **MOVE** PRA ESSA PASTA DE MESMO NOME NA PASTA DESTINO, 
`n SENÂO CRIA E **MOVE** PARA A **PASTA DESTINO**
`n
"

$caminhoDaPastaDosArquivos = Read-Host "DIGITE O CAMINHO ABSOLUTO DA PASTA DE ORIGEM DOS ARQUIVOS"

$arquivosDaPasta = Get-ChildItem -Path $caminhoDaPastaDosArquivos

Write-Output "
`n DIGITE O CAMINHO ABSOLUTO DA PASTA DESTINO
`n CASO A PASTA TENHA ESPAÇO NO NOME, COLOQUE O CAMINHO ENTRE ASPAS
`n EXEMPLO DE CAMINHO ABSOLUTO SEM ESPAÇO: C:\Usuarios\usuario\documents\PastaDestino
`n EXEMPLO DE CAMINHO ABSOLUTO COM ESPAÇO: 'C:\Usuarios\usuario\documents\Pasta Destino'
"

$pastaDestinoPai = Read-Host "DIGITE O CAMINHO ABSOLUTO"

Write-Output "Verificando integridade da pasta de origem dos arquivos"

if (Test-Path -Path $arquivos) {

    Write-Output "Recebendo arquivos da pasta de origem"
    $arquivos = @($arquivosDaPasta)

    foreach ( $arquivo in $arquivos ){
        $fileName = $arquivo.Name
        Write-Output "Verificando extensão do arquivo $fileName"
        if ($arquivo.extension -ne '.ps1') { 
            Write-Output "Verificando integridade do arquivo $fileName"

            $filePath = "$caminhoDaPastaDosArquivos\$fileName"

            if (Test-Path -Path $filePath -PathType leaf) {
                Write-Output "realizando processos para mover o arquivo..."

                $diretorioDoArquivo = $arquivo.DirectoryName
                $nomeDoArquivo = $arquivo.name
    
                $caminhoDoArquivo  = "$diretorioDoArquivo\$nomeDoArquivo"

                Write-Output "Verificando existência da pasta destino $pastaDestinoPai"

                if (Test-Path -Path $pastaDestinoPai) {
    
                    $nomeDaPastaFilha = [System.IO.Path]::GetFileNameWithoutExtension($caminhoDoArquivo) 
    
                    $pastaDestinoFilho = "$pastaDestinoPai\$nomeDaPastaFilha"
                        
                        Write-Output "Verificando se existe uma pasta com o mesmo do arquivo"
                        if (Test-Path -Path $pastaDestinoFilho) {
                            Write-Output "Movendo o arquivo $nomeDaPastaFilha para a pasta $pastaDestinoFilho"
                            Move-Item -Path $caminhoDoArquivo -Destination $pastaDestinoFilho
                        } else {
                            Write-Output "Gerando pasta com mesmo nome do arquivo $nomeDaPastaFilha"
                            $gerenciadorDeArquivos = new-object -ComObject scripting.filesystemobject
                            $gerenciadorDeArquivos.CreateFolder("$pastaDestinoFilho")
                            Write-Output "Verificando integridade da pasta"
                            if (Test-Path -Path $pastaDestinoFilho) {
                                Write-Output "Movendo o arquivo $nomeDaPastaFilha para a pasta $pastaDestinoFilho"
                                Move-Item -Path $caminhoDoArquivo -Destination $pastaDestinoFilho
                            }
                        } 
                }
            }
        
        }
    }
}