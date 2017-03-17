Projeto om007-Tests
====================

Projeto responsável por validar as regras de negócios das principais **Packages (procedures/functions)** do projeto **OM007**. Todos os testes automatizados são escritos em Java usando as seguintes tecnologias:

1. **jUnit**;
2. **DbUnit**: biblioteca usada para limpar e popular as tabelas do banco de dados;
3. **Spring**: framework Spring para DI (injeção de dependências) e API simplificada para acesso a banco de dados e chamadas de procedures e functions;
4. **Spring-Testing**: módulo do Spring com engine de testes de integração;

Para gerenciamento de dependências e configuração do projeto no Eclipse o  **Gradle** está sendo utilizado.

Configurando o Proxy no Bash
----------------------------

A maioria dos passos serão executados via linha de comando (**Bash**). Dessa forma, se faz necessário configurar o **proxy** da rede antes:

1. Configure o proxy na sessão do **Bash**:

```sh
export http_proxy=http://mdbpx.mdb.com.br:8090
export https_proxy=http://mdbpx.mdb.com.br:8090
```
2. (opcional) Para configurar o **proxy global** no Bash, basta adicionar os comandos acima no arquivo `$HOME/.bash_profile` do seu usuário; caso o arquivo não exista, crie-o. O arquivo `.bash_profile` deve ficar semelhante a este:

```sh
#!/bin/bash

export http_proxy=http://mdbpx.mdb.com.br:8090
export https_proxy=http://mdbpx.mdb.com.br:8090

# outros comandos da sua bash
```

Configurando o projeto no Eclipse
---------------------------------

O ambiente de desevolvimento do projeto é configurado através da ferramenta **Gradle**. Ela se encarregará de baixar todas as dependências (libs) e configurar o projeto no Eclipse, tudo através de linha de comando.

**IMPORTANTE**: Instale e utilize o Java 8, pois o Java 6 não recebe mais suporte da Oracle desde Fevereiro de 2013. Você pode utilizar o Java da Oracle.

Para configurar o projeto siga os passos:

1. Baixe o projeto do Git da empresa, basta clona-lo:

```shell
git clone http://Ter00927@git.mdb.com.br/FSW/om007-tests
```

2. Agora, precisamos configurar o Proxy da rede. Para isso, siga os seguinte comandos:
	- Abra o arquivo `$HOME/.gradle/gradle.properties`, caso ele não exista crie um;
	- Copie a seguinte configuração para o arquivo:
```properties
systemProp.http.proxyHost=mdbpx.mdb.com.br
systemProp.http.proxyPort=8090
systemProp.http.nonProxyHosts=localhost|127.0.0.1|10.10.1.*
systemProp.https.proxyHost=mdbpx.mdb.com.br
systemProp.https.proxyPort=8090
systemProp.https.nonProxyHosts=localhost|127.0.0.1|10.10.1.*
```
	- Atualize as informações se necessário;

2. Configure o projeto para ser importado pelo Eclipse (os arquivos `.project`, `.classpath` e `.settings` serão criados). Pode demorar um pouco ao executar este comando pela primeira vez, pois o Gradle precisará baixar todas as dependências do projeto:
```shell
cd om007-tests
./gradlew cleanEclipse eclipse
```

3. Importe o projeto no Eclipse;
4. (opcional) Caso não tenha o Java 8, configure o projeto no Eclipse para apontar para o Java 7;

Configurando o Banco de Dados
-----------------------------

Para rodar a bateria de testes é necessário ter um banco local, como o **Oracle XE**. Nesse caso, para manter o padrão da configuração do Oracle nas máquinas de todos os desenvolvedores, estamos mantendo um ambiente virtualizado via [VirtualBox](https://www.virtualbox.org/) e [Vagrant](http://www.vagrantup.com/). Portanto, você deve instalar estas ferramentas e configurar sua máquina para suportar virtualização via hardware. Siga os passos:

- Instale a [VirtualBox](https://www.virtualbox.org/) (recomenda-se a versão **5.1.6**);
- Instale o [Vagrant](http://www.vagrantup.com/) (recomenda-se a versão **1.8.6**);
- Habilite a [virtualização via hardware](http://www.sysprobs.com/disable-enable-virtualization-technology-bios) da sua máquina;
- Por fim, faça o clone [desse repositório](https://github.com/rponte/vagrant-ubuntu-oracle-xe) e siga seu README;

Com o fim do processo, você poderá se conectar no seu Oracle XE local com usuário `system` e senha `manager`. Recomendamos a ferramenta [Oracle SQL Developer](http://www.oracle.com/technetwork/developer-tools/sql-developer/overview/index-097090.html).

Gerando o schema no banco de dados
----------------------------------

Com o banco de dados configurado e rodando, o próximo passo é criar o schema com as tabelas, views, packages e outros objetos do Oracle. Para que o schema seja criado de forma automatizada, estamos usando a ferramenta de migrations [Flyway](https://flywaydb.org/). Dessa forma, rode o seguinte comando a partir da raiz desse projeto:

```shell
./gradlew flywayClean flywayMigrate flywayInfo
```

O Gradle está executando 3 comandos em sequência:

- **flywayClean**: dropa o schema e cria um novo schema vazio;
- **flywayMigrate**: roda todas as migrations para criação das tabelas, views, e packages;
- **flywayInfo**: exibe informações sobre o versionamento do banco e migrations aplicadas;

Estes comandos podem ser executados individualmente.

Após rodá-los, você deve ter o schema `MDB_IMDB_TEST` (configuração de conexão está no arquivo **gradle.properties**) criado no seu banco de dados com todos os objetos dentro. Use o SQL Developer para acessar este schema.

**PS**: quer entender como Migrations funciona? Recomendo o [vídeo desta palestra](https://www.youtube.com/watch?v=BQICWePrLg0).

Rodando a bateria de testes via Gradle
--------------------------------------
ATENÇÃO: Lembre-se que todos os testes de integração precisam de acesso ao banco de dados, logo é necessário que você tenha acessa ao Oracle XE local e os devidos schemas utilizados para esse projeto.

Basta executar o comando abaixo:

```shell
./gradlew test
```

Se todos os testes de integração passarem você verá ao final da execução a mensagem "**BUILD SUCCESSFUL**".

Qualquer dúvida, basta falar com o Rafael Ponte, [rponte@gmail.com](rponte@gmail.com)
