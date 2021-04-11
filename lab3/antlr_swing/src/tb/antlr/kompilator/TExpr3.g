tree grammar TExpr3;

options {
  tokenVocab=Expr;

  ASTLabelType=CommonTree;

  output=template;
  superClass = TreeParserTmpl;
}

@header {
package tb.antlr.kompilator;
}


prog    : (e+= blok | e+=expr | d+=decl)* -> program(name={$e},deklaracje={$d});

blok : ^(ES { enterScope(); }(e1 += blok | e1+=expr | d1+=decl)* { leaveScope(); }) -> blok(expressions = {$e1}, declarations = {$d1});

decl  :
        ^(VAR i1=ID) {globals.newSymbol($ID.text);} -> dek(n={$ID.text})
    ;
    catch [RuntimeException ex] {errorID(ex,$i1);}

expr    : ^(PLUS  e1=expr e2=expr) -> add(p1={$e1.st},p2={$e2.st})
        | ^(MINUS e1=expr e2=expr) -> sub(p1={$e1.st},p2={$e2.st})
        | ^(MUL   e1=expr e2=expr) -> mul(p1={$e1.st},p2={$e2.st})
        | ^(DIV   e1=expr e2=expr) -> div(p1={$e1.st},p2={$e2.st})
        | ^(PODST i1=ID   e2=expr)
        | ID                       -> id(n={$ID.text})
        | INT                      -> int(i={$INT.text})
        | ^(IF e1=expr e2=expr e3=expr?)    -> if(e1={$e1.st},e2={$e2.st},e3={$e3.st})
    ;
    