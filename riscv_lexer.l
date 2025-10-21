%{
#include "riscv_parser.hpp"
#undef yyterminate
#define YY_DECL yy::riscv_parser::symbol_type yylex(yy::location &loc)
#define yyterminate() return yy::riscv_parser::make_YYEOF(loc)

extern char* yytext;
%}

%option yylineno

%%

"ADD"       { return yy::riscv_parser::make_TOK_ADD(yytext, loc); }
"SUB"       { return yy::riscv_parser::make_TOK_SUB(yytext, loc); }
"LW"        { return yy::riscv_parser::make_TOK_LW(yytext, loc); }
"SW"        { return yy::riscv_parser::make_TOK_SW(yytext, loc); }
"LI"        { return yy::riscv_parser::make_TOK_LI(yytext, loc); }
"NOP"       { return yy::riscv_parser::make_TOK_NOP(yytext, loc); }

"x[0-9]+"   { return yy::riscv_parser::make_TOK_REGISTER(yytext, loc); }
[0-9]+      { return yy::riscv_parser::make_TOK_NUMBER(yytext, loc); }

","         { return yy::riscv_parser::make_TOK_COMMA(loc); }
"("         { return yy::riscv_parser::make_TOK_LPAREN(loc); }
")"         { return yy::riscv_parser::make_TOK_RPAREN(loc); }

[ \t\r\n]+  ; // ignore whitespace

. { 
    std::cerr << "Invalid token at line " << yylineno << ": '" << yytext << "'\n";
    exit(-1);
}

<<EOF>> { return yy::riscv_parser::make_YYEOF(loc); }

int yywrap() { return 1; }
