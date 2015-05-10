#!/bin/bash
# j.francisco.o.rocha@gmail.com
# @09.2012
# ./smsTest.sh

if [ "$(id -u)" != "0" ]; then
    echo "Tem de executar este script como Super User!"
    exit 0
fi

if [ "$(dpkg -l | grep -i "ii  dialog" | awk -F '  ' '{print $2}' 2>/dev/null)" != "dialog" ]; then
echo -e '\E[1;37m\033[1mO seu sistema não tem o comando dialog pelo que sera qinstalado agora ...\033[0m'
sudo apt-get install dialog -y &> /dev/null
fi

dirDestMsg="/usr1/sms"
dirDestWorten="/home/francisco/websites/worten"
dirProcesWorten="/home/francisco/websites/worten"

#dirDestMsg="."
#dirDestDat="."
#dirDestLog="."

numeroDest01="916644665"
numeroDest02="912256928"
numeroDest03="919402942"

function onOff3G () {
    ESTADO=""
    ESTADO=`nmcli -t -f TYPE,STATE dev | grep "^gsm:"`
    if [[ "$1" == "" ]]; then
        echo "Error: Não indicou se quer desligar ou ligar"
    fi
    if [[ "$1" == "on" ]]; then
        if [[ "$ESTADO" == "gsm:desligado" ]]; then
            nmcli -t con up id TMN
            ESTADO=`nmcli -t -f TYPE,STATE dev | grep "^gsm:"`
        fi
    fi
    if [[ "$1" == "off" ]]; then
        if [[ "$ESTADO" == "gsm:ligado" ]]; then
            nmcli -t con down id TMN
            ESTADO=`nmcli -t -f TYPE,STATE dev | grep "^gsm:"`
        fi
    fi
    }

function limparCodeHTML () {
    limparCodeHTML=$(echo -e "$1" | sed -e '{
        s/\    /\…/g
        s/\/\`/g
        s/\/\"/g
        s/\&#x96\;/–/g
        s/\&#x92\;/\̒/g
        s/\&rdquo\;/\”/g
        s/\&#xFB\;/\û/g
        s/\&#xF4\;/\ô/g
        s/\&#8221\;/\”/g
        s/\&#x201D\;/\”/g
        s/\&quot\;/\"/g
        s/\&#34\;/\"/g
        s/\&#x22\;/\"/g
        s/\&#39\;/\`/g
        s/\&#x27\;/\`/g
        s/\&#176\;/\°/g
        s/\&deg\;/\°/g
        s/\&#43\;/\0/g
        s/\&#177\;/\±/g
        s/\&plusmn\;/\±/g
        s/\&#247\;/\÷/g
        s/\&divide\;/\÷/g
        s/\&#215\;/\×/g
        s/\&times\;/\×/g
        s/\&#60\;/\</g
        s/\&lt\;/\</g
        s/\&#61\;/\=/g
        s/\&#62\;/\>/g
        s/\&gt\;/\>/g
        s/\&#172\;/\¬/g
        s/\&not\;/\¬/g
        s/\&#124\;/\|/g
        s/\&#166\;/\¦/g
        s/\&brvbar\;/\¦/g
        s/\&#126\;/\~/g
        s/\&#164\;/\¤/g
        s/\&curren\;/\¤/g
        s/\&#162\;/\¢/g
        s/\&cent\;/\¢/g
        s/\&#36\;/\$/g
        s/\&#163\;/\£/g
        s/\&pound\;/\£/g
        s/\&#165\;/\¥/g
        s/\&yen\;/\¥/g
        s/\&#185\;/\¹/g
        s/\&sup1\;/\¹/g
        s/\&#189\;/\½/g
        s/\&frac12\;/\½/g
        s/\&#188\;/\¼/g
        s/\&frac14\;/\¼/g
        s/\&#178\;/\²/g
        s/\&sup2\;/\²/g
        s/\&#179\;/\³/g
        s/\&sup3\;/\³/g
        s/\&#190\;/\¾/g
        s/\&frac34\;/\¾/g
        s/\&#65\;/\A/g
        s/\&#97\;/\a/g
        s/\&#170\;/\ª/g
        s/\&ordf\;/\ª/g
        s/\&#193\;/\Á/g
        s/\&#225\;/\á/g
        s/\&Aacute\;/\Á/g
        s/\&aacute\;/\á/g
        s/\&#192\;/\À/g
        s/\&#224\;/\à/g
        s/\&Agrave\;/\À/g
        s/\&agrave\;/\à/g
        s/\&#194\;/\Â/g
        s/\&#226\;/\â/g
        s/\&Acirc\;/\Â/g
        s/\&acirc\;/\â/g
        s/\&#197\;/\Å/g
        s/\&#229\;/\å/g
        s/\&Aring\;/\Å/g
        s/\&aring\;/\å/g
        s/\&#196\;/\Ä/g
        s/\&#228\;/\ä/g
        s/\&Auml\;/\Ä/g
        s/\&auml\;/\ä/g
        s/\&#195\;/\Ã/g
        s/\&#227\;/\ã/g
        s/\&Atilde\;/\Ã/g
        s/\&atilde\;/\ã/g
        s/\&#198\;/\Æ/g
        s/\&#230\;/\æ/g
        s/\&AElig\;/\Æ/g
        s/\&aelig\;/\æ/g
        s/\&#66\;/\B/g
        s/\&#98\;/\b/g
        s/\&#67\;/\C/g
        s/\&#99\;/\c/g
        s/\&#199\;/\Ç/g
        s/\&#231\;/\ç/g
        s/\&Ccedil\;/\Ç/g
        s/\&ccedil\;/\ç/g
        s/\&#68\;/\D/g
        s/\&#100\;/\d/g
        s/\&#208\;/\Ð/g
        s/\&#240\;/\ð/g
        s/\&ETH\;/\Ð/g
        s/\&eth\;/\ð/g
        s/\&#69\;/\E/g
        s/\&#101\;/\e/g
        s/\&#201\;/\É/g
        s/\&#233\;/\é/g
        s/\&Eacute\;/\É/g
        s/\&eacute\;/\é/g
        s/\&#200\;/\È/g
        s/\&#232\;/\è/g
        s/\&Egrave\;/\È/g
        s/\&egrave\;/\è/g
        s/\&#202\;/\Ê/g
        s/\&#234\;/\ê/g
        s/\&Ecirc\;/\Ê/g
        s/\&ecirc\;/\ê/g
        s/\&#203\;/\Ë/g
        s/\&#235\;/\ë/g
        s/\&Euml\;/\Ë/g
        s/\&euml\;/\ë/g
        s/\&#70\;/\F/g
        s/\&#102\;/\f/g
        s/\&#71\;/\ /g
        s/\&#103\;/\ /g
        s/\&#72\;/\H/g
        s/\&#104\;/\h/g
        s/\&#73\;/\I/g
        s/\&#105\;/\i/g
        s/\&#205\;/\Í/g
        s/\&#237\;/\í/g
        s/\&Iacute\;/\Í/g
        s/\&iacute\;/\í/g
        s/\&#204\;/\Ì/g
        s/\&#236\;/\ì/g
        s/\&Igrave\;/\Ì/g
        s/\&igrave\;/\ì/g
        s/\&#206\;/\Î/g
        s/\&#238\;/\î/g
        s/\&Icirc\;/\Î/g
        s/\&icirc\;/\î/g
        s/\&#207\;/\Ï/g
        s/\&#239\;/\ï/g
        s/\&Iuml\;/\Ï/g
        s/\&iuml\;/\ï/g
        s/\&#74\;/\J/g
        s/\&#106\;/\j/g
        s/\&#75\;/\K/g
        s/\&#107\;/\k/g
        s/\&#76\;/\L/g
        s/\&#108\;/\l/g
        s/\&#77\;/\M/g
        s/\&#109\;/\m/g
        s/\&#78\;/\N/g
        s/\&#110\;/\n/g
        s/\&#209\;/\Ñ/g
        s/\&#241\;/\ñ/g
        s/\&Ntilde\;/\Ñ/g
        s/\&ntilde\;/\ñ/g
        s/\&#79\;/\O/g
        s/\&#111\;/\o/g
        s/\&#186\;/\º/g
        s/\&ordm\;/\º/g
        s/\&#211\;/\Ó/g
        s/\&#243\;/\ó/g
        s/\&Oacute\;/\Ó/g
        s/\&oacute\;/\ó/g
        s/\&#210\;/\Ò/g
        s/\&#242\;/\ò/g
        s/\&Ograve\;/\Ò/g
        s/\&ograve\;/\ò/g
        s/\&#212\;/\Ô/g
        s/\&#244\;/\ô/g
        s/\&Ocirc\;/\Ô/g
        s/\&ocirc\;/\ô/g
        s/\&#214\;/\Ö/g
        s/\&#246\;/\ö/g
        s/\&Ouml\;/\Ö/g
        s/\&ouml\;/\ö/g
        s/\&#213\;/\Õ/g
        s/\&#245\;/\õ/g
        s/\&Otilde\;/\Õ/g
        s/\&otilde\;/\õ/g
        s/\&#216\;/\Ø/g
        s/\&#248\;/\ø/g
        s/\&Oslash\;/\Ø/g
        s/\&oslash\;/\ø/g
        s/\&#80\;/\P/g
        s/\&#112\;/\p/g
        s/\&#81\;/\Q/g
        s/\&#113\;/\q/g
        s/\&#82\;/\R/g
        s/\&#114\;/\r/g
        s/\&#83\;/\ /g
        s/\&#115\;/\ /g
        s/\&#223\;/\ß/g
        s/\&szlig\;/\ß/g
        s/\&#84\;/\T/g
        s/\&#116\;/\t/g
        s/\&#85\;/\U/g
        s/\&#117\;/\u/g
        s/\&#218\;/\Ú/g
        s/\&#250\;/\ú/g
        s/\&Uacute\;/\Ú/g
        s/\&uacute\;/\ú/g
        s/\&#48\;/0/g
        s/\&#49\;/1/g
        s/\&#50\;/2/g
        s/\&#51\;/3/g
        s/\&#52\;/4/g
        s/\&#53\;/5/g
        s/\&#54\;/6/g
        s/\&#55\;/7/g
        s/\&#56\;/8/g
        s/\&#57\;/9/g
        s/\&#32\;/\ /g
        s/\#96\;/\`/g
        s/\&#180\;/\´/g
        s/\&acute\;/\´/g
        s/\&#94\;/\^/g
        s/\&#175\;/\¯/g
        s/\&macr\;/\¯/g
        s/\&#168\;/\¨/g
        s/\&uml\;/\¨/g
        s/\&#184\;/\¸/g
        s/\&cedil\;/\¸/g
        s/\&#95\;/\_/g
        s/\&#173\;/\ /g
        s/\&shy\;/\ /g
        s/\&#45\;/\0/g
        s/\&#44\;/\0/g
        s/\&#59\;/\;/g
        s/\&#58\;/\:/g
        s/\&#33\;/\!/g
        s/\&#161\;/\¡/g
        s/\&iexcl\;/\¡/g
        s/\&#63\;/\?/g
        s/\&#191\;/\¿/g
        s/\&iquest\;/\¿/g
        s/\&#46\;/\./g
        s/\&#183\;/\·/g
        s/\&middot\;/\·/g
        s/\&#171\;/\«/g
        s/\&laquo\;/\«/g
        s/\&#187\;/\»/g
        s/\&raquo\;/\»/g
        s/\&#40\;/\(/g
        s/\&#41\;/\)/g
        s/\&#91\;/\[/g
        s/\&#93\;/\]/g
        s/\&#123\;/\{/g
        s/\&#125\;/\}/g
        s/\&#167\;/\§/g
        s/\&sect\;/\§/g
        s/\&#182\;/\¶/g
        s/\&para\;/\¶/g
        s/\&#169\;/\©/g
        s/\&copy\;/\©/g
        s/\&#174\;/\®/g
        s/\&reg\;/\®/g
        s/\&#64\;/\@/g
        s/\&#42\;/\*/g
        s/\&#47\;/\//g
        s/\&#92\;/\\/g
        s/\&#38\;/&/g
        s/\&amp\;/&/g
        s/\&#35\;/\#/g
        s/\&#37\;/\%/g
        s/\&#217\;/\Ù/g
        s/\&#249\;/\ù/g
        s/\&Ugrave\;/\Ù/g
        s/\&ugrave\;/\ù/g
        s/\&#219\;/\Û/g
        s/\&#251\;/\û/g
        s/\&Ucirc\;/\Û/g
        s/\&ucirc\;/\û/g
        s/\&#220\;/\Ü/g
        s/\&#252\;/\ü/g
        s/\&Uuml\;/\Ü/g
        s/\&uuml\;/\ü/g
        s/\&#86\;/\V/g
        s/\&#118\;/\v/g
        s/\&#87\;/\W/g
        s/\&#119\;/\w/g
        s/\&#88\;/\X/g
        s/\&#120\;/\x/g
        s/\&#89\;/\Y/g
        s/\&#121\;/\y/g
        s/\&#221\;/\Ý/g
        s/\&#253\;/\ý/g
        s/\&Yacute\;/\Ý/g
        s/\&yacute\;/\ý/g
        s/\&#255\;/\ÿ/g
        s/\&yuml\;/\ÿ/g
        s/\&#90\;/\Z/g
        s/\&#122\;/\z/g
        s/\&#222\;/\Þ/g
        s/\&#254\;/\þ/g
        s/\&THORN\;/\Þ/g
        s/\&thorn\;/\þ/g
        s/\&#181\;/\µ/g
        s/\&micro\;/\µ/g
        s/\&#160\;/\ /g
        s/\&nbsp\;/\ /g
        s/\&shy\;/\ /g
        s/\&fnof\;/\ƒ/g
        s/\&Alpha\;/\Α/g
        s/\&Beta\;/\Β/g
        s/\&Gamma\;/\Γ/g
        s/\&Delta\;/\Δ/g
        s/\&Epsilon\;/\Ε/g
        s/\&Zeta\;/\Ζ/g
        s/\&Eta\;/\Η/g
        s/\&Theta\;/\Θ/g
        s/\&Iota\;/\Ι/g
        s/\&Kappa\;/\Κ/g
        s/\&Lambda\;/\Λ/g
        s/\&Mu\;/\Μ/g
        s/\&Nu\;/\Ν/g
        s/\&Xi\;/\Ξ/g
        s/\&Omicron\;/\Ο/g
        s/\&Pi\;/\Π/g
        s/\&Rho\;/\Ρ/g
        s/\&Sigma\;/\Σ/g
        s/\&Tau\;/\Τ/g
        s/\&Upsilon\;/\Υ/g
        s/\&Phi\;/\Φ/g
        s/\&Chi\;/\Χ/g
        s/\&Psi\;/\Ψ/g
        s/\&Omega\;/\Ω/g
        s/\&alpha\;/\α/g
        s/\&beta\;/\β/g
        s/\&gamma\;/\γ/g
        s/\&delta\;/\δ/g
        s/\&epsilon\;/\ε/g
        s/\&zeta\;/\ζ/g
        s/\&eta\;/\η/g
        s/\&theta\;/\θ/g
        s/\&iota\;/\ι/g
        s/\&kappa\;/\κ/g
        s/\&lambda\;/\λ/g
        s/\&mu\;/\μ/g
        s/\&nu\;/\ν/g
        s/\&xi\;/\ξ/g
        s/\&omicron\;/\ο/g
        s/\&pi\;/\π/g
        s/\&rho\;/\ρ/g
        s/\&sigmaf\;/\ς/g
        s/\&sigma\;/\σ/g
        s/\&tau\;/\τ/g
        s/\&upsilon\;/\υ/g
        s/\&phi\;/\φ/g
        s/\&chi\;/\χ/g
        s/\&psi\;/\ψ/g
        s/\&omega\;/\ω/g
        s/\&thetasym\;/\ϑ/g
        s/\&upsih\;/\ϒ/g
        s/\&piv\;/\ϖ/g
        s/\&bull\;/\•/g
        s/\&hellip\;/\…/g
        s/\&prime\;/\′/g
        s/\&Prime\;/\″/g
        s/\&oline\;/\‾/g
        s/\&frasl\;/\⁄/g
        s/\&weierp\;/\℘/g
        s/\&image\;/\ℑ/g
        s/\&real\;/\ℜ/g
        s/\&trade\;/\™/g
        s/\&alefsym\;/\ℵ/g
        s/\&larr\;/\←/g
        s/\&uarr\;/\↑/g
        s/\&rarr\;/\→/g
        s/\&darr\;/\↓/g
        s/\&harr\;/\↔/g
        s/\&crarr\;/\↵/g
        s/\&lArr\;/\⇐/g
        s/\&uArr\;/\⇑/g
        s/\&rArr\;/\⇒/g
        s/\&dArr\;/\⇓/g
        s/\&hArr\;/\⇔/g
        s/\&forall\;/\∀/g
        s/\&part\;/\∂/g
        s/\&exist\;/\∃/g
        s/\&empty\;/\∅/g
        s/\&nabla\;/\∇/g
        s/\&isin\;/\∈/g
        s/\&notin\;/\∉/g
        s/\&ni\;/\∋/g
        s/\&prod\;/\∏/g
        s/\&sum\;/\∑/g
        s/\&minus\;/\−/g
        s/\&lowast\;/\∗/g
        s/\&radic\;/\√/g
        s/\&prop\;/\∝/g
        s/\&infin\;/\∞/g
        s/\&ang\;/\∠/g
        s/\&and\;/\∧/g
        s/\&or\;/\∨/g
        s/\&cap\;/\∩/g
        s/\&cup\;/\∪/g
        s/\&int\;/\∫/g
        s/\&there4\;/\∴/g
        s/\&sim\;/\∼/g
        s/\&cong\;/\≅/g
        s/\&asymp\;/\≈/g
        s/\&ne\;/\≠/g
        s/\&equiv\;/\≡/g
        s/\&le\;/\≤/g
        s/\&ge\;/\≥/g
        s/\&sub\;/\⊂/g
        s/\&sup\;/\⊃/g
        s/\&nsub\;/\⊄/g
        s/\&sube\;/\⊆/g
        s/\&supe\;/\⊇/g
        s/\&oplus\;/\⊕/g
        s/\&otimes\;/\⊗/g
        s/\&perp\;/\⊥/g
        s/\&sdot\;/\⋅/g
        s/\&lceil\;/\⌈/g
        s/\&rceil\;/\⌉/g
        s/\&lfloor\;/\⌊/g
        s/\&rfloor\;/\⌋/g
        s/\&lang\;/\〈/g
        s/\&rang\;/\〉/g
        s/\&loz\;/\◊/g
        s/\&spades\;/\♠/g
        s/\&clubs\;/\♣/g
        s/\&hearts\;/\♥/g
        s/\&diams\;/\♦/g
        s/\&OElig\;/\Œ/g
        s/\&oelig\;/\œ/g
        s/\&Scaron\;/\Š/g
        s/\&scaron\;/\š/g
        s/\&Yuml\;/\Ÿ/g
        s/\&circ\;/\ˆ/g
        s/\&tilde\;/\˜/g
        s/\&ensp\;/\ /g
        s/\&emsp\;/\ /g
        s/\&thinsp\;/\ /g
        s/\&zwnj\;/\‌/g
        s/\&zwj\;/\‍/g
        s/\&lrm\;/\‎/g
        s/\&rlm\;/\‏/g
        s/\&ndash\;/\–/g
        s/\&mdash\;/\—/g
        s/\&lsquo\;/\‘/g
        s/\&rsquo\;/\’/g
        s/\&sbquo\;/\‚/g
        s/\&ldquo\;/\“/g
        s/\&bdquo\;/\„/g
        s/\&dagger\;/\†/g
        s/\&Dagger\;/\‡/g
        s/\&permil\;/\‰/g
        s/\&lsaquo\;/\‹/g
        s/\&rsaquo\;/\›/g
        s/\&euro\;/\€/g
        s/\&#xA0\;/\ /g
        s/\&#xA1\;/\¡/g
        s/\&#xA2\;/\¢/g
        s/\&#xA3\;/\£/g
        s/\&#xA4\;/\¤/g
        s/\&#xA5\;/\¥/g
        s/\&#xA6\;/\¦/g
        s/\&#xA7\;/\§/g
        s/\&#xA8\;/\¨/g
        s/\&#xA9\;/\©/g
        s/\&#xAA\;/\ª/g
        s/\&#xAB\;/\«/g
        s/\&#xAC\;/\¬/g
        s/\&#xAD\;/\­/g
        s/\&#xAE\;/\®/g
        s/\&#xAF\;/\¯/g
        s/\&#xB0\;/\°/g
        s/\&#xB1\;/\±/g
        s/\&#xB2\;/\²/g
        s/\&#xB3\;/\³/g
        s/\&#xB4\;/\´/g
        s/\&#xB5\;/\µ/g
        s/\&#xB6\;/\¶/g
        s/\&#xB7\;/\·/g
        s/\&#xB8\;/\¸/g
        s/\&#xB9\;/\¹/g
        s/\&#xBA\;/\º/g
        s/\&#xBB\;/\»/g
        s/\&#xBC\;/\¼/g
        s/\&#xBD\;/\½/g
        s/\&#xBE\;/\¾/g
        s/\&#xBF\;/\¿/g
        s/\&#xC0\;/\À/g
        s/\&#xC1\;/\Á/g
        s/\&#xC2\;/\Â/g
        s/\&#xC3\;/\Ã/g
        s/\&#xC4\;/\Ä/g
        s/\&#xC5\;/\Å/g
        s/\&#xC6\;/\Æ/g
        s/\&#xC7\;/\Ç/g
        s/\&#xC8\;/\È/g
        s/\&#xC9\;/\É/g
        s/\&#xCA\;/\Ê/g
        s/\&#xCB\;/\Ë/g
        s/\&#xCC\;/\Ì/g
        s/\&#xCD\;/\Í/g
        s/\&#xCE\;/\Î/g
        s/\&#xCF\;/\Ï/g
        s/\&#xD0\;/\Ð/g
        s/\&#xD1\;/\Ñ/g
        s/\&#xD2\;/\Ò/g
        s/\&#xD3\;/\Ó/g
        s/\&#xD4\;/\Ô/g
        s/\&#xD5\;/\Õ/g
        s/\&#xD6\;/\Ö/g
        s/\&#xD7\;/\×/g
        s/\&#xD8\;/\Ø/g
        s/\&#xD9\;/\Ù/g
        s/\&#xDA\;/\Ú/g
        s/\&#xDB\;/\Û/g
        s/\&#xDC\;/\Ü/g
        s/\&#xDD\;/\Ý/g
        s/\&#xDE\;/\Þ/g
        s/\&#xDF\;/\ß/g
        s/\&#xE0\;/\à/g
        s/\&#xE1\;/\á/g
        s/\&#xE2\;/\â/g
        s/\&#xE3\;/\ã/g
        s/\&#xE4\;/\ä/g
        s/\&#xE5\;/\å/g
        s/\&#xE6\;/\æ/g
        s/\&#xE7\;/\ç/g
        s/\&#xE8\;/\è/g
        s/\&#xE9\;/\é/g
        s/\&#xEA\;/\ê/g
        s/\&#xEB\;/\ë/g
        s/\&#xEC\;/\ì/g
        s/\&#xED\;/\í/g
        s/\&#xEE\;/\î/g
        s/\&#xEF\;/\ï/g
        s/\&#xF0\;/\ð/g
        s/\&#xF1\;/\ñ/g
        s/\&#xF2\;/\ò/g
        s/\&#xF3\;/\ó/g
        s/\&#xF5\;/\õ/g
        s/\&#xF6\;/\ö/g
        s/\&#xF7\;/\÷/g
        s/\&#xF8\;/\ø/g
        s/\&#xF9\;/\ù/g
        s/\&#xFA\;/\ú/g
        s/\&#xFC\;/\ü/g
        s/\&#xFD\;/\ý/g
        s/\&#xFE\;/\þ/g
        s/\&#xFF\;/\ÿ/g
        s/\&#x192\;/\ƒ/g
        s/\&#x391\;/\Α/g
        s/\&#x392\;/\Β/g
        s/\&#x393\;/\Γ/g
        s/\&#x394\;/\Δ/g
        s/\&#x395\;/\Ε/g
        s/\&#x396\;/\Ζ/g
        s/\&#x397\;/\Η/g
        s/\&#x398\;/\Θ/g
        s/\&#x399\;/\Ι/g
        s/\&#x39A\;/\Κ/g
        s/\&#x39B\;/\Λ/g
        s/\&#x39C\;/\Μ/g
        s/\&#x39D\;/\Ν/g
        s/\&#x39E\;/\Ξ/g
        s/\&#x39F\;/\Ο/g
        s/\&#x3A0\;/\Π/g
        s/\&#x3A1\;/\Ρ/g
        s/\&#x3A3\;/\Σ/g
        s/\&#x3A4\;/\Τ/g
        s/\&#x3A5\;/\Υ/g
        s/\&#x3A6\;/\Φ/g
        s/\&#x3A7\;/\Χ/g
        s/\&#x3A8\;/\Ψ/g
        s/\&#x3A9\;/\Ω/g
        s/\&#x3B1\;/\α/g
        s/\&#x3B2\;/\β/g
        s/\&#x3B3\;/\γ/g
        s/\&#x3B4\;/\δ/g
        s/\&#x3B5\;/\ε/g
        s/\&#x3B6\;/\ζ/g
        s/\&#x3B7\;/\η/g
        s/\&#x3B8\;/\θ/g
        s/\&#x3B9\;/\ι/g
        s/\&#x3BA\;/\κ/g
        s/\&#x3BB\;/\λ/g
        s/\&#x3BC\;/\μ/g
        s/\&#x3BD\;/\ν/g
        s/\&#x3BE\;/\ξ/g
        s/\&#x3BF\;/\ο/g
        s/\&#x3C0\;/\π/g
        s/\&#x3C1\;/\ρ/g
        s/\&#x3C2\;/\ς/g
        s/\&#x3C3\;/\σ/g
        s/\&#x3C4\;/\τ/g
        s/\&#x3C5\;/\υ/g
        s/\&#x3C6\;/\φ/g
        s/\&#x3C7\;/\χ/g
        s/\&#x3C8\;/\ψ/g
        s/\&#x3C9\;/\ω/g
        s/\&#x3D1\;/\ϑ/g
        s/\&#x3D2\;/\ϒ/g
        s/\&#x3D6\;/\ϖ/g
        s/\&#x2022\;/\•/g
        s/\&#x2026\;/\…/g
        s/\&#x2032\;/\′/g
        s/\&#x2033\;/\″/g
        s/\&#x203E\;/\‾/g
        s/\&#x2044\;/\⁄/g
        s/\&#x2118\;/\℘/g
        s/\&#x2111\;/\ℑ/g
        s/\&#x211C\;/\ℜ/g
        s/\&#x2122\;/\™/g
        s/\&#x2135\;/\ℵ/g
        s/\&#x2190\;/\←/g
        s/\&#x2191\;/\↑/g
        s/\&#x2192\;/\→/g
        s/\&#x2193\;/\↓/g
        s/\&#x2194\;/\↔/g
        s/\&#x21B5\;/\↵/g
        s/\&#x21D0\;/\⇐/g
        s/\&#x21D1\;/\⇑/g
        s/\&#x21D2\;/\⇒/g
        s/\&#x21D3\;/\⇓/g
        s/\&#x21D4\;/\⇔/g
        s/\&#x2200\;/\∀/g
        s/\&#x2202\;/\∂/g
        s/\&#x2203\;/\∃/g
        s/\&#x2205\;/\∅/g
        s/\&#x2207\;/\∇/g
        s/\&#x2208\;/\∈/g
        s/\&#x2209\;/\∉/g
        s/\&#x220B\;/\∋/g
        s/\&#x220F\;/\∏/g
        s/\&#x2211\;/\∑/g
        s/\&#x2212\;/\−/g
        s/\&#x2217\;/\∗/g
        s/\&#x221A\;/\√/g
        s/\&#x221D\;/\∝/g
        s/\&#x221E\;/\∞/g
        s/\&#x2220\;/\∠/g
        s/\&#x2227\;/\∧/g
        s/\&#x2228\;/\∨/g
        s/\&#x2229\;/\∩/g
        s/\&#x222A\;/\∪/g
        s/\&#x222B\;/\∫/g
        s/\&#x2234\;/\∴/g
        s/\&#x223C\;/\∼/g
        s/\&#x2245\;/\≅/g
        s/\&#x2248\;/\≈/g
        s/\&#x2260\;/\≠/g
        s/\&#x2261\;/\≡/g
        s/\&#x2264\;/\≤/g
        s/\&#x2265\;/\≥/g
        s/\&#x2282\;/\⊂/g
        s/\&#x2283\;/\⊃/g
        s/\&#x2284\;/\⊄/g
        s/\&#x2286\;/\⊆/g
        s/\&#x2287\;/\⊇/g
        s/\&#x2295\;/\⊕/g
        s/\&#x2297\;/\⊗/g
        s/\&#x22A5\;/\⊥/g
        s/\&#x22C5\;/\⋅/g
        s/\&#x2308\;/\⌈/g
        s/\&#x2309\;/\⌉/g
        s/\&#x230A\;/\⌊/g
        s/\&#x230B\;/\⌋/g
        s/\&#x2329\;/\⟨/g
        s/\&#x232A\;/\⟩/g
        s/\&#x25CA\;/\◊/g
        s/\&#x2660\;/\♠/g
        s/\&#x2663\;/\♣/g
        s/\&#x2665\;/\♥/g
        s/\&#x2666\;/\♦/g
        s/\&#x26\;/&/g
        s/\&#x3C\;/\</g
        s/\&#x3E\;/\>/g
        s/\&#x152\;/\Œ/g
        s/\&#x153\;/\œ/g
        s/\&#x160\;/\Š/g
        s/\&#x161\;/\š/g
        s/\&#x178\;/\Ÿ/g
        s/\&#x2C6\;/\ˆ/g
        s/\&#x2DC\;/\˜/g
        s/\&#x2002\;/\ /g
        s/\&#x2003\;/\ /g
        s/\&#x2009\;/\ /g
        s/\&#x200C\;/\‌/g
        s/\&#x200D\;/\‍/g
        s/\&#x200E\;/\‎/g
        s/\&#x200F\;/\‏/g
        s/\&#x2013\;/\–/g
        s/\&#x2014\;/\—/g
        s/\&#x2018\;/\‘/g
        s/\&#x2019\;/\’/g
        s/\&#x201A\;/\‚/g
        s/\&#x201C\;/\“/g
        s/\&#x201E\;/\„/g
        s/\&#x2020\;/\†/g
        s/\&#x2021\;/\‡/g
        s/\&#x2030\;/\‰/g
        s/\&#x2039\;/\‹/g
        s/\&#x203A\;/\›/g
        s/\&#x20AC\;/\€/g
        s/\&#160\;/\ /g
        s/\&#173\;/\­/g
        s/\&#402\;/\ƒ/g
        s/\&#913\;/\Α/g
        s/\&#914\;/\Β/g
        s/\&#915\;/\Γ/g
        s/\&#916\;/\Δ/g
        s/\&#917\;/\Ε/g
        s/\&#918\;/\Ζ/g
        s/\&#919\;/\Η/g
        s/\&#920\;/\Θ/g
        s/\&#921\;/\Ι/g
        s/\&#922\;/\Κ/g
        s/\&#923\;/\Λ/g
        s/\&#924\;/\Μ/g
        s/\&#925\;/\Ν/g
        s/\&#926\;/\Ξ/g
        s/\&#927\;/\Ο/g
        s/\&#928\;/\Π/g
        s/\&#929\;/\Ρ/g
        s/\&#931\;/\Σ/g
        s/\&#932\;/\Τ/g
        s/\&#933\;/\Υ/g
        s/\&#934\;/\Φ/g
        s/\&#935\;/\Χ/g
        s/\&#936\;/\Ψ/g
        s/\&#937\;/\Ω/g
        s/\&#945\;/\α/g
        s/\&#946\;/\β/g
        s/\&#947\;/\γ/g
        s/\&#948\;/\δ/g
        s/\&#949\;/\ε/g
        s/\&#950\;/\ζ/g
        s/\&#951\;/\η/g
        s/\&#952\;/\θ/g
        s/\&#953\;/\ι/g
        s/\&#954\;/\κ/g
        s/\&#955\;/\λ/g
        s/\&#956\;/\μ/g
        s/\&#957\;/\ν/g
        s/\&#958\;/\ξ/g
        s/\&#959\;/\ο/g
        s/\&#960\;/\π/g
        s/\&#961\;/\ρ/g
        s/\&#962\;/\ς/g
        s/\&#963\;/\σ/g
        s/\&#964\;/\τ/g
        s/\&#965\;/\υ/g
        s/\&#966\;/\φ/g
        s/\&#967\;/\χ/g
        s/\&#968\;/\ψ/g
        s/\&#969\;/\ω/g
        s/\&#977\;/\ϑ/g
        s/\&#978\;/\ϒ/g
        s/\&#982\;/\ϖ/g
        s/\&#8226\;/\•/g
        s/\&#8230\;/\…/g
        s/\&#8242\;/\′/g
        s/\&#8243\;/\″/g
        s/\&#8254\;/\‾/g
        s/\&#8260\;/\⁄/g
        s/\&#8472\;/\℘/g
        s/\&#8465\;/\ℑ/g
        s/\&#8476\;/\ℜ/g
        s/\&#8482\;/\™/g
        s/\&#8501\;/\ℵ/g
        s/\&#8592\;/\←/g
        s/\&#8593\;/\↑/g
        s/\&#8594\;/\→/g
        s/\&#8595\;/\↓/g
        s/\&#8596\;/\↔/g
        s/\&#8629\;/\↵/g
        s/\&#8656\;/\⇐/g
        s/\&#8657\;/\⇑/g
        s/\&#8658\;/\⇒/g
        s/\&#8659\;/\⇓/g
        s/\&#8660\;/\⇔/g
        s/\&#8704\;/\∀/g
        s/\&#8706\;/\∂/g
        s/\&#8707\;/\∃/g
        s/\&#8709\;/\∅/g
        s/\&#8711\;/\∇/g
        s/\&#8712\;/\∈/g
        s/\&#8713\;/\∉/g
        s/\&#8715\;/\∋/g
        s/\&#8719\;/\∏/g
        s/\&#8721\;/\∑/g
        s/\&#8722\;/\−/g
        s/\&#8727\;/\∗/g
        s/\&#8730\;/\√/g
        s/\&#8733\;/\∝/g
        s/\&#8734\;/\∞/g
        s/\&#8736\;/\∠/g
        s/\&#8743\;/\∧/g
        s/\&#8744\;/\∨/g
        s/\&#8745\;/\∩/g
        s/\&#8746\;/\∪/g
        s/\&#8747\;/\∫/g
        s/\&#8756\;/\∴/g
        s/\&#8764\;/\∼/g
        s/\&#8773\;/\≅/g
        s/\&#8776\;/\≈/g
        s/\&#8800\;/\≠/g
        s/\&#8801\;/\≡/g
        s/\&#8804\;/\≤/g
        s/\&#8805\;/\≥/g
        s/\&#8834\;/\⊂/g
        s/\&#8835\;/\⊃/g
        s/\&#8836\;/\⊄/g
        s/\&#8838\;/\⊆/g
        s/\&#8839\;/\⊇/g
        s/\&#8853\;/\⊕/g
        s/\&#8855\;/\⊗/g
        s/\&#8869\;/\⊥/g
        s/\&#8901\;/\⋅/g
        s/\&#8968\;/\⌈/g
        s/\&#8969\;/\⌉/g
        s/\&#8970\;/\⌊/g
        s/\&#8971\;/\⌋/g
        s/\&#9001\;/\〈/g
        s/\&#9002\;/\〉/g
        s/\&#9674\;/\◊/g
        s/\&#9824\;/\♠/g
        s/\&#9827\;/\♣/g
        s/\&#9829\;/\♥/g
        s/\&#9830\;/\♦/g
        s/\&#338\;/\Œ/g
        s/\&#339\;/\œ/g
        s/\&#352\;/\Š/g
        s/\&#353\;/\š/g
        s/\&#376\;/\Ÿ/g
        s/\&#710\;/\ˆ/g
        s/\&#732\;/\˜/g
        s/\&#8194\;/\ /g
        s/\&#8195\;/\ /g
        s/\&#8201\;/\ /g
        s/\&#8204\;/\‌/g
        s/\&#8205\;/\‍/g
        s/\&#8206\;/\‎/g
        s/\&#8207\;/\‏/g
        s/\&#8211\;/\–/g
        s/\&#8212\;/\—/g
        s/\&#8216\;/\‘/g
        s/\&#8217\;/\’/g
        s/\&#146\;/\’/g
        s/\&#8218\;/\‚/g
        s/\&#8220\;/\“/g
        s/\&#8222\;/\„/g
        s/\&#8224\;/\†/g
        s/\&#8225\;/\‡/g
        s/\&#8240\;/\‰/g
        s/\&#8249\;/\‹/g
        s/\&#8250\;/\›/g
        s/\&#8364\;/\€/g}')
    }

function tempo () {
    # ht hora da teresa
    ht=`date +%H:%M`
    # h hora real
    h=`date --date='+1 hour' +%H:%M`
    # hl hora limite
    hl=`date --date='+2 hour' +%H:%M`
    # data real
    d=`date +%Y-%m-%d`
    # data amanha
    da=`date -d 'tomorrow' +%Y-%m-%d`
    # data ontem
    do=`date -d 'yesterday' +%Y-%m-%d`
    }

function mensagem () {
    dm=$(echo $d | sed -e 's/-//g')
    hm=$(echo $h | sed -e 's/://g')
    if [[ $1 != "" ]]; then
        echo "Source: COBOL" > "$dirDestMsg/$1.$dm.$hm".msg
        echo "Data-int: $d $da" >> "$dirDestMsg/$1.$dm.$hm".msg
        echo "Hora-int: $ht $hl" >> "$dirDestMsg/$1.$dm.$hm".msg
        echo "To: $1" >> "$dirDestMsg/$1.$dm.$hm".msg
        echo "Mensagem:" >> "$dirDestMsg/$1.$dm.$hm".msg
        echo "Se esta a ler este" >> "$dirDestMsg/$1.$dm.$hm".msg
        echo "SMS significa que" >> "$dirDestMsg/$1.$dm.$hm".msg
        echo "o envio de SMS tem:" >> "$dirDestMsg/$1.$dm.$hm".msg
        echo "Status=OK" >> "$dirDestMsg/$1.$dm.$hm".msg
        echo "Data=$d" >> "$dirDestMsg/$1.$dm.$hm".msg
        echo "Hora=$h" >> "$dirDestMsg/$1.$dm.$hm".msg
    fi
    }

function wortenMirror () {
    echo "INI--------------------------------------" >> "$dirProcesWorten"/precos.log
    mirror=""
    #onOff3G on
    #if [[ "$ESTADO" == "gsm:ligado" ]]; then
        echo "Mirror INI "$(date +%Y-%m-%d_%H:%M) >> "$dirProcesWorten"/precos.log
        echo $ESTADO $(date +%Y-%m-%d_%H:%M) >> "$dirProcesWorten"/precos.log
        #httrack -q -%i -iC2 http://www.worten.pt/store/inicio/eletrodomesticos.html -O "$dirProcesWorten/" -n -%P -p7 -N0 -s2 -%U francisco -r9999 --ext-depth=1 -x -p7 -D -a -K4 -c4 -%k -A25000 -F "$useragent" -%F "<!-- Mirrored from %s%s by HTTrack Website Copier/3.x [XR&CO'2008], %s -->"  -*.png -*.gif -*.jpg -*.jpeg +*.css +*.js -*media.worten.pt -googleads.g.doubleclick.net -*AddBasket.aspx* -*.png.image* -*.bmp.image* -*.tif.image* -*.gif.image* -*.jpg.image* -*facebook* -*product_compare* -*checkout* -%s -%u
        httrack -q -%i -iC2 http://www.worten.pt/store/inicio/eletrodomesticos.html -O "$dirProcesWorten/" -n -%P -p7 -N0 -s2 -%U francisco -r9999 -x -p7 -D -a -K4 -c4 -%k -A25000 -F "$useragent" -%F "<!-- Mirrored from %s%s by HTTrack Website Copier/3.x [XR&CO'2008], %s -->"  -*.png -*.gif -*.jpg -*.jpeg +*.css +*.js -*media.worten.pt -googleads.g.doubleclick.net -*AddBasket.aspx* -*.png.image* -*.bmp.image* -*.tif.image* -*.gif.image* -*.jpg.image* -*facebook* -*product_compare* -*checkout* -%s -%u
        #onOff3G off
        #echo $ESTADO $(date +%Y-%m-%d_%H:%M) >> "$dirProcesWorten"/precos.log
        rm -f $dirDestWorten/*.tmp
        mirror=ok
        chown -R francisco:francisco "$dirProcesWorten"
        echo "Mirror END "$(date +%Y-%m-%d_%H:%M) >> "$dirProcesWorten"/precos.log
    #else
        #echo "Atenção o estado do Modem é $ESTADO"
        #echo O Mirror não foi realizado!
        #echo $(nmcli -t -f TYPE,STATE dev | grep "^gsm:") $(date +%Y-%m-%d_%H:%M) O Mirror não foi realizado! >> "$dirProcesWorten"/precos.log
    #fi
    }

function waitKey () {
    read -t 10 -p "[Ctrl][C] Aborta, [ENTER] Continua, (10 seg Continua...)"
    echo -e "\nContinuando ..."
    }

function erroAguardaTempo1 () {
    echo "Para executar tem de indicar um valor inicial e final (1 dia = 86400 segundos)"
    }

function countdown () {
    local OLD_IFS="${IFS}"
    IFS=":"
    local ARR=( $1 )
    local SECONDS=$((  (ARR[0] * 60 * 60) + (ARR[1] * 60) + ARR[2]  ))
    local START=$(date +%s)
    local END=$((START + SECONDS))
    local CUR=$START
    while [[ $CUR -lt $END ]]
    do
        CUR=$(date +%s)
        LEFT=$((END-CUR))
        printf "\r%02d:%02d:%02d" \
                $((LEFT/3600)) $(( (LEFT/60)%60)) $((LEFT%60))
        sleep 1
    done
    IFS="${OLD_IFS}"
    echo "        "
    }

function aguardarTempo () {
    ati=$1
    ate=$2
    if [[ "$ati" == "" ]]; then
        erroAguardaTempo1
        exit 0
    fi
    if [[ "$ate" == "" ]]; then
        erroAguardaTempo1
        exit 0
    fi
        if [[ "$ate" > 86400 ]]; then
        erroAguardaTempo1
        exit 0
    fi
    s=`shuf -i $ati-$ate -n 1`
    h=$((($s / 3600) | bc -l ))
    s=$(($s-($h * 3600) | bc -l ))
    m=$((($s / 60) | bc -l ))
    s=$(($s-($m * 60) | bc -l ))
    echo "Processamento suspenso durante: $(printf "\n%02d:%02d:%02d"  $h  $m  $s)"
    echo "Processamento suspenso durante: $(printf "\n%02d:%02d:%02d"  $h  $m  $s)" >> "$dirProcesWorten"/precos.log
    echo "Tempo em falta para retomar:"
    countdown $(printf "%02d:%02d:%02d"  $h  $m  $s)
    }

function emailSend () {
    echo "Envio de Email INI "$(date +%Y-%m-%d_%H:%M) >> "$dirProcesWorten"/precos.log
    #nOff3G on
    #if [[ "$ESTADO" == "gsm:ligado" ]]; then
        echo $ESTADO $(date +%Y-%m-%d_%H:%M) >> "$dirProcesWorten"/precos.log
        zip -P q1w2e3r4t5y6 -r $dirProcesWorten/precos_$df.zip $dirProcesWorten/$csv
        #mutt -s "precos_$df" -a $dirProcesWorten/precos_$df.zip -F /home/francisco/.mutt/mutt_r -- fatimaferreira@radiopopular.pt < $dirProcesWorten/texto.msg
        mutt -s "precos_$df" -a $dirProcesWorten/precos_$df.zip -F /home/francisco/.mutt/mutt_r -- franciscorocha@radiopopular.pt < $dirProcesWorten/texto.msg
        onOff3G off
        echo $ESTADO $(date +%Y-%m-%d_%H:%M) >> "$dirProcesWorten"/precos.log
    #else
    #    echo "Atenção o estado do Modem é $ESTADO"
    #    echo "Envio de Email não foi realizado!"
    #    echo $(nmcli -t -f TYPE,STATE dev | grep "^gsm:") $(date +%Y-%m-%d_%H:%M) Envio de Email não foi realizado! >> "$dirProcesWorten"/precos.log
    #fi
    echo "Envio de Email END "$(date +%Y-%m-%d_%H:%M) >> "$dirProcesWorten"/precos.log
    chown francisco:francisco "$dirProcesWorten"/precos.log
    }

function wortenProductDetail () {
    if [[ "$mirror" == "ok" ]]; then
        cd $dirDestWorten
        ARRAY=(`find /home/francisco/websites/worten | grep html | grep "www.worten.pt"`)
        #COUNT=${#ARRAY[@]}
        volta=1
        csv=""
        df=""
        file=""
        umalinha=""
        sku=""
        name=""
        brand=""
        url=""
        category=""
        price=""
        availa=""
        df=$(date -r ${ARRAY[1]} +%F)
        csv="precos_$df.csv"
        echo "Processamento INI "$(date +%Y-%m-%d_%H:%M) >> "$dirProcesWorten"/precos.log
        if [[ -f "$dirProcesWorten/$csv" ]]; then
            echo "O ficheiro $dirProcesWorten/$csv ja existe o processamento não precisa ser executado" >> "$dirProcesWorten"/precos.log
            echo "O ficheiro $dirProcesWorten/$csv ja existe o processamento não precisa ser executado"
        else
            echo "Numero de ficheiros processar:$COUNT"
            echo " A criar o ficheiro: $dirProcesWorten/$csv"
            for i in ${ARRAY[*]}; do
                file="$i"
                echo $file
                umalinha=$(cat $file | tr -d "\015" | tr -d '\n')
                dataLayer=$(cat $file | sed -n '/dataLayer =/,/\/script/{p}' | sed -e 's/<[^>]*>//g' | sed -e "s/,\'/#/g" | sed -e 's/#/\\n/g' | sed -e 's/'\'','\''/\\n/g;s/'\'', '\''/\\n/g;s/{/\\n/g;s/}/\\n/g;s/'\''//g;s/: /:/g')
                sku=$(echo -e $dataLayer | grep sku | awk -F':' '{ print $2 }')
                if [[ $sku != "" ]] ; then
                    id=$(echo -e $dataLayer | grep id | awk -F':' '{ print $2 }')
                    brand=$(echo -e $dataLayer | grep brand | awk -F':' '{ print $2 }')
                    ean=$(echo -e $dataLayer | grep ean | sed -e 's/,//g' | awk -F':' '{ print $2 }')
                    price=$(echo -e $dataLayer | grep price | awk -F':' '{ print $2 }')
                    category=$(echo -e $dataLayer | grep category | awk -F':' '{ print $2 }'| sed -e 's/\;//g')
                    #limparCodeHTML $category
                    #category="$limparCodeHTML"
                    name=$(echo -e $dataLayer | grep name | awk -F':' '{ print $2 }' | sed -e 's/\\\///g;s/\;//g')
                    #limparCodeHTML "$name"
                    #name=$(echo "$limparCodeHTML")
                    availa=$(echo $umalinha | sed -e 's/in-stock\">/\nin-stock:/g' | sed s'/<\/div>/\n/;s/<[^>]*>//g' | grep in-stock | awk -F':' '{ print $2 }' )
                    url=$(cat $file | grep "og:url" | grep -o -E 'http:([^"#]+)')
                    if [[ "$volta" == "2" ]]; then
                        if [[ $price != "" ]]; then
                        echo "$id;$ean;$sku;$category;$name;$brand;$price;$availa;$url" >> "$dirProcesWorten/$csv"
                        fi
                    fi
                    if [[ "$volta" == "1" ]]; then
                        if [[ $price != "" ]]; then
                            echo "$id;$ean;$sku;$category;$name;$brand;$price;$availa;$url"
                            waitKey
                            echo "$id;$ean;$sku;$category;$name;$brand;$price;$availa;$url" >> "$dirProcesWorten/$csv"
                            volta=2
                        fi
                    fi
                else
                    sku=""
                    brand=""
                    availa=""
                    url=""
                    ean=""
                    idA=( `cat $file | grep -o product-price-\.* | grep -o '[0-9]*[0-9]' ` )
                    nameA=( `cat $file | grep 'h2\|h1' | sed -e 's/<[^>]*>//g' | sed -e 's/  //g;/^$/d' ` )
                    priceA=( `cat $file | grep -o "<span class='main_price'>*.*" | sed -e 's/<[^>]*>//g;s/,/./g;s/ //g' ` )
                    category=$(cat $file | grep -o categorypath*.* | grep -o "category-.*[a-Z]" | sed -e 's/category-//g')
                    #pagina=$(cat $file | grep -o categorypath*.*\ | sed -e 's/-html//;s/categorypath-/http:\/\/www.worten.pt\/store\//;s/-/\//g;s/'$category'//g')
                    #pagina=$(cat $file | grep -o categorypath*.*\ | sed -e 's/-html//;s/categorypath-/http:\/\/www.worten.pt\/store\//;s/-/\//g')
                    #echo $pagina | sed -e 's/\//\\\//g;s/:/\\:/;s/\./\\./g'
                    #url=$( cat $file | grep 'h2\|h1' | grep -o "a href.*html" | sed -e 's/a href=\"/'$category'/g' )
                    #echo $url
                    n=${#idA[@]}
                    a=0
                    while test $a -lt $n
                    do
                            if [[ "$volta" == "2" ]]; then
                                    if [[ ${priceA[$a]} != "" ]]; then
                                    echo "${idA[$a]};$ean;$sku;$category;${nameA[$a]};$brand;${priceA[$a]};$availa;$url" >> "$dirProcesWorten/$csv"
                                    let a=$a+1
                                    fi
                            fi
                            if [[ "$volta" == "1" ]]; then
                                    if [[ ${priceA[$a]} != "" ]]; then
                                    echo "${idA[$a]};$ean;$sku;$category;${nameA[$a]};$brand;${priceA[$a]};$availa;$url"
                                    waitKey
                                    echo "${idA[$a]};$ean;$sku;$category;${nameA[$a]};$brand;${priceA[$a]};$availa;$url" >> "$dirProcesWorten/$csv"
                                    let a=$a+1
                                    volta=2
                                    fi
                            fi
                    done
                fi
                #printf "$COUNT     $file     \r"
                #COUNT=$((COUNT-1))
            done
            cat "$dirProcesWorten/$csv" | sort --numeric-sort --field-separator=';' -k1 | awk -F';' '!(x[$(1)]++)' > "$dirProcesWorten/$csv.tmp"
            cat "$dirProcesWorten/$csv.tmp" | sed -n '/^[0-9]/p' | awk 'BEGIN {FS=";"} $7!="" {print}' > "$dirProcesWorten/$csv"
            rm "$dirProcesWorten/$csv.tmp"
            sed -i '1iID;EAN;Cod.;Familia;Nome;Marca;PVP;Stock;Link' "$dirProcesWorten/$csv"
            echo -e "\nFim de processamento"
            echo "Foi criado na pasta $dirProcesWorten o ficheiro $csv" >> "$dirProcesWorten"/precos.log
            echo "Processamento END "$(date +%Y-%m-%d_%H:%M) >> "$dirProcesWorten"/precos.log
            chown francisco:francisco "$dirProcesWorten"/precos.log
            chown francisco:francisco "$dirProcesWorten/$csv"
            emailSend
        fi
    else
        echo "O mirror não foi realizado pelo que não vai ser executado o processamento" >> "$dirProcesWorten"/precos.log
        echo "O mirror não foi realizado pelo que não vai ser executado o processamento"
    fi
    mirror=""
    echo "END--------------------------------------">> "$dirProcesWorten"/precos.log
    waitKey
}

function useragent () {
    ultimo=12
    agent=$(echo $((`cat /dev/urandom|od -N1 -An -i` % $ultimo)))
    # agent=1

    if [[ $agent == 0 ]];then
    # opera 9
    useragent="Opera/9.99 (Windows NT 5.1; U; pl) Presto/9.9.9"
    fi

    if [[ $agent == 1 ]];then
    # midori 0.4
    useragent="Mozilla/5.0 (X11; Linux; rv:2.0.1) Gecko/20100101 Firefox/4.0.1 Midori/0.4"
    fi

    if [[ $agent == 2 ]];then
    #firefox 15
    useragent="Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120716 Firefox/15.0a2"
    fi

    if [[ $agent == 3 ]];then
    #firefox 14
    useragent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:14.0) Gecko/20120405 Firefox/14.0a1"
    fi

    if [[ $agent == 4 ]];then
    #firefox 12
    useragent="Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120403211507 Firefox/12.0"
    fi

    if [[ $agent == 5 ]];then
    #fiferox 11
    useragent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20120421 Gecko Firefox/11.0"
    fi

    if [[ $agent == 6 ]];then
    #firefox 10
    useragent="Mozilla/6.0 (Macintosh; I; Intel Mac OS X 11_7_9; de-LI; rv:1.9b4) Gecko/2012010317 Firefox/10.0a4"
    fi

    if [[ $agent == 7 ]];then
    #firefox 9
    useragent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0a2) Gecko/20111101 Firefox/9.0a2"
    fi

    if [[ $agent == 8 ]];then
    #firefox 8
    useragent="Mozilla/5.0 (Windows NT 5.1; rv:8.0; en_us) Gecko/20100101 Firefox/8.0"
    fi

    if [[ $agent == 9 ]];then
    # opera 11
    useragent="Opera/9.80 (Windows NT 6.1; WOW64; U; pt) Presto/2.10.229 Version/11.62"
    fi

    if [[ $agent == 10 ]];then
    #ie 9
    useragent="Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 7.1; Trident/5.0)"
    fi

    if [[ $agent == 11 ]];then
    # opera 10
    useragent="Opera/9.80 (Windows NT 6.1; U; pl) Presto/2.6.31 Version/10.70"
    fi

    if [[ $agent == 12 ]];then
    # opera 12
    useragent="Opera/9.80 (Windows NT 6.1; U; es-ES) Presto/2.9.181 Version/12.00"
    fi

    if [[ $agent == 13 ]];then
    #ie 10
    useragent="Mozilla/5.0 (compatible; MSIE 10.6; Windows NT 6.1; Trident/5.0; InfoPath.2; SLCC1; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 2.0.50727) 3gpp-gba UNTRUSTED/1.0"
    fi

    if [[ $agent == 14 ]];then
    #ie 8
    useragent="Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET CLR 1.0.3705; .NET CLR 1.1.4322)"
    fi

    echo "Useragent:"
    echo "$useragent"
    }

function exeSempre () {
    . /home/francisco/Dropbox/Linux/OsMeusScripts/precos.cfg
    while [ $precos = 1 ]
    do
        tempo
        useragent
        wortenMirror
        waitKey
        wortenProductDetail
        aguardarTempo 55321 86400
        . /home/francisco/Dropbox/Linux/OsMeusScripts/precos.cfg
    done
    waitKey
}

function menu () {

let "loop1=0"

while test $loop1 == 0
    do
    opcao=$( dialog --stdout --title "Menu de Procressamento" --backtitle "Aplicação para processar site" --clear --menu 'Escolha uma opção:' 0 0 0 \
    M  '[M]irror do site'             \
    G  '[G]erar relatorio do site'    \
    A  'Processamento [A]mbos'        \
    P  '[P]rocessamento ambos Sempre' \
    S  '[S]air' )

    case $opcao in m|M)
    tempo
    useragent
    wortenMirror
    esac
    case $opcao in g|G)
    mirror=ok
    wortenProductDetail
    esac
    case $opcao in p|P)
    exeSempre
    esac
    case $opcao in a|A)
    tempo
    useragent
    wortenMirror
    waitKey
    wortenProductDetail
    esac
    case $opcao in s|S)
    let "loop1=1"
    clear
    esac
    case $opcao in 255)
    let "loop1=1"
    clear
    esac
done
	}

menu
# mensagem $numeroDest01
