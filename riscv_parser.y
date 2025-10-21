%language "c++"
%define api.value.type variant
%define api.token.constructor
%define api.namespace {yy}

%locations
%lex-param { yy::location &loc }
%parse-param { yy::location &loc }

%code requires {
#include <iostream>
#include <vector>
#include <string>
#include <memory>

struct InstructionNode {
    std::string instr;
    std::vector<std::string> operands;
};

std::vector<std::shared_ptr<InstructionNode>> instructions;
}

%token<std::string> TOK_ADD TOK_SUB TOK_LW TOK_SW TOK_LI TOK_NOP
%token<std::string> TOK_REGISTER TOK_NUMBER
%token TOK_COMMA TOK_LPAREN TOK_RPAREN

%start program

%%

program:
    /* empty */
  | program line
  ;

line:
    instr '\n' { /* successfully parsed line */ }
  ;

instr:
    TOK_ADD TOK_REGISTER TOK_COMMA TOK_REGISTER TOK_COMMA TOK_REGISTER {
        auto node = std::make_shared<InstructionNode>();
        node->instr = "ADD";
        node->operands = {$2, $4, $6};
        instructions.push_back(node);
    }
  | TOK_SUB TOK_REGISTER TOK_COMMA TOK_REGISTER TOK_COMMA TOK_REGISTER {
        auto node = std::make_shared<InstructionNode>();
        node->instr = "SUB";
        node->operands = {$2, $4, $6};
        instructions.push_back(node);
    }
  | TOK_LW TOK_REGISTER TOK_COMMA TOK_NUMBER TOK_LPAREN TOK_REGISTER TOK_RPAREN {
        auto node = std::make_shared<InstructionNode>();
        node->instr = "LW";
        node->operands = {$2, $4, $6};
        instructions.push_back(node);
    }
  | TOK_SW TOK_REGISTER TOK_COMMA TOK_NUMBER TOK_LPAREN TOK_REGISTER TOK_RPAREN {
        auto node = std::make_shared<InstructionNode>();
        node->instr = "SW";
        node->operands = {$2, $4, $6};
        instructions.push_back(node);
    }
  | TOK_LI TOK_REGISTER TOK_COMMA TOK_NUMBER {
        auto node = std::make_shared<InstructionNode>();
        node->instr = "LI";
        node->operands = {$2, $4};
        instructions.push_back(node);
    }
  | TOK_NOP {
        auto node = std::make_shared<InstructionNode>();
        node->instr = "NOP";
        instructions.push_back(node);
    }
  ;

%%

// Print the AST nicely
void print_riscv_ast() {
    std::cout << "=== RISC-V AST ===\n";
    for (size_t i = 0; i < instructions.size(); i++) {
        auto &instr = instructions[i];
        std::cout << i+1 << ". Instruction: " << instr->instr << "\n";
        if (!instr->operands.empty()) {
            std::cout << "   Operands: ";
            for (auto &op : instr->operands) std::cout << op << " ";
            std::cout << "\n";
        }
    }
    std::cout << "=================\n";
}

// Generate AST from file
void generate_riscv_ast(const std::string &filename) {
    FILE *yyin = std::fopen(filename.c_str(), "r");
    if (!yyin) {
        std::cerr << "Error opening file: " << filename << "\n";
        exit(-1);
    }

    yy::location loc;
    yy::riscv_parser parser(loc);
    yy::yyin = yyin;

    if (parser.parse()) {
        std::cerr << "Parsing failed!\n";
        exit(-1);
    }

    std::fclose(yyin);
    print_riscv_ast();
}
