type pos = int
type svalue = Tokens.svalue
 
type ('a,'b) token = ('a,'b) Tokens.token
type lexresult = (svalue, pos) token


val lineNum = ErrorMsg.lineNum 
val linePos = ErrorMsg.linePos 

fun err(p1,p2) = ErrorMsg.error p1 
fun eof() = let val pos = hd(!linePos) in Tokens.EOF(pos,pos) end

%%

alpha =[a-zA-Z] ;
digit =[0-9] ;
whitespace=[\t\ ]+;
 

%%
\n 							=> (lineNum := !lineNum + 1; linePos := yypos::(!linePos); continue());
{whitespace}  				=> (continue());
  
"for" 						=>		(Tokens.FOR(yypos,yypos+3));
"while"						=>		(Tokens.WHILE(yypos,yypos+5));
"if"						=>		(Tokens.IF(yypos,yypos+2));
"else"						=>		(Tokens.ELSE(yypos,yypos+4));
"printf"  					=>		(Tokens.PRINTF(yypos,yypos+6));
 
{digit}+                 	=>		(Tokens.INT(valOf(Int.fromString yytext),yypos,yypos+size yytext));

{alpha}({alpha}|{digit})* 	=>		(Tokens.ID(yytext,yypos,yypos+size(yytext)));
"<="			    		=>		(Tokens.LE(yypos,yypos+2));
">="    					=>		(Tokens.GE(yypos,yypos+2));
"=="			    		=>		(Tokens.EQ(yypos,yypos+2));
"!="			    		=>		(Tokens.NE(yypos,yypos+2));
">"							=>		(Tokens.GT(yypos,yypos+1));
"<"							=>		(Tokens.LT(yypos,yypos+1));
"="							=>		(Tokens.ASSIGN(yypos,yypos+1));
"||"						=>		(Tokens.OR(yypos,yypos+2));			
"&&"						=>		(Tokens.AND(yypos,yypos+2));	
"("							=>		(Tokens.LPAREN(yypos,yypos+1));
")"							=>		(Tokens.RPAREN(yypos,yypos+1));
"{"							=>		(Tokens.LBRACE(yypos,yypos+1));
"}"							=>		(Tokens.RBRACE(yypos,yypos+1));
";"							=>		(Tokens.SEMICOLON(yypos,yypos+1));
","							=>		(Tokens.COMMA(yypos,yypos+1));

"+"							=>		(Tokens.PLUS(yypos,yypos+1));
"-"							=>		(Tokens.MINUS(yypos,yypos+1));
"/"							=>		(Tokens.DIVIDE(yypos,yypos+1));
"*"							=>		(Tokens.TIMES(yypos,yypos+1));


.       					=> (ErrorMsg.error yypos ("illegal character:" ^ "|" ^ yytext ^ "|"); continue());
