import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;


main() {
  //lista que armazenara os endereços de cada arquivo
  List<String> files = List<String>();

  //percorre todos os arquivos do diretorio
  Directory.current.listSync().forEach((FileSystemEntity fse){
    //verifica se é arquivo
    if (fse.statSync().type == FileSystemEntityType.file) {
      //adiciona o endereço de cada arquivo a lista
      files.add(fse.path);
    }
  });

  //endereço e nome do arquivo a ser gerado
  String zipfile = '${Directory.current.path}/comprimindo.zip';

  //comprime a lista de arquivos gerando o zip
  zip(files, zipfile);

  //endereço da pasta onde sera descompactado o arquivo
  unzip(zipfile, '${Directory.current.path}/descomprimindo');
}

void zip(List<String> files ,String file){
  //cria arquivo
  Archive archive = Archive();

  //percorre a array de endereços
  files.forEach((String path){
    //instancia cada arquivo pelo seu endereço na variavel file
    File file = File(path);

    //cria a archiveFile
    ArchiveFile archiveFile = ArchiveFile(p.basename(path), file.lengthSync(), file.readAsBytesSync());

    //adiciona a archiveFile ao lista de arquivos que serão comprimidos
    archive.addFile(archiveFile);
  });

  //instacia o compressor
  ZipEncoder encoder = ZipEncoder();

  //cria o arquivo que sera nosso arquivo.zip
  File f = File(file);

  //escreve nesse arquivo a lista de arquivos codificada em zip
  f.writeAsBytesSync(encoder.encode(archive));

  print('Comprimido com sucesso!');
}
void unzip(String zip, String path){
  //instancia o arquivo zip pelo endereço
  File file = File(zip);
  //cria a lista de arquivos decodificados
  Archive archive = ZipDecoder().decodeBytes(file.readAsBytesSync());

  //percorre a lista de arquivos e gera novamente cada arquivo no endereço path
  archive.forEach((ArchiveFile archiveFile){
    File file = File(path +'/'+archiveFile.name);//cria o arquivo pelo nome
    file.createSync(recursive: true);//efetua o procedimento em subpastas se ouver
    file.writeAsBytes(archiveFile.content);//adiciona a informação contida em cada arquivo
  });
  print('Descomprimindo!!!!!!!');
}