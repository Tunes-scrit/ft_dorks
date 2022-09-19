#!/usr/bin/bash
# Autor: Tucirateam
# Contato: tunesteste@gmail.com
v="1.0"
# Ano: 2022

# Este script (1) identifica, (2) faz o download e (3) analisa (metadados) o tipo de ficheiros existentes (pdf,php,xml...) em um dominio na internet (google,duckduckgo) de forma automática.

## Modo de funcionamento: ./ficheiro.sh

######################################### !!!!!!! ATENÇÃO !!!!!!! ##################################################################
#														                   #
# - A wordlist deve conter somente a extenção dos ficheiros (ex:pdf,php,xml,png,...)				                   #
# - O script para funcionar corretamente, o sistema deve ter as seguintes ferramentas instaladas: proxychains, tor, lynx, exiftool #
#														                   #
####################################################################################################################################

# Variaveis das cores
c1="\033[00;34m" # azul
c2="\033[01;37;00m" # reset
c3="\033[00;35m" # roxo
c4="\033[00;32m" # verde
c5="\033[01;31m" # vermelho
c6="\033[00;33m" # amarelo

# Logotipo
printf "\n\n"
echo -e "$c5        _  _   _                                       _                              _         $c2"      
echo -e "$c5      _(_)(_) (_)                                     (_)                            (_)        $c2"      
echo -e "$c5   _ (_) _  _ (_) _  _                        _  _  _ (_)    _  _  _    _       _  _ (_)     _  $c2"      
echo -e "$c5  (_)(_)(_)(_)(_)(_)(_)                     _(_)(_)(_)(_) _ (_)(_)(_) _(_)_  _ (_)(_)(_)   _(_) $c2"      
echo -e "$c6     (_)      (_)                          (_)        (_)(_)         (_) (_)(_)      (_) _(_)   $c2"      
echo -e "$c6     (_)      (_)     _                    (_)        (_)(_)         (_) (_)         (_)(_)_    $c2"      
echo -e "$c4     (_)      (_)_  _(_)                   (_)_  _  _ (_)(_) _  _  _ (_) (_)         (_)  (_)_  $c2"      
echo -e "$c4     (_)        (_)(_)                       (_)(_)(_)(_)   (_)(_)(_)    (_)         (_)    (_) $c2"      
echo -e "$c4                           _  _  _  _  _  _  _                                                  $c2"         
echo -e "$c4                          (_)(_)(_)(_)(_)(_)(_)                                                 $c2"         
printf  "\n"
echo -e "	  @ Tucirateam  							Versão: $v             "
printf "\n"


## Variáveis dos diretorios que o script utiliza
l1="/home/tucira/smart-recon/ferramentas/webrecon/webrecon_base/business/ficheiro_temp"
b03="/home/tucira/smart-recon/ferramentas/webrecon/webrecon_base/business"
b0="/home/tucira/smart-recon/ferramentas/webrecon/webrecon_base/business/download_documentos/"

## Inicio da função para o usuário introduzir o Dominio e a Wordlist

# Dominio
echo -e "\n$c3[?] Digite o Dominio: $c2"
echo -e "$c6[!] Exemplo: desecsecurity.com$c2\n"
read -p '[R] ' a1
# Verificar se foi digitado o endereço de um Dominio
	if [ -z "$a1" ] 
	then
		echo -e "\n$c5[/!\] Exemplo do Modo de Funcionamento: desecsecurity.com$c2"
		exit
	else
		printf ""
	fi
# Wordlist
echo -e "\n$c3[?] Digite o local da Wordlist com o(s) tipo(s) de Ficheiro(s) que pretende procurar:$c2"
echo -e "$c6[!] Exemplo: /home/wordlist/minhalista.txt$c2\n"
read -p '[R] ' ftlist
# Verificar se foi digitado o endereço de uma Wordlist
	if [ -z "$ftlist" ] 
	then
		echo -e "\n$c5[/!\] Exemplo do Modo de Funcionamento: /home/wordlist/minhalista.txt$c2" && exit
	else
		printf ""
	fi
# Verificar se existe a Wordlist no endereço digitado
	if [ -f "$ftlist" ]
	then
		printf ""
	else
		printf "$c5[/!\] Wordlist inexistente!$c2" && exit
	fi
## Fim da função para o usuário introduzir o Dominio e a Wordlist


## Inicio da função para procurar no Google o tipo de ficheiro existente na wordlist
printf "\n\n$c1------- Identificar Tipo(s)s de Ficheiro(s) em $c2$a1$c1 -------$c2\n\n"

printf "\n$c4[+] Pesquisar no Google:$c2\n"
	for var1 in $(cat $ftlist)
	do
		sleep 8
		lynx --dump -cookies "https://google.com/search?&q=site:$a1 filetype:$var1" | cut -d '=' -f2 | egrep -v "site|google|1&" | sed 's/...$//' | grep "http" >> $l1
	done
res=$(cat $l1) 
	if [ -z "$res" ]
	then
		printf "\n$c5 Não encontrou nada! - Verificar manualmente$c2\n"
	else
		cat $l1 | sort | uniq >> $b03/$a1 && cat $l1 | awk '{print "\033[01;32m""[-] ""\033[01;37;00m"$0}' | sort | uniq && printf "$c6[!] Url(s) guardado(s) no Diretório:\n$c2$c4[-]$c2 $b03/$a1" && rm -f $l1
	fi
# Fim da função para procurar no Google o tipo de ficheiro existente na wordlist


## Inicio da função para procurar no DuckDuckGo o tipo de ficheiro existente na wordlist
service tor start
sleep 3
printf "\n\n$c4[+] Pesquisar no Duckduckgo:$c2\n"
	for var1 in $(cat $ftlist)
	do
		service tor restart
	sleep 8
		proxychains4 -q lynx --dump -cookies "https://duckduckgo.com/?q=site:$a1+filetype:$var1" >> $l1 2>/dev/null
	done
cat $l1 | grep "http" | cut -d '=' -f2 | sed 's/&rut/ /' | egrep -v "www.google.com|duckduckgo.com" | sort | uniq >> $b03/$a1
res2=$(cat $b03/$a1) 
	if [ -z "$res2" ]
	then
		printf "\n$c5 Não encontrou nada! - Verificar manualmente$c2\n" && rm -f $l1 && rm -f $b03/$a1 && exit
	else
		cat $b03/$a1 | awk '{print "\033[01;32;40m""[-] ""\033[01;37;00m"$0}' | sort | uniq && printf "$c6[!] Url(s) guardado(s) no Diretório:\n$c2$c4[-]$c2 $b03/$a1" && rm -f $l1 
	fi
# Fim da função para procurar no DuckDuckGo o tipo de ficheiro existente na wordlist


## Inicio da função para analisar o tipo(s) de ficheiro(s) descoberto(s) (Metadados)

# Acção para perguntar se o usuario quer analisar os dados dos ficheiros descobertos
res3=$(cat $b03/$a1) 
	if [ -z "$res3" ]
	then
		printf "\n$c5[!] A ferramenta não encontrou nenhum tipo de ficheiro(s) da wordlist no dominio$c2 $a1" && exit 
	else
		tficheiro=$(wc -l $b03/$a1 | awk '{printf $1}')
		echo -e "\n\n$c3[Metadados] Analisar$c2 $tficheiro$c3 Ficheiro(s) Identificado(s) ?$c2"
		printf "$c4[s] SIM$c2" && printf "\n$c4[n] NÃO$c2\n\n"
		read -p '[R] ' a3
	fi
# Acção para analisar dados dos ficheiros descobertos
	if [ "$a3" == "s" ]
	then
		printf "\n\n$c1------- Identificar Metadados do(s) Ficheiro(s) Identificados em $c2$a1$c1 -------$c2\n\n"
		printf "\n$c4[+] Pesquisar Metadados:$c2\n\n"
		mkdir $b0$a1/
			for url in $(cat $b03/$a1)
			do
				wget -q $url -P $b0/$a1/
			done
		exiftool $b0$a1/* | tee -a $b03/$a1-meta 2> /dev/null && printf "\n$c6[!] Metadados guardado(s) no Diretório:$c2\n$c4[-]$c2 $b03/$a1-meta"
	else
		printf ""
	fi
## Fim da função para analisar o tipo(s) de ficheiro(s) descoberto(s) (Metadados)

printf "$c1\n\nAdeus..Goodbye..Wiedersehen..au revoir..до свидания..再见..addio..وداعا\n\n$c2"
exit
