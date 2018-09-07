%{
    #include<stdio.h>
    int yywrap(void) {return 1;}
 
    int numTotalLinhas = 0;
    int numLinhasCodigo = 0;
    int numLinhasComentario = 0;
    int numLinhasBranco = 0;
    int numString = 0;
    int numPalavras = 0;
    /*NO CASO DO METODO ELE PODE CONSIDERAR PUBLIC VOID OU SOMENTE VOID*/
    /*NÃO ESTA SOMANDO CORRETAMENTE AS LINHAS EM BRANCO*/
%}

%x COMENT
%x COMENTS

WS      	[ \t]+
PALAVRA 	[a-zA-Z][a-zA-Z0-9]*
TEXT	        [^ \t\n]+
PALAVRAS	{PALAVRA}|{TEXT}s
ID 		'public'|'private'|'protectec'|'extends'
STRING 		\"[a-zA-Z][a-zA-Z0-9]*+\"
METODO 		{ID}+{PALAVRA}+{PALAVRA}|{PALAVRA}+{PALAVRA}+\(  

%%

<INITIAL>"/*"    		{BEGIN(COMENTS);}
<INITIAL>"//"	           	{BEGIN(COMENT);}
<INITIAL>Class+{PALAVRA} 	{printf("Classe: %s\n", yytext);}
{METODO}            {printf("Método: %s\n", yytext);}
{STRING} 			{numString++;numPalavras++;}
{PALAVRAS} 			{numPalavras++;}
{PALAVRAS}+\n 			{numLinhasCodigo++; numPalavras = 0;}
<COMENTS>\n        		{numLinhasComentario++;numPalavras = 0;}
<COMENT>\n         		{numLinhasComentario++;numPalavras = 0;BEGIN(INITIAL);}
<COMENTS>"*"+"/"		{numLinhasComentario++;BEGIN(INITIAL);}
<COMENTS,COMENT,INITIAL>\n 	{if(numPalavras == 0){numLinhasBranco++;};numTotalLinhas++;}
<COMENTS,COMENT,INITIAL>{WS}
<COMENTS,COMENT,INITIAL>.
 
%%
int main(int argc,char *argv[]){
    yyin=fopen(argv[1],"r");
    yylex();
       
    printf("Numero de linhas de código: %d\n", numTotalLinhas);
    printf("Numero de linhas de comentários: %d\n", numLinhasComentario);
    printf("Numero de linhas em branco: %d\n",numLinhasBranco);
    printf("Numero de strings: %d\n", numString);
}
