%{
    #include<stdio.h>
    int yywrap(void) {return 1;}
 
    int numTotalLinhas = 0;
    int numLinhasCodigo = 0;
    int numLinhasComentario = 0;
    int numLinhasBranco = 0;
    int numString = 0;
    int numPalavras = 0;
   
%}
 
%s COMENT
%s COMENTS
PALAVRA [a-zA-Z][a-zA-Z0-9]*
ID 'public'|'private'|'protectec'|'extends'
STRING \"[a-zA-Z][a-zA-Z0-9]*+\"
METODO {ID}+{PALAVRA}+{PALAVRA}
WS      [ \t]+
 
%%
{PALAVRA} {numPalavras++;}
{PALAVRA}+\n {numLinhasCodigo++; numPalavras = 0;}
<INITIAL>"/*"               {BEGIN(COMENTS);}
<INITIAL>"//"               {BEGIN(COMENT);}
<COMENTS>\n        {numLinhasComentario++;numPalavras = 0;}
<COMENT>\n         {numLinhasComentario++;numPalavras = 0;BEGIN(INITIAL);}
<COMENTS>"*/"      {numLinhasComentario++;BEGIN(INITIAL);}
<COMENTS,COMENT,INITIAL>\n {if(numPalavras == 0){numLinhasBranco++;};numTotalLinhas++;}
{STRING} {numString++;numPalavras = 0;}
{WS}
.
 
%%
int main(int argc,char *argv[]){
    yyin=fopen(argv[1],"r");
    yylex();
       
    printf("Numero de linhas de código: %d\n", numTotalLinhas);
    printf("Numero de linhas de comentários: %d\n", numLinhasComentario);
    printf("Numero de linhas em branco: %d\n",numLinhasBranco);
    printf("Numero de strings: %d\n", numString);
    printf("Classes: %d\n", 0);
}