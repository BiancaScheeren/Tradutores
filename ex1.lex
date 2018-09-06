%{
	#include<stdio.h>
	#include<stdlib.h>
	int yywrap(void) {return 1;}
	
	
	typedef struct PDiferentes{
		struct PDiferentes* next;
		char* palavra;
	}PalavrasDiferentes;

	
        PalavrasDiferentes* ListaPalavras;
	int numPalavras = 0;
	int numPalavrasFrase = 0;
	int numFrases = 0;
	int numPalavrasDiferentes = 0;
	int numNode = 0;
        FILE *outf;

	PalavrasDiferentes* buscaPalavra(char* palav, PalavrasDiferentes* Lista){
		PalavrasDiferentes* p;
		p = Lista; 
		while (p != NULL && p->palavra != palav){		
			p = p->next; 
		}
		return p;
	};

	void printx(PalavrasDiferentes* Lista){
		PalavrasDiferentes* p = Lista;	
		numNode = 0;
		while(p != NULL){
			printf("print: %s\n", p->palavra);
			p = p->next;	
			numNode++;	
		};
	};

	void insereSeNaoExiste(PalavrasDiferentes * Lista, char* p){		
		PalavrasDiferentes* novo = (PalavrasDiferentes*) malloc(sizeof(PalavrasDiferentes));
                //char* palavra = p;
		if(!novo){
			printf("Sem memoria disponivel!\n");
			exit(1);
		};
		if (buscaPalavra(p, Lista) == NULL) {
			novo->palavra = p;
			printf("novo: %s\n", novo->palavra);
			if(Lista != NULL)			
				printf("lista: %s\n", Lista->palavra);
			novo->next = Lista;
			Lista = novo;
			
			numPalavrasDiferentes++;
		};
         }; 

	

	
%}

PALAVRA [a-zA-Z][a-zA-Z0-9]*
TERMINAL "."|"!"|"?"

%%
{PALAVRA}	{numPalavras++; numPalavrasFrase++; insereSeNaoExiste(ListaPalavras, yytext);}
{TERMINAL}              {if (numPalavrasFrase > 0){numFrases++; numPalavrasFrase = 0;}}
\n|\t|.
%%
int main(int argc,char *argv[]){
	if (argc > 0) 
		yyin=fopen(argv[1],"r");
	else
		yyin = stdin;
        	
        outf = fopen("stats.txt", "wt");

	ListaPalavras = (PalavrasDiferentes*)malloc(sizeof(PalavrasDiferentes));
        yylex();
        
	if(numPalavrasFrase > 0)
		numFrases++;
	fprintf(outf, "Numero de palavras: %d\n", numPalavras);
	fprintf(outf, "Numero de frases: %d\n", numFrases);
	fprintf(outf, "Numero de palavras diferentes: %d\n", numPalavrasDiferentes);
	fprintf(outf, "Numero médio de palavras por frase: %f\n", numPalavras/numFrases);
	fprintf(outf, "Densidade léxica do texto: %f\n", (numPalavrasDiferentes/numPalavras) * 100.f);
        fclose(outf);
}

