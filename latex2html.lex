alfabeto        [a-zA-Z\.\,\|\;\:áäàâÁÄÀÂéëêèÉËÈÊíïìîÍÏÌÎóöòôÓÖÒÔúùûüÚÜÙûçÇñÑ]
digitos         [0-9]
punto           (\.)
decimal         ({digitos}({punto}?{digitos}*))
espacio         [' ']
palabra         ({alfabeto}+)
texto           ((({palabra}?({espacio}*{palabra}))*({digitos}?({espacio}*{digitos})*)*)*)
llave           (\{|\})
negrita         (\\textbf)
cursiva         (\\textit)
subrayada       (\\underline)
capitulo        (\\chapter)
seccion         (\\section)
subseccion      (\\subsection)
subsubseccion   (\\subsubsection)
edescripcion    (\\begin\{description\})
fdescripcion    (\\end\{description\})
itemdesc        (\\item\[{texto}\])
enlace          (\\href|\\url)
link            ({enlace}{llave}{palabra}{llave}{llave}{texto}{llave})
imagen          (\\includegraphics\[width={decimal}\\textwidth\])
parametros      (\[{texto}\])
eenum           (\\begin\{enumerate\}{parametros}?|\\begin\{itemize\})
fenum           (\\end\{enumerate\}|\\end\{itemize\})
item            (\\item)
cabecera        (\\documentclass{parametros}?{llave}{palabra}{llave})
utf             (\\usepackage\[utf8\]\{inputenc\})
paquete         (\\usepackage{parametros}?{llave}{palabra}{llave})
edoc            (\\begin\{document\})
fdoc            (\\end\{document\})
porcentaje      ({digitos}{espacio}?\\\%)
comentario      (\%{texto}*)
titulo          (\\title{llave}{texto}{llave})
saltolinea      (\n)
parrafo         ({saltolinea}{palabra}?{digitos}?{decimal}?({saltolinea}*{texto})*{saltolinea})
etabla          (\\begin{llave}tabular{llave}{llave}{texto}{llave})
ftabla          (\\end{llave}tabular{llave})
lineah          (\\hline)
ampersand       (\&)
cambiolinea     (\\\\)
endfila         ({texto}{espacio}?{cambiolinea})
fila            ({texto}{espacio}{ampersand}{espacio}?)
filata          ({fila}*{endfila})
            char word[50]; int i;
%%
{negrita}{llave}{texto}{llave}          {memcpy(&word, &yytext[8], strlen(&yytext[8])-1);
                                        printf("<b>%s</b>", word);
                                        strncpy(word, "\0", strlen(word));}
{cursiva}{llave}{texto}{llave}          {memcpy(&word, &yytext[8], strlen(&yytext[8])-1);
                                        printf("<i>%s</i>", word);
                                        strncpy(word, "\0", strlen(word));}
{subrayada}{llave}{texto}{llave}        {memcpy(&word, &yytext[11], strlen(&yytext[11])-1);
                                        printf("<u>%s</u>", word);
                                        strncpy(word, "\0", strlen(word));}
{capitulo}{llave}{texto}{llave}         {memcpy(&word, &yytext[9], strlen(&yytext[9])-1);
                                        printf("<h1>%s</h1>",word);
                                        strncpy(word, "\0", strlen(word));}
{seccion}{llave}{texto}{llave}          {memcpy(&word, &yytext[9], strlen(&yytext[9])-1);
                                        printf("<h2>%s</h2>",word);
                                        strncpy(word, "\0", strlen(word));}
{subseccion}{llave}{texto}{llave}       {memcpy(&word, &yytext[12], strlen(&yytext[12])-1);
                                        printf("<h3>%s</h3>",word);
                                        strncpy(word, "\0", strlen(word));}
{subsubseccion}{llave}{texto}{llave}    {memcpy(&word, &yytext[15], strlen(&yytext[15])-1);
                                        printf("<h4>%s</h4>",word);
                                        strncpy(word, "\0", strlen(word));}
{edescripcion}                          {;}
{fdescripcion}                          {;}
{itemdesc}                              {memcpy(&word, &yytext[6], strlen(&yytext[6])-1);
                                        printf("<h5>%s</h5>", word);
                                        strncpy(word, "\0", strlen(word));}
{link}                                  {i = (yytext[1]=='u') ? 5 : 6;
                                        char * w; char * w1;
                                        w = strtok(&yytext[i],"}"); i += strlen(w)+2;
                                        w1 = strtok(&yytext[i],"}");
                                        printf("<a href=\"%s\">%s</a>", w, w1);}
{imagen}{llave}{texto}{llave}           {char * nombre; nombre = strtok(yytext,"{");
                                        nombre = strtok(NULL,"}"); 
                                        memcpy(&word, nombre, strlen(nombre));
                                        if (strstr(nombre, ".jpg") == NULL && 
                                            strstr(nombre, ".png") == NULL) {
                                            word[strlen(nombre)] = '.'; 
                                            word[strlen(nombre)+1] = '*';
                                            char aux1[] = "/bin/find . -name "; char * comando;
                                            comando = malloc(strlen(aux1) + strlen(word)+1);
                                            strcpy(comando, aux1); strcat(comando, word);
                                            FILE * p = popen(comando, "r"); char fichero[100];
                                            if(p){
                                                while(fgets(fichero, sizeof(fichero), p) != NULL){}
                                                fichero[strlen(fichero)-1] = 0;
                                                printf("<img src=\"%s\"/>", fichero);
                                            }
                                            strncpy(word, "\0", strlen(word));
                                        } else printf("<img src=\"%s\" />", word);}
{eenum}                                 {printf("<ul>");}
{fenum}                                 {printf("</ul>");}
{item}{espacio}{texto}                  {memcpy(&word, &yytext[6], strlen(&yytext[6]));
                                        printf("<li>%s</li>", word);
                                        strncpy(word, "\0", strlen(word));}
{utf}                                   {printf("<meta charset=\"utf-8\">");}
{cabecera}                              {printf("<!DOCTYPE html>\n<html>\n<head>");}
{paquete}                               {;}
{edoc}                                  {printf("</head>\n<body>");}
{fdoc}                                  {printf("</body>\n</html>");}
{comentario}                            {;}
{titulo}                                {memcpy(&word, &yytext[7], strlen(&yytext[7])-1);
                                        printf("<title>%s</title>", word);
                                        strncpy(word, "\0", strlen(word));}
{parrafo}                               {printf("<p>%s</p>",yytext);}
{etabla}                                {printf("<table>");}
{ftabla}                                {printf("</table>");}
{lineah}                                {;}
{filata}                                {printf("<tr>\n"); char * fila; 
                                        fila = strtok(yytext,"&\\");
                                        while(fila != NULL){
                                            printf("<td>%s</td>\n",fila);
                                            fila = strtok(NULL,"&\\");
                                        } printf("</tr>\n");}
{porcentaje}                            {memcpy(&word, yytext, strlen(yytext));
                                        word[strlen(yytext)] = '%'; char * text;
                                        text = strtok(word,"%");
                                        while (text != NULL){
                                            text[strlen(text)-1] = '%';
                                            printf("%s",text);
                                            text = strtok(NULL,"%");
                                        } strncpy(word, "\0", strlen(word));}
%%
yywrap()
        {return 1;}