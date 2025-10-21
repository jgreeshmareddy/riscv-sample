#ifndef RISCV_PARSER_HPP
#define RISCV_PARSER_HPP

#include <string>
#include <vector>
#include <memory>
#include <cstdio>

struct InstructionNode {
    std::string name;
    std::vector<std::string> operands;
};

extern std::vector<std::shared_ptr<InstructionNode>> programInstructions;

namespace yy {
    struct location;
    class riscv_parser;
    class symbol_type;
}

yy::parser::symbol_type yylex(yy::location &loc);

#endif 
