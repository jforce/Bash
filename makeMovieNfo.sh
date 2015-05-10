#!/usr/bin/env bash
#! autor: j.francisco.o.rocha@gmail.com
#! FilmesScan.sh
#! 04/2010


# Validação Fase 1 INI
if [[ $1 == "" ]]; then
	echo "Tem de indicar um filme!"; exit 192
fi
# Validação Fase 1 END

#Global variable declarations INI
shopt -s -o nounset
declare -rx SCRIPT=${0##*/}
declare URL
declare URLIMDB
declare URLIMDBC
declare URLIMDBCREDIT
declare URLPTGATE
declare URLDVDPT
declare TITULO
declare ANO
declare RAT
declare VOTES
declare PLOT
declare PLOTPTGATE
declare PLOTDVDPT
declare PLOTIMDB
declare PLOTIMDBC
declare FILME="$*"
declare DIR
declare GEN
declare CAST
declare ImdbCode
declare ImdbCodeTest
declare ImdbCodePtgate
declare ImdbCodeDvdpt
declare -rx TMPFILEIMDB=/tmp/imdbmoviefetcherimdb.$$
declare -rx TMPFILEIMDBC=/tmp/imdbmoviefetcherenc.$$
declare -rx TMPFILEIMDBCREDIT=/tmp/imdbmoviefetcherencredit.$$
declare -rx TMPFILEPTGATE=/tmp/imdbmoviefetcherptgate.$$
declare -rx TMPFILEDVDPT=/tmp/imdbmoviefetcherdvdpt.$$
declare -rx PLOTFILEIMDB=/tmp/plotimdb.$$.html
declare -rx PLOTFILEIMDBC=/tmp/plotimdbc.$$.html
declare -rx PLOTFILEPTGATE=/tmp/plotptgate.$$.html
declare -rx PLOTFILEDVDPT=/tmp/plotdvdpt.$$.html
declare -rx LYNX="/usr/bin/lynx"
declare -rx CAT="/bin/cat"
declare -rx SED="/bin/sed"
declare -rx EGREP="/bin/egrep"
declare -rx GREP="/bin/grep"
declare -rx UNIQ="/usr/bin/uniq"
declare -rx HEAD="/usr/bin/head"
declare -rx ICONV="/usr/bin/iconv"
declare -rx AWK="/usr/bin/awk"
#Global variable declarations END

# Functions INI
function printTitulo () {
printf "Titulo        : $TITULO\n"
}
function printAno () {
printf "Ano           : $ANO\n"
}
function printClassifica () {
printf "Classificação : $RAT\n"
}
function printVotos () {
printf "Votos         : $VOTES\n"
}
function printDirectores () {
printf "Directores    : $DIR\n"
}
function printGeneros () {
printf "Generos       : $GEN\n"
}
function printActores () {
printf "Actores       :\n%s\n" "$CAST"
}
function printSinopse () {
printf "Sinopse       :\n%s\n" "$PLOT"
}
function printURLS() {
printf "IMDB movie URL   : ${URLIMDB}\n"
#printf "IMDB C movie URL : ${URLIMDBC}\n"
printf "PtGate movie URL : ${URLPTGATE}\n"
printf "DVDPT movie URL  : ${URLDVDPT}\n"
}
function printnofound() {
printf "There is no $1 command. Please install it\n"
}
function limparCodeHTML () {
	limparCodeHTML=$(echo -e "$1" | sed -e '{
						s/\/\"/g
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
						s/\&#38\;/\&/g
						s/\&amp\;/\&/g
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
						s/\&nbsp\;/\ /g
						s/\&shy\;/\­/g
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
						s/\&#x26\;/\&/g
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
function limparCodeInvalid () {
	limparCodeInvalid=$(echo -e "$1" | sed -r 's/  */\+/g;s/\&/%26/g;s/\++$//g')
	}
function limparCodeHTMLfile () {
	$CAT $1 | $SED -e '{
						s/\/\`/g
						s/\/\"/g
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
						s/\&#38\;/\&/g
						s/\&amp\;/\&/g
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
						s/\&nbsp\;/\ /g
						s/\&shy\;/\­/g
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
						s/\&#x26\;/\&/g
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
						s/\&#8218\;/\‚/g
						s/\&#8220\;/\“/g
						s/\&#8222\;/\„/g
						s/\&#8224\;/\†/g
						s/\&#8225\;/\‡/g
						s/\&#8240\;/\‰/g
						s/\&#8249\;/\‹/g
						s/\&#8250\;/\›/g
						s/\&#8364\;/\€/g}' > $1
	}

# Functions END

# Validação Fase 1 INI
if [ -z "$BASH" ]
then
printf "This script is written for bash. Please run this under bash\n" >&2
exit 192
fi
if [ ! -x "$LYNX" ]
then
printnofound $LYNX >&2
exit 192
fi
if [ ! -x "$CAT" ]
then
printnofound $CAT >&2
exit 192
fi
if [ ! -x "$EGREP" ]
then
printnofound $EGREP >&2
exit 192
fi
if [ ! -x "$GREP" ]
then
printnofound $GREP >&2
exit 192
fi
if [ ! -x "$UNIQ" ]
then
printnofound $UNIQ >&2
exit 192
fi
if [ ! -x "$HEAD" ]
then
printnofound $HEAD >&2
exit 192
fi
if [ ! -x "$SED" ]
then
printnofound $SED >&2
exit 192
fi
if [ ! -x "$ICONV" ]
then
printnofound $ICONV >&2
exit 192
fi
# Validação Fase 2 END

# Limpar codigos invalidos da variavel FILME
limparCodeInvalid "$FILME"
FILME="$limparCodeInvalid"
# Limpar codigos invalidos da variavel FILME

function recolhaIMDB () {
# Procurar o filme no Google IMDB 
$LYNX -connect_timeout=10 --source "http://www.google.com/search?hl=en&q=$FILME+imdb" > $TMPFILEIMDB 2> /dev/null
# Validar se a erro na ligação 
if [ $? -ne 0 ]; then
printf "A ligação ao servidor falhou IMDB... Verifique a sua ligação a internet!\n"; exit 192
fi

# Identificar o endereço IMDB para o filme
URLIMDB=`$EGREP -o "http://www.imdb.com/title/tt[0-9]*/" $TMPFILEIMDB | $HEAD -1`
# Identificar o endereço IMDBCombined para o filme
URLIMDBC="${URLIMDB}combined"

# Guardar os detalhes do filme IMDB
$LYNX --source ${URLIMDB} > $TMPFILEIMDB;
$LYNX --source ${URLIMDBC} > $TMPFILEIMDBC;

# Extrair informação (parse) CODIGO IMDB
ImdbCode=$(echo ${URLIMDB} | $AWK -F/ '{print $5}')
#echo ImdbCode:$ImdbCode
# Extrair informação (parse) CODIGO IMDB

# Extrair informação (parse) ANO IMDB
ANO=`$CAT $TMPFILEIMDB | $SED -n '/<h1.*>/,/<\/h1>/p' | $SED '1d;$d;/^$/d;s/<[^>]*>//g;s/(//g;s/)//g' | $EGREP -o "[0-9][0-9][0-9][0-9]"`
# Extrair informação (parse) ANO IMDB

# Extrair informação (parse) TITULO IMDB
TITULO=`$CAT $TMPFILEIMDB | $SED -n '/<h1.*>/,/<\/h1>/p' | $SED '1d;$d;/^$/d;s/<[^>]*>//g;s/(//g;s/)//g' | $HEAD -1`
limparCodeHTML "$TITULO"
TITULO="$limparCodeHTML"
# Extrair informação (parse) TITULO IMDB

# Extrair informação (parse) RAT IMDB
RAT=`$SED -n '/<span class="rating-rating">/{ s/<[^>]*>//g;p;}' $TMPFILEIMDB`;
# Extrair informação (parse) RAT IMDB

# Extrair informação (parse) DIR IMDB
DIR=`$SED -n '/ *Director[s]*:.*/,/ *Writer[s]*:.*/{ /<a *href="\/name\/nm[0-9][0-9]*\/"[^>]*>[^<]*<\/a>.*/p;}' $TMPFILEIMDB | $SED  's/<\/a>/<\/a>\n/g' | $SED -n 's/.*<a *href="\/name\/nm[0-9][0-9]*\/"[^>]*>\([^<]*\)<\/a>.*/\1/p;' | tr '\n' ';' | $SED 's/\;*$//g'`
# Extrair informação (parse) DIR IMDB

# Extrair informação (parse) GEN IMDB
GEN=`$SED -n '/genre/p' $TMPFILEIMDB | $EGREP -o '<a  *.*href="/genre/[a-zA-Z][a-z]*"[^>]*>[^<]*</a>' | $SED 's/<[^>]*>//g;s/&nbsp\;//g;s/ *Genres *[0-9][0-9]* *min-//g;s/|/,/g' | $SED 's/[gG]enres//g;s/^  *//g' | $UNIQ | $HEAD -1`
# Extrair informação (parse) GEN IMDB

# Extrair informação (parse) CAST IMDB
CAST=`$SED -n '/.*Cast overview, first billed only:.*/,/<div class=\"see-more\">/{ s/<[^>]*>//g;s/Cast overview, first billed only://g;p }' $TMPFILEIMDB | $SED -n '{/^ *$/d;s/, /\t /g;s/ and /\t /g;p}' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $SED '/        \.\.\./d;s/                //g;s/          /Papel:/g;s/        /Actor:/g'`
limparCodeHTML "$CAST"
CAST="$limparCodeHTML"
# Extrair informação (parse) CAST IMDB

# Extrair informação (parse) PLOT IMDB
$SED -n '/<h1.*>/,/<\/p>/p' $TMPFILEIMDB | $SED -n '/<p>/,/<\/p>/{ s/<[^>]*>//g;p;}' | $SED 's/See full summary.*//g' | $SED '/^$/d' > $PLOTFILEIMDB
PLOTIMDB=`lynx --dump $PLOTFILEIMDB | sed 's/^  *//g'`
if [[ $PLOTIMDB != "" ]]; then
PLOTIMDB=`echo $PLOTIMDB | $AWK '{print}END{print "Fonte: IMDB"}'`
fi
# Extrair informação (parse) PLOT IMDB
}

function recolhaIMDBC () {
# Procurar o filme no Google IMDB 
$LYNX -connect_timeout=10 --source "http://www.google.com/search?hl=en&q=$FILME+imdb" > $TMPFILEIMDB 2> /dev/null
# Validar se a erro na ligação 
if [ $? -ne 0 ]; then
printf "A ligação ao servidor falhou IMDB... Verifique a sua ligação a internet!\n"; exit 192
fi

# Identificar o endereço IMDB para o filme
URLIMDB=`$EGREP -o "http://www.imdb.com/title/tt[0-9]*/" $TMPFILEIMDB | $HEAD -1`
# Identificar o endereço IMDBCombined para o filme
URLIMDBC="${URLIMDB}combined"
URLIMDBCREDIT="${URLIMDB}fullcredits#writers"

# Guardar os detalhes do filme IMDB
$LYNX --source ${URLIMDB} > $TMPFILEIMDB;
$LYNX --source ${URLIMDBC} > $TMPFILEIMDBC;
$LYNX --source ${URLIMDBCREDIT} | $SED 's/<tr>/\n<tr>/g' | $SED 's/<\/div>/\n<\/div/g' | $SED 's/<a name="cast"/\n<a name="cast"/g' > $TMPFILEIMDBCREDIT;
limparCodeHTMLfile $TMPFILEIMDB
limparCodeHTMLfile $TMPFILEIMDBC
limparCodeHTMLfile $TMPFILEIMDBCREDIT

# Extrair informação (parse) CODIGO IMDB
ImdbCode=$(echo ${URLIMDB} | $AWK -F/ '{print $5}')
#echo ImdbCode:$ImdbCode
# Extrair informação (parse) CODIGO IMDB

# Extrair informação (parse) ANO IMDB
ANO=`$CAT $TMPFILEIMDBC | $GREP "<title>" | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $AWK -F'(' '{print $2}' | $EGREP -o "[0-9][0-9][0-9][0-9]"`
# Extrair informação (parse) ANO IMDB

# Extrair informação (parse) TITULO IMDB
TITULO=`$CAT $TMPFILEIMDBC | $GREP "<title>" | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $AWK -F'(' '{print $1}' | $SED 's/\(.*\)./\1/'`
#limparCodeHTML "$TITULO"
#TITULO="$limparCodeHTML"
# Extrair informação (parse) TITULO IMDB

# Extrair informação (parse) RAT IMDB
RAT=`$CAT $TMPFILEIMDBC | $SED -n '/<div class="starbar-meta">/,/<\/b>/{s/<[^>]*>//g;p;}' | $SED 's/ //g'| $SED '/^$/d' | $AWK -F'/' '{print $1}'`
# Extrair informação (parse) RAT IMDB

# Extrair informação (parse) VOTES IMDB
VOTES=`$CAT $TMPFILEIMDBC | $SED -n '/<a href="ratings" class="tn15more">/,/<\/div>/{s/<[^>]*>//g;p;}' | $SED 's/ //g' | $SED '/^$/d' | $SED 's/votes//g' | $SED 's/»//'`
# Extrair informação (parse) VOTES IMDB

# Extrair informação (parse) DIR IMDB
DIR=`$SED -n '/ *Director[s]*:.*/,/<\/div>/{ /<a *href="\/name\/nm[0-9][0-9]*\/"[^>]*>[^<]*<\/a>.*/p}' $TMPFILEIMDBC | $SED  's/<\/a>/<\/a>\n/g' | $SED -n 's/.*<a *href="\/name\/nm[0-9][0-9]*\/"[^>]*>\([^<]*\)<\/a>.*/\1/p;' | tr '\n' ';' | $SED 's/\;*$//g'`
# Extrair informação (parse) DIR IMDB

# Extrair informação (parse) GEN IMDB
GEN=`$SED -n '/Genre:/,/<\/div>/{s/Genre://;p}' $TMPFILEIMDBC | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $SED 's/ See more \»//' | $SED 's/ | /\;/g' | $SED '/^$/d'`
# Extrair informação (parse) GEN IMDB

# Extrair informação (parse) CAST IMDB
#CAST=`$SED -n '/.*Cast overview, first billed only:.*/,/<div class=\"see-more\">/{ s/<[^>]*>//g;s/Cast overview, first billed only://g;p }' $TMPFILEIMDB | $SED -n '{/^ *$/d;s/, /\t /g;s/ and /\t /g;p}' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $SED '/        \.\.\./d;s/                //g;s/          /Papel:/g;s/        /Actor:/g'`
CAST=`$CAT $TMPFILEIMDBCREDIT | $SED -e 's/<td class="nm">/\nActor:/g' | $SED -e 's/<td class="char">/Papel:/g' | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $GREP "Actor:"`
# Extrair informação (parse) CAST IMDB

# Extrair informação (parse) PLOT IMDB
$SED -n '/<h1.*>/,/<\/p>/p' $TMPFILEIMDB | $SED -n '/<p>/,/<\/p>/{ s/<[^>]*>//g;p;}' | $SED 's/See full summary.*//g' | $SED '/^$/d' > $PLOTFILEIMDB
PLOTIMDB=`lynx --dump $PLOTFILEIMDB | sed 's/^  *//g'`
if [[ $PLOTIMDB != "" ]]; then
PLOTIMDB=`echo $PLOTIMDB | $AWK '{print}END{print "Fonte: IMDB"}'`
fi
# Extrair informação (parse) PLOT IMDB
}

function recolhaPTGATE () {
###########################################
################# PT GATE #################
###########################################
# Procurar o filme no Google PTGATE
$LYNX -connect_timeout=10 --source "http://www.google.com/search?q=site:cinema.ptgate.pt+$ImdbCode" > $TMPFILEPTGATE 2> /dev/null
# Validar se a erro na ligação a PTGATE
if [ $? -ne 0 ]; then
printf "A ligação ao servidor PTGATE falhou... Verifique a sua ligação a internet!\n"; exit 192
fi

# Identificar o endereço PTGATE para o filme
URLPTGATE=`$EGREP -o "http://cinema.ptgate.pt/filmes/[0-9]*" $TMPFILEPTGATE | $HEAD -1`
# Identificar o endereço PTGATE para o filme

# Guardar os detalhes do filme PTGATE
$LYNX --source ${URLPTGATE} > $TMPFILEPTGATE;
limparCodeHTMLfile $TMPFILEPTGATE
# Guardar os detalhes do filme PTGATE

# Extrair informação (parse) CODIGO IMDB no PTGATE
ImdbCodePtgate=$($CAT $TMPFILEPTGATE | $EGREP -o "http://www.imdb.com/title/tt[0-9]*" | $AWK -F/ '{print $5}' | sed 's/ //g')
# echo ImdbCodePtgate:$ImdbCodePtgate
# Extrair informação (parse) CODIGO IMDB no PTGATE


# Extrair informação (parse) PLOT PTGATE
$SED -n '/<h1.*>/,/<\/p>/p' $TMPFILEPTGATE | $SED -n '/<p>/,/<\/p>/{ s/<[^>]*>//g;p;}' | $SED 's/Sinopse.*//g' > $PLOTFILEPTGATE
PLOTPTGATE=`$SED -n '/.*Sinopse.*/,/<\/div>/{ s/<[^>]*>//g;s/Sinopse//g;p }' $TMPFILEPTGATE | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $SED 's/^  *//g' | $SED '/^$/d'| $SED 's/\t//g' | $ICONV -f ISO8859-1 -t UTF8`
if [[ $PLOTPTGATE != "" ]]; then
PLOTPTGATE=`echo $PLOTPTGATE | $AWK '{print}END{print "Fonte: PT GATE"}'`
fi
# Extrair informação (parse) PLOT PTGATE
###########################################
################# PT GATE #################
###########################################
}

function recolhaDVDPT () {
# Procurar o filme no Google DVDPT
$LYNX -connect_timeout=10 --source "http://www.google.com/search?q=site:www.dvdpt.com+$TITULO" > $TMPFILEDVDPT 2> /dev/null
# Validar se a erro na ligação a DVDPT
if [ $? -ne 0 ]; then
printf "A ligação ao servidor DVDPT falhou... Verifique a sua ligação a internet!\n"; exit 192
fi
# Procurar o filme no Google DVDPT

# Identificar o endereço DVDPT para o filme
URLDVDPT=`$EGREP -o "http://www.dvdpt.com/./[0-9a-Z][0-9a-Z_]*.php" $TMPFILEDVDPT | $HEAD -1 | $SED -e 's/\"//g'`
# Identificar o endereço DVDPT para o filme

# Guardar os detalhes do filme DVDPT
$LYNX --source ${URLDVDPT} | $SED 's/<font color=red face=arial size=-1>/<font color=red face=arial size=-1>\n/g' > $TMPFILEDVDPT;
limparCodeHTMLfile $TMPFILEDVDPT
cp $TMPFILEDVDPT lixo2.htm
# Guardar os detalhes do filme DVDPT

# Extrair informação (parse) CODIGO IMDB no DVDPT
ImdbCodeTest=$($CAT $TMPFILEDVDPT | $GREP imdb.com | $AWK -F? '{print $1}')
if [[ $ImdbCodeTest == "<a href=\"http://www.imdb.com/Details" ]]; then
ImdbCodeDvdpt=$($CAT $TMPFILEDVDPT | $GREP imdb.com | $AWK -F/ '{print $4}' | $SED 's/Details?/tt/g' | $SED 's/\">//g' | sed 's/ //g')
else
ImdbCodeDvdpt=$($CAT $TMPFILEDVDPT | $GREP imdb.com | $AWK -F/ '{print $5}' | sed 's/ //g')
fi
# echo ImdbCodeDvdpt:$ImdbCodeDvdpt
# Extrair informação (parse) CODIGO IMDB no DVDPT

# Extrair informação (parse) PLOT DVDPT
$SED -n '/<h1.*>/,/<\/p>/p' $TMPFILEDVDPT | $SED -n '/<p>/,/<\/p>/{ s/<[^>]*>//g;p;}' | $SED 's/SINOPSE.*//g' > $PLOTFILEDVDPT
#PLOTDVDPT=`$SED -n '/SINOPSE/,/<font color=red face=arial size=-1>/{ s/<[^>]*>//g;s/SINOPSE//g;s/REALIZADORES//g;s/REALIZADOR//g;p }' $TMPFILEDVDPT | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $SED 's/^  *//g' | $SED '/^$/d'| $SED 's/\t//g' | $ICONV -f ISO8859-1 -t UTF8`
PLOTDVDPT=`$SED -n '/SINOPSE/,/<font color=red face=arial size=-1>/{ s/<[^>]*>//g;s/SINOPSE//g;p }' $TMPFILEDVDPT | $SED -e :a -e 's/<[^>]*>//g;/</N;//ba' | $SED 's/^  *//g' | $SED '/^$/d'| $SED 's/\t//g' | $ICONV -f ISO8859-1 -t UTF8`
if [[ $PLOTDVDPT != "" ]]; then
PLOTDVDPT=`echo $PLOTDVDPT | $AWK '{print}END{print "Fonte: DVD PT"}'`
fi
# Extrair informação (parse) PLOT DVDPT
}

function processarSINOPSE () {
# Determinar a sinopse a utilizar
if [[ $ImdbCodeDvdpt != "" ]]; then
#echo "ImdbCodeDvdpt não esta vazio (1)"
	if [[ $ImdbCodeDvdpt != $ImdbCode ]]; then 
#		echo "ImdbCodeDvdpt sao diferentes"
		if [[ $ImdbCodePtgate != "" ]]; then
#			echo "ImdbCodePtgate não esta vazio"
			if [[ $ImdbCodePtgate == $ImdbCode ]]; then
#				echo "ImdbCodePtgate e ImdbCode sao iguais"
				if [[ $PLOTPTGATE != "Não existe uma sinopse para este filme. Adicionar uma sinopse." ]]; then
#					echo "PTGATE tem descrição"
					PLOT="$PLOTPTGATE"
#					echo -e "Descrição: $PLOT"
				else
#					echo "PTGATE não tem descrição"
					PLOT="$PLOTIMDB"
#					echo -e "Descrição: $PLOT"
				fi
			else
#			echo "ImdbCodePtgate e ImdbCode não são iguais"
			PLOT="$PLOTIMDB"
#			echo "Descrição: $PLOT"
			fi
		else
#		echo "ImdbCodePtgate esta vazio"
		PLOT="$PLOTIMDB"
#		echo -e "Descrição: $PLOT"
		fi
	else
#	echo "ImdbCodeDvdpt ImdbCode são iguais"
	PLOT="$PLOTDVDPT"
#	echo -e "Descrição: $PLOT"
	fi
else
#	echo Fase2
	if [[ $ImdbCodePtgate != "" ]]; then
#	echo "ImdbCodePtgate não esta vazio"
			if [[ $ImdbCodePtgate == $ImdbCode ]]; then 
#			echo "ImdbCodePtgate e ImdbCode sao iguais"
				if [[ $PLOTPTGATE != "Não existe uma sinopse para este filme. Adicionar uma sinopse." ]]; then
#					echo "PTGATE tem descrição"
					PLOT="$PLOTPTGATE"
#					echo -e "Descrição: $PLOT"
				else
#					echo "PTGATE não tem descrição"
					PLOT="$PLOTIMDB"
#					echo -e "Descrição: $PLOT"
				fi
			else
#			echo "ImdbCodePtgate e ImdbCode não são iguais"
			PLOT="$PLOTIMDB"
#			echo -e "Descrição: $PLOT"
			fi
	else
#	echo "ImdbCodePtgate esta vazio"
	PLOT="$PLOTIMDB"
#	echo "Descrição: $PLOT"
	fi
fi
# Determinar a sinopse a utilizar
}

#INI Processamento
#recolhaIMDB
recolhaIMDBC
recolhaDVDPT
recolhaPTGATE
processarSINOPSE
# END Processamento

# INI Impressão
printTitulo
printAno
printClassifica
printVotos
printDirectores
printGeneros
printActores
printSinopse
# printURLS
# END Impressão

# INI Remover lixo
rm $TMPFILEIMDB > /dev/null
rm $TMPFILEIMDBC > /dev/null
rm $TMPFILEIMDBCREDIT > /dev/null
rm $TMPFILEPTGATE > /dev/null
rm $TMPFILEDVDPT > /dev/null
rm $PLOTFILEIMDB > /dev/null
#rm $PLOTFILEIMDBC > /dev/null
rm $PLOTFILEPTGATE > /dev/null
rm $PLOTFILEDVDPT > /dev/null
# END Remover lixo
exit 0
