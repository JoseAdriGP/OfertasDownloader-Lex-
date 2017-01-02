/*----- Sección de Declaraciones --------------*/

final	[\n| |\t]
espacio [ ]
numero		[0-9]*
comilla	["]
discount	\-{numero}\%|\-\-{numero}\%|"N/A"
descuento	"earch"{comilla}">"{discount}
prix 	{numero}\.{numero}
precio 	"</span>"{espacio}{prix}\€
cualquiera	.*
initdiv	"me"{comilla}>
findiv	"</div>"
namegame	{initdiv}{cualquiera}*{findiv}


%{
#include <stdio.h>
int totalNombres, totalDescuentos, totalPrecios;
%}

/*----- Sección de Reglas ----------------*/
%%

.	{}
\n	{}
{namegame}	{totalNombres++; recortex(yytext,"me\"\>",0);}
{descuento}	{totalDescuentos++; recortex(yytext,"earch\">",1);}
{precio}	{totalPrecios++; recortex(yytext,"</span> ",2);}

%%

/*----- Sección de Procedimientos --------*/
int main (int argc, char *argv[]) {
	if (argc == 2) {
		yyin = fopen (argv[1], "rt");
		if (yyin == NULL) {
			printf ("El fichero %s no se puede abrir\n", argv[1]);
			exit (-1);
		}
	}

	else 
		yyin = stdin;

	
	yylex ();

	printf("Hemos encontrado %d Juegos\n",totalNombres);
	printf("Hemos encontrado %d Descuentos\n",totalDescuentos);
	printf("Hemos encontrado %d Precios\n",totalPrecios);
	
	return 0;
}

int recortex(char const *original, char const* inicio, int tipo){
	
	char nueva[90];
	int posicion = strlen(original) - strlen(strstr(original, inicio));
	int a;
	int b;

	for(a = 0; a<posicion; a++)
		nueva[a]=original[a];
	
	for(b=posicion; a< strlen(original); a++)
		nueva[a]=original[a+strlen(inicio)];

	if(tipo==0)	
		recort(nueva,"</div>");
	if(tipo==1) 
		printf("Descuento:\t%s\n", nueva);
	if(tipo==2) 
		printf("\tPrecio:\t%s\n", nueva);
	return 0;

}

int recort(char const *original, char const* final){
	
	char nueva[90];
	int posicion = strlen(original) - strlen(strstr(original, final));
	int a;
	int b;

	for(a = 0; a<posicion; a++)
		nueva[a]=original[a];
	
	for(b=posicion; a< strlen(original); a++)
		nueva[a]=original[a+strlen(final)];

	printf("\tNombre:\t%s\n", nueva);
	
	return 0;

}


